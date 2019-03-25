//
//  StorageManager.swift
//  FanYi
//
//  Created by Jorn on 2019/3/19.
//  Copyright © 2019 Jorn Wu(jornwucn@gmail.com). All rights reserved.
//

import UIKit
import CoreData

struct StorageManager {
    private static let userDefault = UserDefaults.standard

    static func save(value: Any?, key: String) {
        userDefault.set(value, forKey: key)
    }
    
    static func get(key: String) -> Any? {
        return userDefault.object(forKey: key)
    }
    
    static func remove(key: String) {
        userDefault.removeObject(forKey: key)
    }
    
    
    
    
    
    
    ///
    private init() {

    }
}
