//
//  UserInfoModel.swift
//  用户信息
//
//  Created by 张轩赫 on 2022/12/7.
//

//import UIKit
//import SwiftyJSON
//
//class UserInfoModel: BaseModel {
//
//    var token: String?
//    
//    static var current_user: UserInfoModel? {
//        get {
//            guard let data =
//                    UserDefaultsDataBase.stringForKey(key: Config.OAuthConfig.current_user_key) else { return nil }
//            let user = UserInfoModel.deserialize(from: data)
//            return (user?.token != nil) ? user : nil
//        }
//        set {
//            UserDefaultsDataBase.storeModelObject(data: newValue, key: Config.OAuthConfig.current_user_key)
//        }
//    }
//    
//    func save() {
//        synchronized(lock: UserInfoModel.current_user) {
//            guard let user = UserInfoModel.current_user else { UserInfoModel.current_user = self; return }
//            UserDefaultsDataBase.storeModelObject(data: user,key: Config.OAuthConfig.current_user_key)
//        }
//    }
//    
//    func synchronized(lock: Any?, closure: () -> ()) {
//        guard let lock = lock else { closure(); return }
//        objc_sync_enter(lock)
//        closure()
//        objc_sync_exit(lock)
//    }
//    
//}

import SmartCodable
import SwiftyUserDefaults

// 你的用户模型，继承 BaseModel，遵守 DefaultsSerializable
struct UserInfoModel: BaseModel, DefaultsSerializable {
    
    var token: String?
    var name: String?
    
    // 当前登录用户
    static var current: UserInfoModel? {
        get { Defaults[\.currentUser] }
        set { Defaults[\.currentUser] = newValue }
    }

    // 是否登录
    static var isLoggedIn: Bool {
        return current?.token?.isEmpty == false
    }

    // 保存自己为当前用户
    func saveAsCurrent() {
        UserInfoModel.current = self
    }

    // 清除当前用户
    static func logout() {
        Defaults[\.currentUser] = nil
    }
}

// SwiftyUserDefaults Key 扩展
extension DefaultsKeys {
    var currentUser: DefaultsKey<UserInfoModel?> { .init("current_user") }
}
