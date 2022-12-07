//
//  String+Extension.swift
//  String+Extension
//
//  Created by 张轩赫 on 2021/1/12.
//

import UIKit
import CommonCrypto

extension String {
    ///计算字的大小
    func stringSize(textFont: CGFloat, isBold: Bool = false, maxSize size: CGSize, paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()) -> CGSize {
        let str: NSString = self as NSString
        let rect = str.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: isBold ? UIFont.boldSystemFont(ofSize: textFont) : UIFont.systemFont(ofSize: textFont), NSAttributedString.Key.paragraphStyle: paragraphStyle], context: nil)
        return rect.size
    }
    
    /// 根据字符串 获取 Label 控件的高度
    func getLabelStringHeightFrom(labelWidth: CGFloat, font: UIFont) -> CGFloat {
        let topOffset = CGFloat(0)
        let bottomOffset = CGFloat(0)
        let textContentWidth = labelWidth
        let normalText: NSString = self as NSString
        let size = CGSize(width: textContentWidth, height: CGFloat.greatestFiniteMagnitude)
        let attributes = [NSAttributedString.Key.font: font]
        let stringSize = normalText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context:nil).size
        return CGFloat(ceilf(Float(stringSize.height)))+topOffset+bottomOffset
    }
    
    ///去掉首尾空格
    var removeHeadAndTailSpace:String {
        let whitespace = NSCharacterSet.whitespaces
        return self.trimmingCharacters(in: whitespace)
    }
    ///去掉首尾空格 包括后面的换行 \n
    var removeHeadAndTailSpacePro:String {
        let whitespace = NSCharacterSet.whitespacesAndNewlines
        return self.trimmingCharacters(in: whitespace)
    }
    ///去掉所有空格
    var removeAllSapce: String {
        return self.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
    }
    
    ///获取字符串里第一个出现的字符下标
    func positionOf(sub:String, backwards:Bool = false) -> Int? {
        var pos: Int?
        if let range = range(of:sub, options: backwards ? .backwards : .literal ) {
            if !range.isEmpty {
                pos = self.distance(from:startIndex, to:range.lowerBound)
            }
        }
        return pos
    }
    
    ///是否是11位号码
    func isValidateMobile() -> Bool {
        let PHONE_REGEX = "^\\d{11}$"
        return validateByRegex(regex: PHONE_REGEX)
    }
    ///是否是邮箱
    func isValidateEmail() -> Bool {
        let EMAIL_REGEX = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return validateByRegex(regex: EMAIL_REGEX)
    }
    
    func validateByRegex(regex: String) -> Bool {
        let test = NSPredicate(format: "SELF MATCHES %@", regex)
        return test.evaluate(with: self)
    }
    
    var md5:String {
        let utf8 = cString(using: .utf8)
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5(utf8, CC_LONG(utf8!.count - 1), &digest)
        return digest.reduce("") { $0 + String(format:"%02x", $1) }
    }
    ///只返回数字
    var westernArabicNumeralsOnly: String {
        let pattern = UnicodeScalar("0")..."9"
        return String(unicodeScalars.compactMap { pattern ~= $0 ? Character($0) : nil })
    }
    
    //NSRange和range转换
    func nsRange(from range: Range<String.Index>) -> NSRange? {
        if let from = range.lowerBound.samePosition(in: utf16), let to = range.upperBound.samePosition(in: utf16) {
            return NSRange(location: utf16.distance(from: utf16.startIndex, to: from), length: utf16.distance(from: from, to: to))
        }
        return nil
    }
    func ranges(of string: String) -> [Range<String.Index>] {
        var rangeArray = [Range<String.Index>]()
        var searchedRange: Range<String.Index>
        guard let sr = self.range(of: self) else {
            return rangeArray
        }
        searchedRange = sr
        
        var resultRange = self.range(of: string, options: .regularExpression, range: searchedRange, locale: nil)
        while let range = resultRange {
            rangeArray.append(range)
            searchedRange = Range(uncheckedBounds: (range.upperBound, searchedRange.upperBound))
            resultRange = self.range(of: string, options: .regularExpression, range: searchedRange, locale: nil)
        }
        return rangeArray
    }
    
    func index(_ offset: Int) -> Index {
        return self.index(startIndex, offsetBy: offset)
    }
    func substring(from: Int) -> String {
        let fromIndex = index(from)
        return String(self[fromIndex...])
    }
    func substring(to: Int) -> String {
        let toIndex = index(to)
        return String(self[..<toIndex])
    }
    //获取两个下标中间的字符串
    func substring(start: Int, end: Int) -> String {
        let startIndex = index(start)
        let endIndex = index(end)
        return String(self[startIndex..<endIndex])
    }
    
    //从String中截取出参数
    var urlParameters: [String: AnyObject]? {
        // 截取是否有参数
        guard let urlComponents = URLComponents(string: self), let queryItems = urlComponents.queryItems else {
            return nil
        }
        // 参数字典
        var parameters = [String: AnyObject]()
        // 遍历参数
        queryItems.forEach({ (item) in
            // 判断参数是否是数组
            if let existValue = parameters[item.name], let value = item.value {
                // 已存在的值，生成数组
                if var existValue = existValue as? [AnyObject] {
                    existValue.append(value as AnyObject)
                } else {
                    parameters[item.name] = [existValue, value] as AnyObject
                }
            } else {
                parameters[item.name] = item.value as AnyObject
            }
        })
        return parameters
    }
    
}
