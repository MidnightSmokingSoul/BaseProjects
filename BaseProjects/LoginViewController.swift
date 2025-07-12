//
//  LoginViewController.swift
//  BaseProjects
//
//  Created by 张轩赫 on 2025/7/12.
//

import UIKit

class LoginViewController: UIViewController {

    //登录成功之后回调给原来的地方
    var loginSuccessCallback: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func handleLoginSuccess() {
        // 登录成功后回调
        loginSuccessCallback?()
        // 返回或关闭登录页
        navigationController?.popViewController(animated: true)
    }

}
