//
//  NetworkeEngine.swift
//  MeiTuan_Swift
//
//  Created by JornWu on 16/8/15.
//  Copyright © 2016年 Jorn.Wu(jorn_wza@sina.com). All rights reserved.
//

import UIKit
import Foundation

struct NetworkeEngine {
    
    enum RequestType {
        case GET
        case POST
    }
    
    static func request(urlString: NSString,
                        requestType: RequestType,
                        parameters: NSDictionary?,
                        progress: ((_ progress: Progress) -> Void)?,
                        success: @escaping (_ task: URLSessionDataTask, _ responseObject: Any?) -> Void,
                        failure: @escaping (_ task: URLSessionDataTask?, _ error: Error) -> Void) {
        
        let configuration = URLSessionConfiguration.default
        let httpsManager = AFHTTPSessionManager(sessionConfiguration: configuration)

        let security = AFSecurityPolicy.default()
        security.allowInvalidCertificates = true
        security.validatesDomainName = false
        httpsManager.securityPolicy = security

        httpsManager.requestSerializer.timeoutInterval = 15

        var dataTask: URLSessionDataTask?;
        switch requestType {
        case .GET:
            dataTask = httpsManager.get(urlString as String,
                                        parameters: parameters,
                                        progress: progress,
                                        success: success,
                                        failure: failure)
        case .POST:
            dataTask = httpsManager.post(urlString as String,
                                        parameters: parameters,
                                        progress: progress,
                                        success: success,
                                        failure: failure)
        }

        guard let task = dataTask else {
            JWLog.e("data task is null.")
            return;
        }
        
        task.resume()
    }

    /*
     系统同时提供了几种并发队列。这些队列和它们自身的QoS等级相关。QoS等级表示了提交任务的意图，使得GCD可以决定如何制定优先级。
     
     QOS_CLASS_USER_INTERACTIVE： user interactive 等级表示任务需要被立即执行以提供好的用户体验。使用它来更新UI，
     响应事件以及需要低延时的小工作量任务。这个等级的工作总量应该保持较小规模。
     QOS_CLASS_USER_INITIATED：   user initiated 等级表示任务由UI发起并且可以异步执行。它应该用在用户需要即时
     的结果同时又要求可以继续交互的任务。
     QOS_CLASS_UTILITY：         utility 等级表示需要长时间运行的任务，常常伴随有用户可见的进度指示器。
     使用它来做计算，I/O，网络，持续的数据填充等任务。这个等级被设计成节能的。
     QOS_CLASS_BACKGROUND：       background 等级表示那些用户不会察觉的任务。使用它来执行预加载，
     维护或是其它不需用户交互和对时间不敏感的任务。
     */
    static func loadNetworkeDate(URLString: String,
                                 requestType: RequestType,
                                 parameters: NSDictionary?,
                                 result: @escaping (_ dictionary: NSDictionary) -> Void) {
        ///封装放到子线中去
        DispatchQueue.global(qos: .utility).async {

            NetworkeEngine.request(urlString: URLString as NSString,
                    requestType: requestType,
                    parameters: parameters,
                    progress: nil,
                    success: {
                        (task: URLSessionDataTask, responseObject: Any?) in
                        JWLog.i("----获取数据成功----", responseObject ?? "--null--")
                        ///返回主线程刷新UI
                        DispatchQueue.main.async(execute: {
                            result(responseObject as! NSDictionary)
                        })

                    },
                    failure: {
                        (task: URLSessionDataTask?, responseObject: Error) in
                        JWLog.i("----获取数据失败----", responseObject.localizedDescription)
                    })
        }
    }
}
