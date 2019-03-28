//
//  TranslateViewModel.swift
//  FanYi
//
//  Created by Jorn on 2019/3/20.
//  Copyright © 2019 Jorn Wu(jornwucn@gmail.com). All rights reserved.
//

import UIKit
import CommonCrypto

final class TranslateViewModel: NSObject {
    
    public func translate(keyWord: String) /*-> TranslationModel*/ {
        var param = [String: Any]();
        
        param["SourceText"] = keyWord
        param["Source"] = "zh"
        param["Target"] = "en"
        param["ProjectId"] = kPROJECT_ID
        
//        let payload = "{\"SourceText\":\"\(keyWord)\",\"Source\":\"zh\",\"Target\":\"en\",\"ProjectId\":\(kPROJECT_ID)}"
//        let pubParam = createPublicParam_V3(action: .TextTranslate, payload: payload)
        let pubParam = createPublicParam_V1(action: .TextTranslate, baseParam: param)
        
        param.merge(pubParam) {$1}
        
        NetworkeEngine.loadNetworkeDate(URLString: kMAIN_URL,
                                        requestType: .GET,
                                        parameters: param as NSDictionary) {
            (result: NSDictionary) in
            ///
            
            
        }
    }
    
    private func createPublicParam_V1(action: ActionType, baseParam: [String: Any]) -> [String: Any] {
        var publicParam = (baseParam as NSDictionary).copy() as! [String: Any]
        
        publicParam["Action"] = action.rawValue
        publicParam["Version"] = kPUBLIC_VALUE_VERSION
        publicParam["Region"] = kPUBLIC_VALUE_REGION
        publicParam["SecretId"] = kPROJECT_SECRET_ID
        publicParam["Nonce"] = arc4random_uniform(UInt32.max)
        publicParam["Timestamp"] = NSInteger(Date().timeIntervalSince1970)
        publicParam["Token"] = ""
        
        let sortedParam = publicParam.sorted { (arg0, arg1) -> Bool in
            let (key0, _) = arg0
            let (key1, _) = arg1
            
             return key0 < key1
        }
        
        let hash = HMAC_Sign(algorithm: CCHmacAlgorithm(kCCHmacAlgSHA1),
                             keyBytes: kPROJECT_SECRET_KEY.data(using: .utf8)! as NSData,
                             dataString: pairs2SignString(sortedParam)!)
            
        publicParam["Signature"] = urlEncode(base64Encode(hash.bytes, count: hash.length))

        JWLog.d(publicParam)

        return publicParam
    }
    
    private func createPublicParam_V3(action: ActionType, payload: String) -> [String: Any] {
        let timestamp = NSInteger(Date().timeIntervalSince1970)
        let algorithm = "TC3-HMAC-SHA256"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        let utcDate = dateFormatter.string(from: Date())
        
        /// 步骤 1：拼接规范请求串
        let httpRequestMethod = "POST"
        let canonicalUri = "/"
        let canonicalQueryString = ""
        let canonicalHeaders = "content-type:\(kPUBLIC_VALUE_JSON)\n"
            + "host:" + kPUBLIC_VALUE_HOST + "\n"
        let signedHeaders = "content-type;host"
        let hashedRequestPayload = hexSHA256_sign(payload)
        let canonicalRequest = httpRequestMethod + "\n"
            + canonicalUri + "\n"
            + canonicalQueryString + "\n"
            + canonicalHeaders + "\n"
            + signedHeaders + "\n"
            + hashedRequestPayload
        
        JWLog.d("canonicalRequest: " + canonicalRequest)
        
        /// 步骤 2：拼接待签名字符串
        let credentialScope = utcDate + "/" + kPUBLIC_VALUE_SERVICE + "/" + "tc3_request"
        let hashedCanonicalRequest = hexSHA256_sign(canonicalRequest)
        let stringToSign = algorithm + "\n"
            + "\(timestamp)" + "\n"
            + credentialScope + "\n"
            + hashedCanonicalRequest
        
        JWLog.d("stringToSign: " + stringToSign)
        
        /// 步骤 3：计算签名
        let date = ("TC3" + kPROJECT_SECRET_KEY).data(using: .utf8)! as NSData
        let secretDate = HMAC_Sign(algorithm: CCHmacAlgorithm(kCCHmacAlgSHA256),
                                   keyBytes: date,
                                   dataString: utcDate)
        
        let secretService = HMAC_Sign(algorithm: CCHmacAlgorithm(kCCHmacAlgSHA256),
                                      keyBytes: secretDate,
                                      dataString: kPUBLIC_VALUE_SERVICE)
        
        let secretSigning = HMAC_Sign(algorithm: CCHmacAlgorithm(kCCHmacAlgSHA256),
                                      keyBytes: secretService,
                                      dataString: "tc3_request")
        
        let signature = hexEncode(HMAC_Sign(algorithm: CCHmacAlgorithm(kCCHmacAlgSHA256),
                                            keyBytes: secretSigning,
                                            dataString: stringToSign) as Data);
        
        JWLog.d("signature: " + signature);
        
        /// 步骤 4：拼接 Authorization
        let authorization = algorithm + " "
            + "Credential=" + kPROJECT_SECRET_ID + "/"
            + credentialScope + ", "
            + "SignedHeaders=" + signedHeaders + ", "
            + "Signature=" + signature;
        
        JWLog.d("authorization: " + authorization);
        
        return [kPUBLIC_REQUEST_PARAM_AUTHORIZATION: authorization,
                kPUBLIC_REQUEST_PARAM_ACTION: action.rawValue,
                kPUBLIC_REQUEST_PARAM_REGION: kPUBLIC_VALUE_REGION,
                kPUBLIC_REQUEST_PARAM_TIMESTAMP: timestamp,
                kPUBLIC_REQUEST_PARAM_VERSION: kPUBLIC_VALUE_VERSION]
    }
    
