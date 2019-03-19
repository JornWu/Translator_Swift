//
//  Utils.swift
//  FanYi
//
//  Created by Jorn on 2019/3/19.
//  Copyright © 2019 Jorn Wu(jornwucn@gmail.com). All rights reserved.
//

import UIKit

final class Utils {
    private init() {
        
    }
    
    public class func showShareActivity(inViewcontroller: BaseViewController,
                                 content: String, image: UIImage, url: String) {
        let finalUrl = URL(string: url)
        let activityItems = [content, image, finalUrl as Any];
        
        let avc = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        avc.excludedActivityTypes = [.airDrop, .openInIBooks, .postToTencentWeibo,
                                     .postToVimeo, .postToFlickr, .postToWeibo,
                                     .postToTwitter, .postToFacebook, .message]
        avc.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, activityError: Error?) -> Void in
                if completed {
                    JWLog.i("Sharing completed.")
                }
            }
        
        inViewcontroller.present(avc, animated: true, completion: nil)
    }
}
