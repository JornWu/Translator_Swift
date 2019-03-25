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
        var param = createPublicParam_V3(action: .TextTranslate)
        let sourceText = keyWord.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        param["SourceText"] = sourceText
        param["Source"] = "zh"
        param["Target"] = "en"
        param["ProjectId"] = kPROJECT_ID
        param["Content-Type"] = "application/json"
        param["Host"] = "tmt.tencentcloudapi.com"
        param["SignatureMethod"] = "HmacSHA256"
        
        NetworkeEngine.loadNetworkeDate(URLString: kMAIN_URL, requestType: .POST, parameters: param as NSDictionary) { (result: NSDictionary) in
            ///
            
            
        }
    }
    
    private func createPublicParam_V1(action: ActionType) -> [String: Any] {
        var publicParam = [String: Any]()
        
        publicParam["Action"] = action.rawValue
        publicParam["Version"] = kPUBLIC_VALUE_VERSION
        publicParam["Region"] = kPUBLIC_VALUE_REGION
        publicParam["SecretId"] = kPROJECT_SECRET_ID
        publicParam["Nonce"] = 2019//arc4random_uniform(UInt32.max)
        publicParam["Timestamp"] = NSInteger(Date().timeIntervalSince1970)
        
        let sortedParam = publicParam.sorted { (arg0, arg1) -> Bool in
            let (key0, _) = arg0
            let (key1, _) = arg1
            
             return key0 < key1
        }
        
        publicParam["Signature"] = urlEncode(HMAC_Sign(algorithm: CCHmacAlgorithm(kCCHmacAlgSHA1),
                                                       keyString: kPROJECT_SECRET_KEY,
                                                       dataString: pairs2SignString(sortedParam)!))

        JWLog.d(publicParam)

        return publicParam
    }
    
    private func createPublicParam_V3(action: ActionType) -> [String: Any] {
        let timestamp = Date().timeIntervalSince1970
        let algorithm = "TC3-HMAC-SHA256"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        let utcDate = dateFormatter.string(from: Date())
        
        /// 步骤 1：拼接规范请求串
        let httpRequestMethod = "POST"
        let canonicalUri = "/"
        let canonicalQueryString = "Limit=10&Offset=0"
        let canonicalHeaders = "content-type:\(kPUBLIC_VALUE_JSON)\n"
            + "host:" + kPUBLIC_VALUE_HOST + "\n"
        let signedHeaders = "content-type;host"
        let payload = ""
        let hashedRequestPayload = "\(payload.hash)"
        let canonicalRequest = httpRequestMethod + "\n"
            + canonicalUri + "\n"
            + canonicalQueryString + "\n"
            + canonicalHeaders + "\n"
            + signedHeaders + "\n"
            + hashedRequestPayload
        
        JWLog.d("canonicalRequest: " + canonicalRequest)
        
        /// 步骤 2：拼接待签名字符串
        let credentialScope = utcDate + "/" + kPUBLIC_VALUE_SERVICE + "/" + "tc3_request"
        let hashedCanonicalRequest = "\(canonicalRequest.hash)"
        let stringToSign = algorithm + "\n" + "\(timestamp)" + "\n"
            + credentialScope + "\n" + hashedCanonicalRequest
        
        JWLog.d("stringToSign: " + stringToSign)
        
        /// 步骤 3：计算签名
        let secretDate = HMAC_Sign(algorithm: CCHmacAlgorithm(kCCHmacAlgSHA256),
                                   keyString: "TC3" + kPROJECT_SECRET_KEY,
                                   dataString: utcDate)
        
        let secretService = HMAC_Sign(algorithm: CCHmacAlgorithm(kCCHmacAlgSHA256),
                                      keyString: secretDate,
                                      dataString: kPUBLIC_VALUE_SERVICE)
        
        let secretSigning = HMAC_Sign(algorithm: CCHmacAlgorithm(kCCHmacAlgSHA256),
                                      keyString: secretService,
                                      dataString: "tc3_request")
        
        let signature = HMAC_Sign(algorithm: CCHmacAlgorithm(kCCHmacAlgSHA256),
                                  keyString: secretSigning,
                                  dataString: stringToSign);
        
        JWLog.d("signature: " + signature);
        
        /// 步骤 4：拼接 Authorization
        let authorization = algorithm + " " + "Credential=" + kPROJECT_SECRET_ID + "/"
            + credentialScope + ", " + "SignedHeaders=" + signedHeaders + ", " + "Signature=" + signature;
        
        JWLog.d("authorization: " + authorization);
        
        return [kPUBLIC_REQUEST_PARAM_AUTHORIZATION: authorization,
                kPUBLIC_REQUEST_PARAM_ACTION: action.rawValue,
                kPUBLIC_REQUEST_PARAM_REGION: kPUBLIC_VALUE_REGION,
                kPUBLIC_REQUEST_PARAM_TIMESTAMP: NSInteger(timestamp),
                kPUBLIC_REQUEST_PARAM_VERSION: kPUBLIC_VALUE_VERSION]
    }

    private func HMAC_Sign(algorithm: CCHmacAlgorithm, keyString: String, dataString: String) -> String {
        if algorithm != kCCHmacAlgSHA1 && algorithm != kCCHmacAlgSHA256 {
            JWLog.e("Unsupport algorithm.")
            return ""
        }
        
        let cKeyString = keyString.cString(using: .utf8)
        let cDataString = dataString.cString(using: .utf8)
        
        let len = algorithm == CCHmacAlgorithm(kCCHmacAlgSHA1) ? CC_SHA1_DIGEST_LENGTH : CC_SHA256_DIGEST_LENGTH
        var cHMAC = [UInt8](repeating: 0, count: Int(len))
        CCHmac(algorithm, cKeyString, keyString.count, cDataString, dataString.count, &cHMAC)
        
        /// 结果十六进制数据Base64编码
//        var hexString = ""
//        for byte in cHMAC {
//            hexString += String(format: "%02x", byte)
//        }
//
//        let base64Data = Data(bytes: hexString.cString(using: .utf8)!, count: hexString.count)
        
        /// 原结果二进制数据Base64编码
        let base64Data = Data(bytesNoCopy: &cHMAC, count: Int(len), deallocator: Data.Deallocator.none)
        let base64String = base64Data.base64EncodedString()
        
        return base64String
    }
    
    private func decTobin(number: Int) -> String {
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
    
    private func urlEncode(_ string: String) -> String {
        let newString = string.addingPercentEncoding(withAllowedCharacters: CharacterSet(charactersIn: "!*'();:@&=+$,/?%#[]{} ").inverted)
        
        return newString ?? ""
    }
}

