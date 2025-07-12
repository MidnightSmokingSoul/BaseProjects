//
//  UIColor+Extension.swift
//  DDT
//
//  Created by 张轩赫 on 2025/7/11.
//

import Foundation
#if os(macOS)
import Cocoa
typealias Color = NSColor
#else
import UIKit
typealias Color = UIColor
#endif

extension Color {
    public convenience init(hex3: UInt16, alpha: CGFloat = 1) {
        let divisor = CGFloat(15)
        let red     = CGFloat((hex3 & 0xF00) >> 8) / divisor
        let green   = CGFloat((hex3 & 0x0F0) >> 4) / divisor
        let blue    = CGFloat( hex3 & 0x00F      ) / divisor
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    public convenience init(hex4: UInt16) {
        let divisor = CGFloat(15)
        let red     = CGFloat((hex4 & 0xF000) >> 12) / divisor
        let green   = CGFloat((hex4 & 0x0F00) >>  8) / divisor
        let blue    = CGFloat((hex4 & 0x00F0) >>  4) / divisor
        let alpha   = CGFloat( hex4 & 0x000F       ) / divisor
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    public convenience init(hex6: UInt64, alpha: CGFloat = 1) {
        let divisor = CGFloat(255)
        let red     = CGFloat((hex6 & 0xFF0000) >> 16) / divisor
        let green   = CGFloat((hex6 & 0x00FF00) >>  8) / divisor
        let blue    = CGFloat( hex6 & 0x0000FF       ) / divisor
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    public convenience init(hex8: UInt64) {
        let divisor = CGFloat(255)
        let red     = CGFloat((hex8 & 0xFF000000) >> 24) / divisor
        let green   = CGFloat((hex8 & 0x00FF0000) >> 16) / divisor
        let blue    = CGFloat((hex8 & 0x0000FF00) >>  8) / divisor
        let alpha   = CGFloat( hex8 & 0x000000FF       ) / divisor
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    public convenience init(rgba_throws rgba: String) throws {
        guard rgba.hasPrefix("#") else {
            throw UIColorInputError.missingHashMarkAsPrefix(rgba)
        }
        
        let hexString = String(rgba.dropFirst())
        var hexValue:  UInt64 = 0
        
        guard Scanner(string: hexString).scanHexInt64(&hexValue) else {
            throw UIColorInputError.unableToScanHexValue(rgba)
        }
        
        switch hexString.count {
        case 3:  self.init(hex3: UInt16(hexValue))
        case 4:  self.init(hex4: UInt16(hexValue))
        case 6:  self.init(hex6: hexValue)
        case 8:  self.init(hex8: hexValue)
        default: throw UIColorInputError.mismatchedHexStringLength(rgba)
        }
    }
    
#if os(macOS)
    public convenience init?(_ rgba: String, defaultColor: NSColor = NSColor.clear) {
        guard let color = try? Color(rgba_throws: rgba) else {
            self.init(cgColor: defaultColor.cgColor)
            return
        }
        self.init(cgColor: color.cgColor)
    }
#else
    public convenience init(_ rgba: String, defaultColor: UIColor = UIColor.clear) {
        guard let color = try? UIColor(rgba_throws: rgba) else {
            self.init(cgColor: defaultColor.cgColor)
            return
        }
        self.init(cgColor: color.cgColor)
    }
#endif
    
    public func hexStringThrows(_ includeAlpha: Bool = true) throws -> String  {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        guard (0...1).contains(r), (0...1).contains(g), (0...1).contains(b) else {
            throw UIColorInputError.unableToOutputHexStringForWideDisplayColor
        }
        
        if includeAlpha {
            return String(format: "#%02X%02X%02X%02X",
                          Int(round(r * 255)), Int(round(g * 255)),
                          Int(round(b * 255)), Int(round(a * 255)))
        } else {
            return String(format: "#%02X%02X%02X",
                          Int(round(r * 255)), Int(round(g * 255)),
                          Int(round(b * 255)))
        }
    }
    
    public func hexString(_ includeAlpha: Bool = true) -> String  {
        (try? hexStringThrows(includeAlpha)) ?? ""
    }
}

public enum UIColorInputError: Error, LocalizedError {
    case missingHashMarkAsPrefix(String)
    case unableToScanHexValue(String)
    case mismatchedHexStringLength(String)
    case unableToOutputHexStringForWideDisplayColor
    
    public var errorDescription: String? {
        switch self {
        case .missingHashMarkAsPrefix(let hex):
            return "Invalid RGB string, missing '#' as prefix in \(hex)"
        case .unableToScanHexValue(let hex):
            return "Scan \(hex) error"
        case .mismatchedHexStringLength(let hex):
            return "Invalid RGB string from \(hex), number of characters after '#' should be either 3, 4, 6 or 8"
        case .unableToOutputHexStringForWideDisplayColor:
            return "Unable to output hex string for wide display color"
        }
    }
}
