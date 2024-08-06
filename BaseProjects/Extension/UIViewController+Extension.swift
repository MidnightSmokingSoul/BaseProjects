//
//  UIViewController+Extension.swift
//  UIViewController+Extension
//
//  Created by 张轩赫 on 2021/1/12.
//

import UIKit

extension UIViewController {
    
    @objc class func initByName(storyboardName: String) -> Self {
        return instantiateFromStoryboardHelper(storyboardName: storyboardName, storyboardId: nameOfClass)
    }
    private class func instantiateFromStoryboardHelper<T>(storyboardName: String, storyboardId: String) -> T {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: storyboardId) as! T
        return controller
    }
    
    class var nameOfClass: String {
        NSStringFromClass(self).components(separatedBy: ".").last!
    }
    
    /**
     navigationBar高度
     */
    var navigationBarHeight: CGFloat {
        if let navigationController = self.navigationController {
            return navigationController.navigationBar.frame.height
        }
        return 0
    }
    /**
     状态栏高度
     */
    var statusBarHeight: CGFloat {
        if #available(iOS 13.0, *) {
            let scene = UIApplication.shared.connectedScenes.first
            guard let windowScene = scene as? UIWindowScene else { return 0 }
            guard let statusBarManager = windowScene.statusBarManager else { return 0 }
            return statusBarManager.statusBarFrame.height
        } else {
            return UIApplication.shared.statusBarFrame.height
        }
    }
    /**
     navigationBar和状态栏高度
     */
    var totalNavBarHeight: CGFloat {
        return navigationBarHeight + statusBarHeight
    }
    /**
     顶部安全区域高度
     */
    var safeAreaTopHeight: CGFloat {
        if #available(iOS 13.0, *) {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                return windowScene.windows.first?.safeAreaInsets.top ?? 0.0
            }
            return 0
        } else {
            return UIApplication.shared.statusBarFrame.height
        }
    }
    /**
     底部导航栏高度
     */
    var tabBarHeight: CGFloat {
        return tabBarController?.tabBar.frame.height ?? 0
    }
    /**
     底部安全区域高度
     */
    var safeAreaBottomHeight: CGFloat {
        if #available(iOS 13.0, *) {
            let scene = UIApplication.shared.connectedScenes.first
            guard let windowScene = scene as? UIWindowScene else { return 0 }
            guard let window = windowScene.windows.first else { return 0 }
            return window.safeAreaInsets.bottom
        } else {
            guard let window = UIApplication.shared.windows.first else { return 0 }
            return window.safeAreaInsets.bottom
        }
    }
    /**
     底部导航栏和安全区域高度
     */
    var totalTabBarHeight: CGFloat {
        return tabBarHeight + safeAreaBottomHeight
    }
    
    /** 获取当前控制器 */
    @objc static func current() -> UIViewController {
        let scene = UIApplication.shared.connectedScenes.first
        guard let windowScene = scene as? UIWindowScene else { return keyWindow?.rootViewController ?? UIViewController() }
        let vc = windowScene.windows.filter({$0.isKeyWindow}).first?.rootViewController
        return UIViewController.findBest(vc: vc!)
    }
    
    private static func findBest(vc: UIViewController) -> UIViewController {
        if vc.presentedViewController != nil {
            return UIViewController.findBest(vc: vc.presentedViewController!)
        } else if vc.isKind(of: UISplitViewController.self) {
            let svc = vc as! UISplitViewController
            if svc.viewControllers.count > 0 {
                return UIViewController.findBest(vc: svc.viewControllers.last!)
            } else {
                return vc
            }
        } else if vc.isKind(of: UINavigationController.self) {
            let svc = vc as! UINavigationController
            if svc.viewControllers.count > 0 {
                return UIViewController.findBest(vc: svc.topViewController!)
            } else {
                return vc
            }
        } else if vc.isKind(of: UITabBarController.self) {
            let svc = vc as! UITabBarController
            if (svc.viewControllers?.count ?? 0) > 0 {
                return UIViewController.findBest(vc: svc.selectedViewController!)
            } else {
                return vc
            }
        } else {
            return vc
        }
    }
    
    func setLeftTitle(title: String = "", imagePadding: CGFloat = 10) {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: self.navigationController?.navigationBar.frame.height ?? 44))
        if #available(iOS 15.0, *) {
            var conf = UIButton.Configuration.plain()
            conf.imagePlacement = .leading
            conf.imagePadding = imagePadding
            let button = UIButton(configuration: conf, primaryAction: nil)//UIButton(type: .custom)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            button.addTarget(self, action: #selector(menuTapped), for: .touchUpInside)
            button.setTitleColor(.black, for: .normal)
            button.setImage(UIImage(named: "返回"), for: .normal)
            button.setTitle(title, for: .normal)
            button.sizeToFit()
            button.center.y = containerView.center.y
            containerView.addSubview(button)
        } else {
            let button = UIButton(type: .custom)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            button.addTarget(self, action: #selector(menuTapped), for: .touchUpInside)
            button.setTitleColor(.black, for: .normal)
            button.setImage(UIImage(named: "返回"), for: .normal)
            button.setTitle(title, for: .normal)
            button.titleEdgeInsets = UIEdgeInsets(top: 0, left: imagePadding, bottom: 0, right: -imagePadding)
            button.sizeToFit()
            button.center.y = containerView.center.y
            containerView.addSubview(button)
        }
        containerView.sizeToFit()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: containerView)
    }
    
    @objc func menuTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}