    private func hexSHA256_sign(_ dataString: String) -> String {
        let data = dataString.data(using: .utf8)! as NSData
        var cSHA256 = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        CC_SHA256(data.bytes, CC_LONG(data.count), &cSHA256)
        
        var hexString = ""
        for byte in cSHA256 {
            hexString += String(format: "%02x", byte)
        }
        
        return hexString
    }

    private func HMAC_Sign(algorithm: CCHmacAlgorithm,
                           keyBytes: NSData,
                           dataString: String) -> NSData {
        if algorithm != kCCHmacAlgSHA1 && algorithm != kCCHmacAlgSHA256 {
            JWLog.e("Unsupport algorithm.")
            return NSData()
        }
        
        let data = dataString.data(using: .utf8)! as NSData
        let len = algorithm == CCHmacAlgorithm(kCCHmacAlgSHA1) ?
            CC_SHA1_DIGEST_LENGTH : CC_SHA256_DIGEST_LENGTH
        var cHMAC = [UInt8](repeating: 0, count: Int(len))
        
        CCHmac(algorithm, keyBytes.bytes, keyBytes.count,
               data.bytes, data.count, &cHMAC)
        
        return NSData(bytes: &cHMAC, length: cHMAC.count)
    }
    
    private func dec2bin(_ number: Int) -> String {
        var num = number
        var str = ""
        while num > 0 {
            str = "\(num % 2)" + str
            num /= 2
        }
        return str
    }
    
    private func pairs2SignString(_ pairs: [(String, Any)]) -> String? {
        var str = ""
        pairs.forEach { (key: String, value: Any) in
            str += "\(key)=\(value)" + "&"
        }
        
        let index = str.index(str.endIndex, offsetBy: -1)
        str = "GETtmt.tencentcloudapi.com/?" + String(str[..<index])
        
        JWLog.d("pairs2SignString:" + str)
        
        return str
    }
    
    private func base64Encode(_ bytes: UnsafeRawPointer, count: Int) -> String {
        let base64Data = Data(bytes: bytes, count: count)
        let base64String = base64Data.base64EncodedString()
        return base64String
    }
    
    private func hexEncode(_ data: Data) -> String {
        var hexString = ""
        for byte in data {
            hexString += String(format: "%02x", byte)
        }
        
        return hexString
    }
    
    private func urlEncode(_ string: String) -> String {
        let newString = string.addingPercentEncoding(withAllowedCharacters:
            CharacterSet(charactersIn: "!*'();:@&=+$,/?%#[]{} ").inverted)
        
        return newString ?? ""
    }
}

