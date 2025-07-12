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
    case Error(message: String, result: Int = 0)
}

enum UploadType {
    case video, image, sound
}

public class Reachability {
    class func isConnectedToNetwork() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

public enum Router: String {
    case login = "api/user/v1/appLogin"
    case getUserinfo = "api/user/v1/queryAccount"
}

class Network {
    
    //测试环境
    static let rootApi = "https://sys-back-api-test.xianrcj.com/"
    //线上环境
//    static let rootApi = "https://video-api.ddhmit.net"
    
    class func doRequest(
        rootApi: String = rootApi,
        router: Router,
        method: HTTPMethod = .get,
        parameters: [String: Any]?,
        success: @escaping (JSON?) -> (),
        failure: @escaping (Error) -> ()
    ) {
        guard Reachability.isConnectedToNetwork() else {
            Toast.hideAllToasts()
            Toast.makeToast(message: "请检测网络连接")
            failure(PromiseError.Error(message: "请检测网络连接"))
            return
        }
        
        let request = Config.sharedManager.requestManager.request(
            rootApi + router.rawValue,
            method: method,
            parameters: parameters,
            encoding: method == .get ? URLEncoding.default : JSONEncoding.default
            // **不用传headers，拦截器自动加**
        )
        
        Toast.showToast()
        
        request.responseData { response in
            Toast.hideAllToasts()
            do {
                guard let data = response.data else {
                    Toast.makeToast(message: "请求失败")
                    failure(PromiseError.Error(message: "请求失败"))
                    return
                }
                if let code = response.response?.statusCode, code == 200 {
                    let json = JSON(data)
                    if json["result"].intValue == 0 {
                        Toast.makeToast(message: json["msg"].stringValue)
                        failure(PromiseError.Error(message: json["msg"].stringValue, result: 0))
                    } else {
                        success(json["data"])
                    }
                } else {
                    let errorJson = try JSON(data: data)
                    Toast.makeToast(message: errorJson["message"].stringValue)
                    failure(PromiseError.Error(message: errorJson["message"].stringValue))
                }
            } catch {
                Toast.makeToast(message: "请求失败")
                failure(PromiseError.Error(message: "请求失败"))
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
        file_name: String = "avatar",
        uploadType: UploadType = .image,
        progressCall: @escaping (Double) -> (),
        success: @escaping (JSON?) -> (),
        failure: @escaping (Error) -> ()
    ) {
        let headers: HTTPHeaders = ["Content-Type": "multipart/form-data"]
        let request = Config.sharedManager.requestManager.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(file, withName: "file", fileName: "\(file_name)\(Date().timeIntervalSince1970).jpg", mimeType: "image/jpg")
            },
            to: rootApi + router.rawValue,
            method: method,
            headers: headers // 这里传 Content-Type，Authorization 会被拦截器自动添加
        )
        
        request.uploadProgress { progress in
            progressCall(progress.fractionCompleted)
        }.responseData { response in
            switch response.result {
            case .success(_):
                success(try? JSON(data: response.data ?? Data()))
            case .failure(_):
                Toast.makeToast(message: "上传失败", position: .center)
                failure(PromiseError.Error(message: "上传失败"))
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
        progressCall: @escaping (Double) -> (),
        success: @escaping (JSON?) -> (),
        failure: @escaping (Error) -> ()
    ) {
        let headers: HTTPHeaders = ["Content-Type": "multipart/form-data"]
        
        let request = Config.sharedManager.requestManager.upload(
            multipartFormData: { multipartFormData in
                for (index, data) in images.enumerated() {
                    let fileName = "\(fileNamePrefix)\(Date().timeIntervalSince1970)_\(index).jpg"
                    multipartFormData.append(data, withName: "fileList", fileName: fileName, mimeType: "image/jpg")
                }
                // 如果有其他参数，可以添加：
                // parameters?.forEach { key, value in
                //    if let str = value as? String, let d = str.data(using: .utf8) {
                //        multipartFormData.append(d, withName: key)
                //    }
                // }
            },
            to: rootApi + router.rawValue,
            method: method,
            headers: headers // 只传 Content-Type，拦截器自动加 token 等
        )
        
        request.uploadProgress { progress in
            progressCall(progress.fractionCompleted)
        }.responseData { response in
            switch response.result {
            case .success(_):
                success(try? JSON(data: response.data ?? Data()))
            case .failure(_):
                Toast.makeToast(message: "上传失败", position: .center)
                failure(PromiseError.Error(message: "上传失败"))
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
