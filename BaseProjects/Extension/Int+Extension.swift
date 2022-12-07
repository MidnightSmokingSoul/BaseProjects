//
//  Int+Extension.swift
//  数字转字符串
//
//  Created by 张轩赫 on 2022/12/7.
//

import UIKit

extension Int {
    ///数字超过一定数量变文字
    func numberToString() -> String {
        if self >= 1000 && self < 10000 {
            let num: Double = Double(self) / 1000.0
            return num.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0fk", num) : String(format: "%.1fk", num)
        }
        if self >= 10000 {
            let num: Double = Double(self) / 10000.0
            return num.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0fw", num) : String(format: "%.1fw", num)
        }
        return String(self)
    }
}

extension Double {
    /// 小数点后如果只是0，显示整数，如果不是，显示原来的值
    var cleanZero : String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
    ///数字超过一定数量变文字
    func numberToString() -> String {
        if self >= 1000 && self < 10000 {
            let num: Double = Double(self) / 1000.0
            return String(format: "%.2fk", num)
        }
        if self >= 10000 && self < 1000000 {
            let num: Double = Double(self) / 10000.0
            return String(format: "%.2fw", num)
        }
        if self >= 1000000 {
            let num: Double = Double(self) / 10000.0
            return String(format: "%.2fm", num)
        }
        return String(self)
    }
}
