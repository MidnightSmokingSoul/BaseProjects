//
//  LoginTool.swift
//  DDT
//
//  Created by 张轩赫 on 2025/7/11.
//

import UIKit

struct LoginTool {
    
    /// 尝试执行需要登录的操作，未登录时自动跳登录页，登录后再执行
    static func performAuthorizedAction(authorizedAction: () -> Void, loginCallback: @escaping () -> Void = {}) {
        
        if UserInfoModel.isLoggedIn {
            authorizedAction()
        } else {
            showLogin {
                // 登录成功后执行原操作
                loginCallback()
            }
        }
    }
    
    /// 弹出登录页面，可传入登录完成回调
    static func showLogin(completion: (() -> Void)? = nil) {
        // 防止重复 push
        if !App.currentVC.isKind(of: LoginViewController.self) {
            let login = LoginViewController.initByName(storyboardName: "Home")
            login.loginSuccessCallback = {
                completion?()
            }
            login.modalPresentationStyle = .fullScreen
            login.modalTransitionStyle = .crossDissolve
            
            App.currentVC.present(login, animated: true)
        }
    }
    
    // 清除当前用户
    static func logout() {
        UserInfoModel.logout()
    }
}
