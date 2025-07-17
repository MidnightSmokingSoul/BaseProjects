//
//  UserInfoModel.swift
//  用户信息
//
//  Created by 张轩赫 on 2022/12/7.
//

import SmartCodable
import SwiftyUserDefaults

// 用户模型，继承 BaseModel，遵守 DefaultsSerializable
struct UserInfoModel: BaseModel, DefaultsSerializable {
    
    var token: String?
    var language: String?
    var openId: String?
    var nickName: String?
    var city: String?
    var country: String?
    var inviteCode: String?
    var unionId: String?
    var sex: Int = 0
    var avatarUrl: String?
    var userId: Int = 0
    var codeId: Int = 0
    var wxNum: String?
    var province: String?
    var phone: String?
    
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
        current = nil
        Defaults[\.currentUser] = nil
    }
}

// SwiftyUserDefaults Key 扩展
extension DefaultsKeys {
    var currentUser: DefaultsKey<UserInfoModel?> { .init("current_user") }
}
