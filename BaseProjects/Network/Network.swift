//
//  Network.swift
//  网络请求
//
//  Created by 张轩赫 on 2022/10/25.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toast_Swift

public enum PromiseError: Error {
    case error(message: String, result: Int = 0)
}

enum UploadType {
    case video, image, sound
}

public class Reachability {
    class func isConnectedToNetwork() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

typealias ProgressHandler = (_ progress: Double) -> Void
typealias JSONSuccessHandler = (_ json: JSON?) -> Void
typealias FailureHandler = (_ error: Error) -> Void

public enum Router: String {
    case getCode = "api/user/v1/sendVerificationCode"
    case login = "api/user/v1/appLogin"
    case getUserInfo = "api/user/v1/queryAccount"
    case getConfig = "api/resource/config/list"
    case getNoticeCount = "api/resource/notice/noticeNoViewCount"
    case getNoticeList = "api/resource/notice/list"
    case getNoticeDetails = "api/resource/notice/noticeInfo"
    case getQueryNewVersion = "api/resource/app/version/queryNewVersion"
    case getNewNotice = "api/resource/notice/newNotice"
    case getOrderList = "api/user/order/list"
    case logout = "api/user/v1/logout"
    case cancelAccount = "api/user/v1/cancel"
    case changeUserInfo = "api/user/v1/saveUserInfo"
    case uploadImage = "resource/file/upload"
}

class Network {
    
    //测试环境
    static let rootApi = "https://sys-back-api-test.xianrcj.com/"
    //线上环境
//    static let rootApi = "https://video-api.ddhmit.net"
    
    class func doRequest(
        rootApi: String = rootApi,
        router: Router,
        parameters: [String: Any]?,
        method: HTTPMethod = .post,
        isShowToast: Bool = true,
        success: @escaping JSONSuccessHandler,
        failure: @escaping FailureHandler = { _ in }
    ) {
        guard Reachability.isConnectedToNetwork() else {
            Toast.hideAllToasts()
            Toast.makeToast(message: "请检测网络连接")
            return
        }
        
        let request = Config.sharedManager.requestManager.request(
            rootApi + router.rawValue,
            method: method,
            parameters: parameters,
            encoding: method == .get ? URLEncoding.default : JSONEncoding.default
        )
        if isShowToast {
            Toast.showToast()
        }
        request.validate().responseData { response in
            Toast.hideAllToasts()
            switch response.result {
            case .success(let data):
                // 直接拿模型用
                switch NetworkResponse.parse(from: JSON(data)) {
                case .success(let dataJson):
                    // 正常处理 dataJson
                    success(dataJson)
                case .failure(let error):
                    Toast.makeToast(message: error.message)
                    failure(PromiseError.error(message: error.message))
                }
            case .failure(let error):
                // 错误处理
                Toast.makeToast(message: error.errorDescription ?? "")
                failure(PromiseError.error(message: error.errorDescription ?? "", result: error.responseCode ?? 0))
                break
            }
        }
    }
    
    //图片上传
    static func uploadImage(
        rootApi: String = rootApi,
        router: Router,
        method: HTTPMethod = .post,
        parameters: [String: Any]? = nil,
        file: Data,
        fileName: String = "avatar",
        uploadType: UploadType = .image,
        progressCall: @escaping ProgressHandler,
        success: @escaping JSONSuccessHandler,
        failure: @escaping FailureHandler = { _ in }
    ) {
        let headers: HTTPHeaders = ["Content-Type": "multipart/form-data"]
        let request = Config.sharedManager.requestManager.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(file, withName: "file", fileName: "\(fileName)\(Date().timeIntervalSince1970).jpg", mimeType: "image/jpg")
            },
            to: rootApi + router.rawValue,
            method: method,
            headers: headers // 这里传 Content-Type，Authorization 会被拦截器自动添加
        )
        Toast.showToast()
        request.validate().uploadProgress { progress in
            progressCall(progress.fractionCompleted)
        }.responseData { response in
            Toast.hideAllToasts()
            switch response.result {
            case .success(let data):
                switch NetworkResponse.parse(from: JSON(data)) {
                case .success(let dataJson):
                    // 正常处理 dataJson
                    success(dataJson)
                case .failure(let error):
                    Toast.makeToast(message: error.message)
                    failure(PromiseError.error(message: error.message))
                }
            case .failure(let error):
                Toast.makeToast(message: error.errorDescription ?? "")
                failure(PromiseError.error(message: error.errorDescription ?? "", result: error.responseCode ?? 0))
            }
        }
    }
    
    //多图片上传
    static func uploadMoreImage(
        rootApi: String = rootApi,
        router: Router,
        method: HTTPMethod = .post,
        parameters: [String: Any]? = nil,
        images: [Data],
        fileNamePrefix: String = "avatar",
        progressCall: @escaping ProgressHandler,
        success: @escaping JSONSuccessHandler,
        failure: @escaping FailureHandler = { _ in }
    ) {
        let headers: HTTPHeaders = ["Content-Type": "multipart/form-data"]
        
        let request = Config.sharedManager.requestManager.upload(
            multipartFormData: { multipartFormData in
                for (index, data) in images.enumerated() {
                    let fileName = "\(fileNamePrefix)\(Date().timeIntervalSince1970)_\(index).jpg"
                    multipartFormData.append(data, withName: "fileList", fileName: fileName, mimeType: "image/jpg")
                }
            },
            to: rootApi + router.rawValue,
            method: method,
            headers: headers // 只传 Content-Type，拦截器自动加 token 等
        )
        Toast.showToast()
        request.validate().uploadProgress { progress in
            progressCall(progress.fractionCompleted)
        }.responseData { response in
            Toast.hideAllToasts()
            switch response.result {
            case .success(let data):
                switch NetworkResponse.parse(from: JSON(data)) {
                case .success(let dataJson):
                    // 正常处理 dataJson
                    success(dataJson)
                case .failure(let error):
                    Toast.makeToast(message: error.message)
                    failure(PromiseError.error(message: error.message))
                }
            case .failure(let error):
                Toast.makeToast(message: error.errorDescription ?? "")
                failure(PromiseError.error(message: error.errorDescription ?? "", result: error.responseCode ?? 0))
            }
        }
    }
    
}

import Network

class NetworkMonitor {
    static let shared = NetworkMonitor()
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "NetworkMonitor")

    var isConnected: Bool = false

    func startMonitoring(onAvailable: @escaping () -> Void) {
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                if !self.isConnected {
                    self.isConnected = true
                    DispatchQueue.main.async {
                        onAvailable() // 网络刚刚恢复，触发回调
                    }
                }
            } else {
                self.isConnected = false
            }
        }
        monitor.start(queue: queue)
    }

    func stopMonitoring() {
        monitor.cancel()
    }
}
