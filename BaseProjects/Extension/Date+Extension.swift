//
//  Date+Extension.swift
//  Date+Extension
//
//  Created by 张轩赫 on 2021/1/12.
//

import UIKit

extension Date {
    
    public init?(fromDateTimeString: String) {
        let pattern = "\\\\?/Date\\((\\d+)(([+-]\\d{2})(\\d{2}))?\\)\\\\?/"
        let regex = try! NSRegularExpression(pattern: pattern)
        let match: NSRange = regex.rangeOfFirstMatch(in: fromDateTimeString, range: NSRange(location: 0, length: fromDateTimeString.utf16.count))
        var dateString: String = ""
        if match.location == NSNotFound {
            dateString = fromDateTimeString
        } else {
            dateString = (fromDateTimeString as NSString).substring(with: match)     // Extract milliseconds
        }
        let substrings = dateString.components(separatedBy: CharacterSet.decimalDigits.inverted)
        guard let timeStamp = (substrings.compactMap { Double($0) }.first) else { return nil }
        self.init(timeIntervalSince1970: timeStamp / 1000.0) // Create Date from timestamp
    }
    
    static func dateToString(timeInterval: TimeInterval) -> String {
        if timeInterval.isNaN || timeInterval <= 0 {
            let currentdata = Date()
            let calendar = Calendar(identifier: .gregorian)
            var datecomps = DateComponents()
            datecomps.year = -20
            if let calculatedate = calendar.date(byAdding: datecomps, to: currentdata) {
                let fmt = DateFormatter()
                fmt.dateFormat = "yyyy-MM-dd"
                let calculateStr = fmt.string(from: calculatedate)
                return calculateStr
            }
        }
        let currentDate = Date(timeIntervalSince1970: timeInterval)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = NSTimeZone.local
        
        //获取当前的时间戳
        let currentTime = Date().timeIntervalSince1970
        //时间戳为毫秒级要 ／ 1000， 秒就不用除1000，参数带没带000
        let timeSta:TimeInterval = TimeInterval(timeInterval)
        //时间差
        let reduceTime : TimeInterval = currentTime - timeSta
        //时间差大于一小时小于24小时内
        let hours = Int(reduceTime / 3600)
        if hours < 24 {
            dateFormatter.dateFormat = "HH:mm"
            let dateString = dateFormatter.string(from: currentDate)
            return dateString
        }
        
        let calander = Calendar.current
        let components = calander.dateComponents([.second, .minute, .hour, .day, .month, .year, .weekday], from: Date(timeIntervalSince1970: timeInterval))
        if (components.weekday ?? 0) < 8 {
            dateFormatter.dateFormat = "HH:mm"
            let dateString = dateFormatter.string(from: currentDate)
            return "星期\(components.weekday?.weekday() ?? "") \(dateString)"
        } else {
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            let dateString = dateFormatter.string(from: currentDate)
            return dateString
        }
    }
    
    static func showDateToString(timeInterval: TimeInterval) -> String {
        if timeInterval.isNaN || timeInterval <= 0 {
            let currentdata = Date()
            let calendar = Calendar(identifier: .gregorian)
            var datecomps = DateComponents()
            datecomps.year = -20
            if let calculatedate = calendar.date(byAdding: datecomps, to: currentdata) {
                let fmt = DateFormatter()
                fmt.dateFormat = "yyyy-MM-dd"
                let calculateStr = fmt.string(from: calculatedate)
                return calculateStr
            }
        }
        let currentDate = Date(timeIntervalSince1970: timeInterval / 1000)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = NSTimeZone.local
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: currentDate)
        return dateString
    }
    
    static func timeStampToCurrennTime(timeStamp: Double) -> String {
        //获取当前的时间戳
        let currentTime = Date().timeIntervalSince1970
        //时间戳为毫秒级要 ／ 1000， 秒就不用除1000，参数带没带000
        let timeSta:TimeInterval = TimeInterval(timeStamp / 1000)
        //时间差
        let reduceTime : TimeInterval = currentTime - timeSta
        //时间差小于60秒
        if reduceTime < 60 {
            return "刚刚"
        }
        //时间差大于一分钟小于60分钟内
        let mins = Int(reduceTime / 60)
        if mins < 60 {
            return "\(mins)分钟前"
        }
        //时间差大于一小时小于24小时内
        let hours = Int(reduceTime / 3600)
        if hours < 24 {
            return "\(hours)小时前"
        }
        //时间差大于一天小于30天内
        let days = Int(reduceTime / 3600 / 24)
        if days < 30 {
            return "\(days)天前"
        }
        return "30天前"
        
        //不满足以上条件直接返回日期
//        let date = Date(timeIntervalSince1970: timeSta)
//        let dfmatter = DateFormatter()
//        //yyyy-MM-dd HH:mm:ss
//        dfmatter.dateFormat="yyyy年MM月dd日 HH:mm:ss"
//        return dfmatter.string(from: date as Date)
    }
    
    public var timeAgo: String {
        let components = self.dateComponents()
        if components.year! > 0 {
            return "\(components.year!)年前"
        }
        if components.month! > 0 {
            return "\(components.month!)月前"
        }
        if components.weekday! > 0 {
            return "\(components.weekday!)周前"
        }
        if components.day! > 0 {
            return "\(components.day!)天前"
        }
        if components.hour! > 0 {
            return "\(components.hour!)小时前"
        }
        if components.minute! > 0 {
            return "\(components.minute!)分钟前"
        }
        if components.second! > 0 {
            return "\(components.second!)秒前"
        } else {
            return "0秒前"
        }
    }
    
    private func dateComponents() -> DateComponents {
        let calander = Calendar.current
        return calander.dateComponents([.second, .minute, .hour, .day, .month, .year, .weekday], from: self, to: Date())
    }
    
    private func weekComponents() -> DateComponents {
        let calander = Calendar.current
        return calander.dateComponents([.second, .minute, .hour, .day, .month, .year, .weekday], from: self)
    }
    
}

extension Int {
    static func secondToTime(second: Int) -> String {
        if second <= 0 {
            return "00时00分00秒"
        }
        
        var hours = 0
        var minutes = 0
        var seconds = 0
        var hoursText = ""
        var minutesText = ""
        var secondsText = ""
        
        hours = second / 3600
        hoursText = hours > 9 ? "\(hours)" : "0\(hours)"
        
        minutes = second % 3600 / 60
        minutesText = minutes > 9 ? "\(minutes)" : "0\(minutes)"
        
        seconds = second % 3600 % 60
        secondsText = seconds > 9 ? "\(seconds)" : "0\(seconds)"
        
        return "\(hoursText)时\(minutesText)分\(secondsText)秒"
    }
    func weekday() -> String {
        switch self {
        case 1:
            return "日"
        case 2:
            return "一"
        case 3:
            return "二"
        case 4:
            return "三"
        case 5:
            return "四"
        case 6:
            return "五"
        default:
            return "六"
        }
    }
}
