//
//  Toast.swift
//  提示框
//
//  Created by 张轩赫 on 2024/7/25.
//

import UIKit
import Toast_Swift

struct Toast {
    
    private static var keyWindow: UIWindow? {
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
    
    static func makeToast(message: String, duration: TimeInterval = 1.0, position: ToastPosition = .center) {
        keyWindow?.makeToast(message, duration: duration, position: position)
    }
    
    static func showToast(position: ToastPosition = .center) {
        keyWindow?.makeToastActivity(position)
    }
    
    static func hideAllToasts() {
        keyWindow?.hideAllToasts(includeActivity: true)
    }
}
