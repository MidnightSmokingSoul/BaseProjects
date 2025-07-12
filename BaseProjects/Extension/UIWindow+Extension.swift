//
//  UIWindow+Extension.swift
//  UIWindow+Extension
//
//  Created by 张轩赫 on 2022/12/15.
//

import UIKit

extension UIWindow {

    /// 判断当前是否为横屏方向
    static var isLandscape: Bool {
        if #available(iOS 13.0, *) {
            // iOS 13 及以上，从已激活的 windowScene 中获取方向
            return UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .first(where: { $0.activationState == .foregroundActive })?
                .interfaceOrientation.isLandscape ?? false
        } else {
            // iOS 13 以下使用旧的方式
            return UIApplication.shared.statusBarOrientation.isLandscape
        }
    }
}
