//
//  Utils.swift
//  DDT
//
//  Created by 张轩赫 on 2025/7/11.
//

import UIKit

public let kScreenWidth = UIScreen.main.bounds.width
public let kScreenHeight = UIScreen.main.bounds.height

public var keyWindow: UIWindow? {
    if #available(iOS 15, *) {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first(where: { $0.activationState == .foregroundActive })?
            .windows
            .first(where: { $0.isKeyWindow })
    } else {
        return UIApplication.shared.windows.first(where: { $0.isKeyWindow })
    }
}

public func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

struct APP {
    
    // MARK: - 当前控制器获取

    /// 获取当前最顶层控制器
    static var current: UIViewController {
        let scene = UIApplication.shared.connectedScenes.first
        let root = (scene as? UIWindowScene)?.windows.first(where: { $0.isKeyWindow })?.rootViewController
        return findBest(vc: root ?? UIViewController())
    }

    private static func findBest(vc: UIViewController) -> UIViewController {
        if let presented = vc.presentedViewController {
            return findBest(vc: presented)
        } else if let split = vc as? UISplitViewController, let last = split.viewControllers.last {
            return findBest(vc: last)
        } else if let nav = vc as? UINavigationController, let top = nav.topViewController {
            return findBest(vc: top)
        } else if let tab = vc as? UITabBarController, let selected = tab.selectedViewController {
            return findBest(vc: selected)
        } else {
            return vc
        }
    }
    
    ///项目版本号
    static func appVersion() -> String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    }
    
    ///震动反馈📳
    static func impactFeedbackGenerator(style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        let impact = UIImpactFeedbackGenerator(style: style)
        impact.prepare()
        impact.impactOccurred()
    }

}
