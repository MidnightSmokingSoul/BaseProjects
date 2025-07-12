//
//  UIDevice+Extension.swift
//  UIDevice+Extension
//
//  Created by mac on 2022/12/2.
//

import UIKit

extension UIDevice {
    
    /// 是否为刘海屏（包括灵动岛）
    static var hasNotch: Bool {
        let keyWindow = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first(where: { $0.activationState == .foregroundActive })?
            .windows
            .first(where: { $0.isKeyWindow })
        
        let bottomInset = keyWindow?.safeAreaInsets.bottom ?? 0
        return bottomInset > 0
    }

    /// 获取设备型号标识（如 "iPhone14,2"）
    var modelIdentifier: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        return withUnsafePointer(to: &systemInfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                String(validatingUTF8: $0) ?? "unknown"
            }
        }
    }

    /// 当前系统是否为 iOS 16 或以上
    static var isiOS16OrLater: Bool {
        return ProcessInfo().isOperatingSystemAtLeast(
            OperatingSystemVersion(majorVersion: 16, minorVersion: 0, patchVersion: 0)
        )
    }

    /// 是否为模拟器运行
    static var isSimulator: Bool {
#if targetEnvironment(simulator)
        return true
#else
        return false
#endif
    }

    /// 当前设备是否为 iPad
    static var isPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }

    /// 当前是否为暗黑模式
    static var isDarkMode: Bool {
        if #available(iOS 12.0, *) {
            return UITraitCollection.current.userInterfaceStyle == .dark
        } else {
            return false
        }
    }

    /// 可用磁盘空间（单位：字节）
    static var availableDiskSpaceInBytes: Int64? {
        do {
            let attributes = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory())
            return (attributes[.systemFreeSize] as? NSNumber)?.int64Value
        } catch {
            return nil
        }
    }
}
