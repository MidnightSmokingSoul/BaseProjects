//
//  Toast.swift
//  提示框
//
//  Created by 张轩赫 on 2024/7/25.
//

import UIKit

struct Toast {
    static func makeToast(message: String) {
        keyWindow?.makeToast(message, duration: 1, position: .center)
    }
    static func showToast() {
        keyWindow?.makeToastActivity(.center)
    }
    static func hideAllToasts() {
        keyWindow?.hideAllToasts(includeActivity: true)
    }
}
