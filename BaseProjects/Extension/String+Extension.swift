//
//  String+Extension.swift
//  String+Extension
//
//  Created by 张轩赫 on 2021/1/12.
//

import UIKit

// MARK: - String+Size.swift
extension String {
    
    /// 计算字符串在指定字体和区域下的尺寸
    func boundingSize(font: UIFont, maxSize: CGSize, paragraphStyle: NSParagraphStyle? = nil) -> CGSize {
        var attributes: [NSAttributedString.Key: Any] = [.font: font]
        if let style = paragraphStyle {
            attributes[.paragraphStyle] = style
        }
        return (self as NSString).boundingRect(
            with: maxSize,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: attributes,
            context: nil
        ).size
    }

    /// 获取字符串对应 Label 高度
    func heightForLabel(width: CGFloat, font: UIFont) -> CGFloat {
        let size = boundingSize(font: font, maxSize: CGSize(width: width, height: .greatestFiniteMagnitude))
        return ceil(size.height)
    }
}


// MARK: - String+Trim.swift
extension String {
    
    // MARK: 把传入的string换成replacement
    func replace(string: String, replacement: String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }
    /// 去掉首尾空格
    var trimmingWhitespace: String {
        trimmingCharacters(in: .whitespaces)
    }

    /// 去掉首尾空格和换行符
    var trimmingWhitespaceAndNewlines: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// 去掉所有空格
    var removingAllSpaces: String {
        replacingOccurrences(of: " ", with: "")
    }
    
    /// 去掉换行符
    var removingNewLineCharacter: String {
        replacingOccurrences(of: "\n", with: "")
    }
}


// MARK: - String+Regex.swift
extension String {
    // MARK:  字符URL格式化,中文路径encoding
    var urlEncoding: String {
        let url = self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        return url!
    }
    
    // MARK:  手机号替换中间四位
    var replacePhone: String {
        let start = self.index(self.startIndex, offsetBy: 3)
        let end = self.index(self.startIndex, offsetBy: 7)
        let range = Range(uncheckedBounds: (lower: start, upper: end))
        return self.replacingCharacters(in: range, with: "****")
    }
    
    // MARK: 手机号正则表达式
    var isValidMobileNumber: Bool {
        let phoneRegex = try? NSRegularExpression(pattern: "^(13\\d|14[5-9]|15[0-35-9]|16[2567]|17[0-8]|18\\d|19[0-35-9])\\d{8}$", options: NSRegularExpression.Options.caseInsensitive)
        return phoneRegex?.firstMatch(in: self, options: [], range: NSMakeRange(0, self.count)) != nil
    }
    
    // MARK: 清理不可见的控制字符，包括方向控制符（如 U+202E）
    var cleanedFormatControlCharacters: String {
        let forbiddenScalars: Set<UInt32> = [
            0x200B, // Zero-width space
            0x200C, // Zero-width non-joiner
            0x200D, // Zero-width joiner
            0x200E, // LRM ← 你现在遇到的
            0x200F, // RLM
            0x202A, 0x202B, 0x202C, 0x202D, 0x202E, // Directional overrides
            0x2066, 0x2067, 0x2068, 0x2069           // Bidirectional isolate controls
        ]
        
        return self.unicodeScalars
            .filter { !forbiddenScalars.contains($0.value) }
            .map(String.init)
            .joined()
    }

    /// 验证是否是邮箱
    var isValidEmail: Bool {
        validateByRegex("[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}")
    }

    /// 通用正则校验
    func validateByRegex(_ pattern: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)
        return predicate.evaluate(with: self)
    }
}


// MARK: - String+Crypto.swift
import CryptoKit

extension String {
    var sha256: String {
        let data = Data(self.utf8)
        let hashed = SHA256.hash(data: data)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }
}


// MARK: - String+Subscript.swift
extension String {
    func index(_ offset: Int) -> Index {
        self.index(startIndex, offsetBy: offset)
    }

    func slice(from: Int, to: Int) -> String {
        let start = index(from)
        let end = index(to)
        return String(self[start..<end])
    }

    func substring(from index: Int) -> String {
        let fromIndex = self.index(index)
        return String(self[fromIndex...])
    }

    func substring(to index: Int) -> String {
        let toIndex = self.index(index)
        return String(self[..<toIndex])
    }
}


// MARK: - String+Range.swift
extension String {
    func nsRange(from range: Range<String.Index>) -> NSRange? {
        guard let from = range.lowerBound.samePosition(in: utf16),
              let to = range.upperBound.samePosition(in: utf16) else { return nil }
        return NSRange(location: utf16.distance(from: utf16.startIndex, to: from),
                       length: utf16.distance(from: from, to: to))
    }

    func ranges(of substring: String) -> [Range<String.Index>] {
        var result: [Range<String.Index>] = []
        var searchRange = startIndex..<endIndex
        while let found = range(of: substring, options: [], range: searchRange) {
            result.append(found)
            searchRange = found.upperBound..<endIndex
        }
        return result
    }
}


// MARK: - String+Utility.swift
extension String {
    
    /// 提取字符串中的数字
    var digitsOnly: String {
        filter { $0.isNumber }
    }

    /// 获取指定子字符串首次或最后一次出现的位置
    func position(of sub: String, backwards: Bool = false) -> Int? {
        guard let range = range(of: sub, options: backwards ? .backwards : []) else { return nil }
        return distance(from: startIndex, to: range.lowerBound)
    }

    /// 解析 URL 参数为字典
    var urlParameters: [String: String]? {
        guard let components = URLComponents(string: self), let queryItems = components.queryItems else {
            return nil
        }
        var params = [String: String]()
        for item in queryItems {
            if let value = item.value {
                params[item.name] = value
            }
        }
        return params
    }
}
