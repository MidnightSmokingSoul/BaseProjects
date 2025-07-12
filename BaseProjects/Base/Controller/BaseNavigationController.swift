//
//  BaseNavigationController.swift
//  根NavigationController
//
//  Created by 张轩赫 on 2022/12/8.
//

import UIKit

class BaseNavigationController: UINavigationController, UIGestureRecognizerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interactivePopGestureRecognizer?.delegate = self
        
        // 配置导航栏外观
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = .white
        
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        UINavigationBar.appearance().tintColor = .black
        
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if responds(to: #selector(getter: interactivePopGestureRecognizer)) {
            interactivePopGestureRecognizer?.isEnabled = false
        }
        if children.count >= 1 {
            viewController.hidesBottomBarWhenPushed = true
            let leftImage = UIBarButtonItem(image: UIImage(named: "返回"), style: .plain, target: self, action: #selector(popViewController(animated:)))
            viewController.navigationItem.setLeftBarButtonItems([leftImage], animated: true)
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer == interactivePopGestureRecognizer else {
            return true
        }
        return viewControllers.count > 1
    }
}

extension BaseNavigationController: UINavigationControllerDelegate {
    open func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        //  rootViewController 不能有手势返回
        if navigationController.responds(to: #selector(getter: interactivePopGestureRecognizer))
            && navigationController.viewControllers.count > 1 {
            navigationController.interactivePopGestureRecognizer?.isEnabled = true
        } else {
            navigationController.interactivePopGestureRecognizer?.isEnabled = false
        }
    }
}
