//
//  Date+Extension.swift
//  Date+Extension
//
//  Created by 张轩赫 on 2021/1/12.
//

import UIKit

// MARK: - Date 扩展
extension Date {
    
    /// 从 `/Date(1653811200000+0800)/` 格式的字符串初始化 Date
    public init?(fromDateTimeString: String) {
        let pattern = "\\\\?/Date\\((\\d+)(([+-]\\d{2})(\\d{2}))?\\)\\\\?/"
        let regex = try! NSRegularExpression(pattern: pattern)
        let match = regex.rangeOfFirstMatch(in: fromDateTimeString, range: NSRange(location: 0, length: fromDateTimeString.utf16.count))
        
        var dateString = fromDateTimeString
        if match.location != NSNotFound {
            dateString = (fromDateTimeString as NSString).substring(with: match)
        }
        
        let substrings = dateString.components(separatedBy: CharacterSet.decimalDigits.inverted)
        guard let timestamp = substrings.compactMap({ Double($0) }).first else { return nil }
        self.init(timeIntervalSince1970: timestamp / 1000.0)
    }
    
    /// 将时间戳格式化为展示字符串
    /// 智能格式：今天显示时间、同周显示“星期几+时间”、其余显示日期
    static func formattedString(from timeInterval: TimeInterval) -> String {
        guard timeInterval > 0 else {
            // 默认返回20年前的时间
            let date = Calendar.current.date(byAdding: .year, value: -20, to: Date())!
            return date.toString("yyyy-MM-dd")
        }
        
        let date = Date(timeIntervalSince1970: timeInterval)
        let now = Date()
        let difference = now.timeIntervalSince(date)
        
        if difference < 86400 { // 一天内
            return date.toString("HH:mm")
        }
        
        let calendar = Calendar.current
        if calendar.isDate(date, equalTo: now, toGranularity: .weekOfYear) {
            let weekdayStr = calendar.component(.weekday, from: date).weekdayString()
            return "星期\(weekdayStr) \(date.toString("HH:mm"))"
        }
        
        return date.toString("yyyy-MM-dd HH:mm")
    }
    
    /// 格式化为 yyyy-MM-dd
    static func plainDate(from timeInterval: TimeInterval) -> String {
        guard timeInterval > 0 else {
            let date = Calendar.current.date(byAdding: .year, value: -20, to: Date())!
            return date.toString("yyyy-MM-dd")
        }
        let date = Date(timeIntervalSince1970: timeInterval / 1000)
        return date.toString("yyyy-MM-dd")
    }

    /// 将时间戳转为“刚刚”、“3分钟前”等相对时间格式
    static func relativeTime(from timeStamp: Double) -> String {
        let time = Date(timeIntervalSince1970: timeStamp / 1000)
        let interval = Date().timeIntervalSince(time)
        
        if interval < 60 {
            return "刚刚"
        } else if interval < 3600 {
            return "\(Int(interval / 60))分钟前"
        } else if interval < 86400 {
            return "\(Int(interval / 3600))小时前"
        } else if interval < 2592000 {
            return "\(Int(interval / 86400))天前"
        } else {
            return "30天前"
        }
    }
    
    /// 当前时间与该日期的时间差（“几天前”、“几分钟前”...）
    public var timeAgo: String {
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self, to: Date())
        
        if let year = components.year, year > 0 { return "\(year)年前" }
        if let month = components.month, month > 0 { return "\(month)月前" }
        if let day = components.day, day > 0 { return "\(day)天前" }
        if let hour = components.hour, hour > 0 { return "\(hour)小时前" }
        if let minute = components.minute, minute > 0 { return "\(minute)分钟前" }
        if let second = components.second, second > 0 { return "\(second)秒前" }
        
        return "刚刚"
    }
    
    /// 自定义格式化日期
    func toString(_ format: String, locale: Locale = Locale(identifier: "zh_CN")) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = locale
        formatter.timeZone = .current
        return formatter.string(from: self)
    }
}

extension Int {
    /// 秒转为“HH时MM分SS秒”
    static func secondToTimeString(_ second: Int) -> String {
        guard second > 0 else { return "00时00分00秒" }
        
        let h = second / 3600
        let m = (second % 3600) / 60
        let s = second % 60
        
        let hStr = h > 9 ? "\(h)" : "0\(h)"
        let mStr = m > 9 ? "\(m)" : "0\(m)"
        let sStr = s > 9 ? "\(s)" : "0\(s)"
        
        return "\(hStr)时\(mStr)分\(sStr)秒"
    }
    
    /// 将 1~7 映射为“日”~“六”
    func weekdayString() -> String {
        switch self {
        case 1: return "日"
        case 2: return "一"
        case 3: return "二"
        case 4: return "三"
        case 5: return "四"
        case 6: return "五"
        case 7: return "六"
        default: return ""
        }
    }
}
