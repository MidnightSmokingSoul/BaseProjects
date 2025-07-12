//
//  Config.swift
//  封装网络请求
//
//  Created by 张轩赫 on 2022/10/25.
//

import UIKit
import Alamofire
import SwiftyJSON

struct Config {
    
    struct sharedManager {
        static let requestManager: Session = {
            let configuration = URLSessionConfiguration.af.default
            configuration.timeoutIntervalForRequest = 20
            let interceptor = AuthInterceptor()
            return Session(configuration: configuration, interceptor: interceptor)
        }()
        
        static let requestRefreshManager: Session = {
            let configuration = URLSessionConfiguration.af.default
            configuration.timeoutIntervalForRequest = 60
            let interceptor = AuthInterceptor()
            return Session(configuration: configuration, interceptor: interceptor)
        }()
    }
}

final class AuthInterceptor: RequestInterceptor {
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var request = urlRequest
        let token = UserInfoModel.current?.token ?? ""
        
        let milliseconds = Int64(Date().timeIntervalSince1970 * 1000)
        let clientVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let dictionary: Dictionary = ["clientVersion": clientVersion, "nonceStr": milliseconds, "timeStamp": milliseconds, "sysType": 2, "appKey": "2BIajKy4eT6tRU8Z", "sign": "4a058152bb4e0c47f31eaf4185c03c77", "token": token] as [String : Any]
        if let jsonString = JSON(dictionary).rawString(.utf8) {
            request.headers.add(.authorization(bearerToken: jsonString.removingNewLineCharacter))
        } else {
            print("字典转JSON失败: \(dictionary)")
        }
        completion(.success(request))
    }
    
}
