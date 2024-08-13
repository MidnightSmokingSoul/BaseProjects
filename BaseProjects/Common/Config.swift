//
//  Config.swift
//  封装网络请求
//
//  Created by 张轩赫 on 2022/10/25.
//

import UIKit
import Alamofire

let kScreenWidth = UIScreen.main.bounds.width
let kScreenHeight = UIScreen.main.bounds.height

var keyWindow: UIWindow? {
    if #available(iOS 15, *) {
        return UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.first?.windows.filter { $0.isKeyWindow }.first
    } else {
        return UIApplication.shared.windows.filter({$0.isKeyWindow}).first
    }
}

struct Config {
    struct OAuthConfig {
        static let current_user_key = "current_user"
        static let current_info_key = "current_info"
        //测试环境
        //        static let config = "eyJlbmNyeXB0aW9uIjpudWxsLCJvcyI6IjIiLCJ2ZXJzaW9uIjoiMS4wLjUiLCJjaGFubmVsIjoiNjFiOWE0NzM2MmEyNDA1ZGJlMzI0NWYwMmY4M2Y2OTMiLCJyZWdQbGF0Zm9ybSI6Imdvb2dsZS1wbGF5In0=.4fffc278eabe2884d7351907b6573f9bb7aadd16"
        //线上环境
        static let config = "eyJlbmNyeXB0aW9uIjpudWxsLCJvcyI6IjEiLCJ2ZXJzaW9uIjoiMS4wLjUiLCJjaGFubmVsIjoiMzIyNTYxNTM2ZmM1NDJmMmFhMzEzMzkwYjgyMjA0MTEiLCJyZWdQbGF0Zm9ybSI6IuiLueaenOWVhuW6lyJ9.c461f97d731a6ecbd2ff0abbba09e82c181f2f70"
    }
    struct sharedManager {
        static let requestManager: Session = {
            let configuration = URLSessionConfiguration.af.default
            configuration.timeoutIntervalForRequest = 20
            return Session(configuration: configuration)
        }()
        
        static let requestRefreshManager: Session = {
            let configuration = URLSessionConfiguration.af.default
            configuration.timeoutIntervalForRequest = 60
            return Session(configuration: configuration)
        }()
    }
    
    ///项目版本号
    static func appVersion() -> String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    }
    ///是否是刘海屏
    static func isiPhoneXScreen() -> Bool {
        guard #available(iOS 11.0, *) else {
            return false
        }
        if #available(iOS 16, *) {
            return UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.first?.windows.first?.safeAreaInsets.bottom != 0
        } else {
            return UIApplication.shared.windows.first?.safeAreaInsets.bottom != 0
        }
    }
    
    ///震动反馈📳
    private static var impact: UIImpactFeedbackGenerator?
    static func impactFeedbackGenerator(style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        impact = UIImpactFeedbackGenerator(style: style)
        impact?.prepare()
        impact?.impactOccurred()
        impact = nil
    }
}

public func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}
