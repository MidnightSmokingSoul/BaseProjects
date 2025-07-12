//
//  Int+Extension.swift
//  数字转字符串
//
//  Created by 张轩赫 on 2022/12/7.
//

import UIKit

extension BinaryInteger {
    
    /// 将数字转为简洁缩写，如 1.2k、3.4w
    func abbreviatedString() -> String {
        let doubleValue = Double(self)
        return doubleValue.abbreviatedString()
    }
}

extension Double {
    
    /// 去除小数点后多余的 0，例如 2.0 => 2
    var cleanZero: String {
        truncatingRemainder(dividingBy: 1) == 0
            ? String(format: "%.0f", self)
            : String(format: "%.2f", self)
    }

    /// 将数字转为简洁缩写，如 1.2k、3.4w、5.6m
    func abbreviatedString() -> String {
        switch self {
        case 1_000..<10_000:
            return (self / 1_000).cleanZero + "k"
        case 10_000..<1_000_000:
            return (self / 10_000).cleanZero + "w"
        case 1_000_000...:
            return (self / 1_000_000).cleanZero + "m"
        default:
            return cleanZero
        }
    }
}
