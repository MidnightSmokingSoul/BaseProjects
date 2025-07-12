//
//  LoginTool.swift
//  DDT
//
//  Created by 张轩赫 on 2025/7/11.
//

import UIKit

struct LoginTool {
    
    /// 尝试执行需要登录的操作，未登录时自动跳登录页，登录后再执行
    static func performAuthorizedAction(from viewController: UIViewController, authorizedAction: @escaping () -> Void) {
        
        if UserInfoModel.isLoggedIn {
            authorizedAction()
        } else {
            showLogin(currentVC: viewController) {
                // 登录成功后执行原操作
                authorizedAction()
            }
        }
    }
    
    /// 弹出登录页面，可传入登录完成回调
    static func showLogin(currentVC: UIViewController, completion: (() -> Void)? = nil) {
        // 防止重复 push
        if !APP.current.isKind(of: LoginViewController.self) {
            let login = LoginViewController()
            login.loginSuccessCallback = {
                completion?()
            }
            login.modalPresentationStyle = .fullScreen
            login.modalTransitionStyle = .crossDissolve
            
            currentVC.present(login, animated: true)
        }
    }
}
