//
// Created by Jorn on 2019-02-21.
// Copyright (c) 2019 Jorn Wu(jornwucn@gmail.com). All rights reserved.
//

import Foundation
import UIKit
/********************************************
 * public const value
 ********************************************/
let kTHEME_BOCKGROUND_COLOR = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5034386004)
let kTHEME_CONTROL_COLOR = #colorLiteral(red: 0.9548080764, green: 0.9548080764, blue: 0.9548080764, alpha: 0.88)
let kTHEME_BUBBLE_COLOR = #colorLiteral(red: 0.8261432323, green: 0.2285042842, blue: 1, alpha: 1)
let kTHEME_TEXT_COLOT = UIColor.blue
let kMAIN_SCREEN_WIDTH = UIScreen.main.bounds.size.width
let kMAIN_SCREEN_HEIGHT = UIScreen.main.bounds.size.height

let kTARGET_LANGUAGE_LIST = ["English", "Japanese", "Korean",
                             "Spanish", "Russian", "French",
                             "German", "Thai", "Vietnamese",
                             "Indonesian", "Malay", "Italian",
                             "Portuguese", "Turkish"]

/********************************************
 * api
 * 区域	取值
 * 亚太地区(曼谷)	ap-bangkok
 * 华北地区(北京)	ap-beijing
 * 西南地区(成都)	ap-chengdu
 * 西南地区(重庆)	ap-chongqing
 * 华南地区(广州)	ap-guangzhou
 * 华南地区(广州Open)	ap-guangzhou-open
 * 东南亚地区(中国香港)	ap-hongkong
 * 亚太地区(孟买)	ap-mumbai
 * 亚太地区(首尔)	ap-seoul
 * 华东地区(上海)	ap-shanghai
 * 华东地区(上海金融)	ap-shanghai-fsi
 * 华南地区(深圳金融)	ap-shenzhen-fsi
 * 东南亚地区(新加坡)	ap-singapore
 * 欧洲地区(法兰克福)	eu-frankfurt
 * 美国东部(弗吉尼亚)	na-ashburn
 * 美国西部(硅谷)	na-siliconvalley
 * 北美地区(多伦多)	na-toronto
 ********************************************/
let kMAIN_DOMAIN_NAME = "https://tmt.tencentcloudapi.com"
let kMAIN_REGION = "ap-guangzhou"

let kPROJECT_ID = "1139572"
let kPROJECT_SECRET_ID = "AKIDMDpNZojX8HsYAhtVq0zmSzPeigT6ot68"
let kPROJECT_SECRET_KEY = "GXhgU9qRsAPc2KQPEsOn1WwCHDzbFl6I"

let kMAIN_ACTION_IMAGE_TRANSLATE = "ImageTranslate"
let kMAIN_ACTION_LANGUAGE_DETECT = "LanguageDetect"
let kMAIN_ACTION_SPEECH_TRANSLATE = "SpeechTranslate"
let kMAIN_ACTION_TEXT_TRANSLATE = "TextTranslate"

let kPUBLIC_REQUEST_PARAM_ACTION = "X-TC-Action"
let kPUBLIC_REQUEST_PARAM_REGION = "X-TC-Region"
let kPUBLIC_REQUEST_PARAM_TIMESTAMP = "X-TC-Timestamp"
let kPUBLIC_REQUEST_PARAM_VERSION = "X-TC-Version"
let kPUBLIC_REQUEST_PARAM_AUTHORIZATION = "Authorization"
let kPUBLIC_REQUEST_PARAM_TOKEN = "X-TC-Token"

/********************************************
 * print
 ********************************************/
struct JWLog {

    private enum LogLeve: Int {
        case DISABLE
        case ERROR
        case WARN
        case INFO
        case DEBUG
    }

    private static let LOG_LEVEL = LogLeve.DEBUG
    
    public static func d(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        if LOG_LEVEL.rawValue >= LogLeve.DEBUG.rawValue {
            print("DEBUG: ", terminator: "")
            print(items, separator: separator, terminator: terminator)
        }
    }
    
    public static func i(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        if LOG_LEVEL.rawValue >= LogLeve.INFO.rawValue {
            print("INFORMATION: ", terminator: "")
            print(items, separator: separator, terminator: terminator)
            
        }
    }
    
    public static func w(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        if LOG_LEVEL.rawValue >= LogLeve.WARN.rawValue {
            print("WARNINF: ", terminator: "")
            print(items, separator: separator, terminator: terminator)
        }
    }
    
    public static func e(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        if LOG_LEVEL.rawValue >= LogLeve.ERROR.rawValue {
            print("ERROR: ", terminator: "")
            print(items, separator: separator, terminator: terminator)
        }
    }
    
    private init() {
        
    }
}



