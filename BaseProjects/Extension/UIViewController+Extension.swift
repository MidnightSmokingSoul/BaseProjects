//
//  UIViewController+Extension.swift
//  UIViewController+Extension
//
//  Created by 张轩赫 on 2021/1/12.
//

import UIKit

extension UIViewController {
    
    // MARK: - Storyboard 初始化
    
    /// 从指定 Storyboard 根据类名初始化控制器（Storyboard ID 必须与类名一致）
    class func initByName(storyboardName: String) -> Self {
        return instantiateFromStoryboardHelper(storyboardName: storyboardName, storyboardId: nameOfClass)
    }

    private class func instantiateFromStoryboardHelper<T>(storyboardName: String, storyboardId: String) -> T {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: storyboardId) as? T else {
            fatalError("找不到 ID 为 \(storyboardId) 的控制器")
        }
        return controller
    }

    /// 获取当前类名
    class var nameOfClass: String {
        NSStringFromClass(self).components(separatedBy: ".").last!
    }
    
    // MARK: - 导航栏样式
    
    ///导航栏透明
    func setTransparentNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        appearance.shadowColor = .clear
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    ///导航栏不透明
    func setOpaqueNavigationBar(backgroundColor: UIColor = .white, titleColor: UIColor = .black) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = backgroundColor
        appearance.titleTextAttributes = [.foregroundColor: titleColor]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    // MARK: - UI 尺寸辅助
    
    /// 导航栏高度
    var navigationBarHeight: CGFloat {
        navigationController?.navigationBar.frame.height ?? 0
    }

    /// 状态栏高度
    var statusBarHeight: CGFloat {
        if #available(iOS 13.0, *) {
            return (UIApplication.shared.connectedScenes.first as? UIWindowScene)?
                .statusBarManager?.statusBarFrame.height ?? 0
        } else {
            return UIApplication.shared.statusBarFrame.height
        }
    }

    /// 导航栏 + 状态栏高度
    var totalNavBarHeight: CGFloat {
        navigationBarHeight + statusBarHeight
    }

    /// 顶部安全区域高度
    var safeAreaTopHeight: CGFloat {
        if #available(iOS 13.0, *) {
            return (UIApplication.shared.connectedScenes.first as? UIWindowScene)?
                .windows.first?.safeAreaInsets.top ?? 0
        } else {
            return UIApplication.shared.statusBarFrame.height
        }
    }

    /// tabBar 高度
    var tabBarHeight: CGFloat {
        tabBarController?.tabBar.frame.height ?? 0
    }

    /// 底部安全区域高度
    var safeAreaBottomHeight: CGFloat {
        if #available(iOS 13.0, *) {
            return (UIApplication.shared.connectedScenes.first as? UIWindowScene)?
                .windows.first?.safeAreaInsets.bottom ?? 0
        } else {
            return UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
        }
    }

    /// tabBar + 底部安全区域高度
    var totalTabBarHeight: CGFloat {
        tabBarHeight + safeAreaBottomHeight
    }
    
    // MARK: - 返回按钮设置

    /// 设置左侧返回按钮（支持图文）
    func setLeftTitle(title: String = "", imagePadding: CGFloat = 10) {
        let navBarHeight = navigationController?.navigationBar.frame.height ?? 44
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: navBarHeight))

        let button: UIButton
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.plain()
            config.imagePlacement = .leading
            config.imagePadding = imagePadding
            button = UIButton(configuration: config)
        } else {
            button = UIButton(type: .custom)
            button.titleEdgeInsets = UIEdgeInsets(top: 0, left: imagePadding, bottom: 0, right: -imagePadding)
        }

        button.setTitle(title, for: .normal)
        button.setImage(UIImage(named: "返回"), for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(menuTapped), for: .touchUpInside)
        button.sizeToFit()
        button.center.y = containerView.center.y

        containerView.addSubview(button)
        containerView.sizeToFit()
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: containerView)
    }

    /// 返回按钮点击事件（默认 pop，可 override）
    @objc func menuTapped() {
        navigationController?.popViewController(animated: true)
    }
}
