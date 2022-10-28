//
//  UserDefaultsDataBase.swift
//  偏好设置储存
//
//  Created by 张轩赫 on 2022/10/25.
//

import UIKit

class UserDefaultsDataBase: NSObject {
    static let userDefaults = UserDefaults.standard
    
    class func storeModelObject(data: BaseModel?, key: String) {
        let str = data?.toJSONString()
        userDefaults.set(str, forKey: key)
    }
    
    class func setString(value: String, for Key: String) {
        userDefaults.set(value, forKey: Key)
    }
    class func stringForKey(key: String) -> String? {
        return userDefaults.string(forKey: key)
    }
    
    class func setInteger(value: Any, for Key: String) {
        userDefaults.set(value, forKey: Key)
    }
    class func integerForKey(key: String) -> Int {
        return userDefaults.integer(forKey: key)
    }
    
    class func setDouble(value: Double, for Key: String) {
        userDefaults.set(value, forKey: Key)
    }
    class func doubleForKey(key: String) -> Double {
        return userDefaults.double(forKey: key)
    }
    
    class func setBool(value: Bool, for Key: String) {
        userDefaults.set(value, forKey: Key)
    }
    class func boolForKey(key: String) -> Bool {
        return userDefaults.bool(forKey: key)
    }
    
}
