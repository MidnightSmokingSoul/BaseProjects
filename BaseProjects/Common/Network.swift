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
    case Error(message: String)
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
    case getUserinfo = "/v1/auth/user/userinfo"
}

class Network {
    
    static let iphon_uuid = "7b1798ce-ab02-4d0a-bd05-124ac9239c80"
    
    //测试环境
//    static let rootApi = "http://192.168.3.216:8081/app/"
    //线上环境
    static let rootApi = "https://video-api.ddhmit.net"
    
    class func doRequest(rootApi: String = rootApi, router: Router, method: HTTPMethod = .get, parameters: [String: Any]? = [:], success: @escaping (JSON?) -> (), failure: @escaping (Error) -> ()) {
        let headers: HTTPHeaders = ["Authorization": " Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdmF0YXIiOiIiLCJiYWxhbmNlIjo5OTQzNzAwLCJlbWFpbCI6IiIsImV4cCI6MTY2OTI3MDQ0MiwiaWQiOiJlZDUxZGY4MS1lMGFjLTQ0YzUtYjgyOS00NmJjMDQyZDJmZmUiLCJpbnZpdGVjb2RlIjoiQjZEWjU3OCIsImlzX3ZpcCI6MSwibmlja19uYW1lIjoi5a2Q5aScIiwib3JpZ19pYXQiOjE2NjY2Nzg0NDIsInBob25lIjoiMTU4MDAwMDAwMDIiLCJ1c2VybmFtZSI6IjNDM0MwQjJFLUQyMzktNEZGNy04NEE3LUM5RUNFOEY5QkQzMiIsInZpcF9leHBpcmVfYXQiOiIyMDIyLTEwLTI0VDE2OjQxOjI0KzA4OjAwIn0.A5Z8nYFH-IsaETEQuvk7_7jP_5BrN_UdX5SAZHTyeHU"]
        let request = Config.sharedManager.requestManager.request(rootApi + router.rawValue, method: method, parameters: parameters, headers: headers)
        guard Reachability.isConnectedToNetwork() else {
            keyWindow?.hideAllToasts()
            keyWindow?.makeToast("请检测网络连接", position: .center)
            failure(PromiseError.Error(message: "请检测网络连接"))
            return
        }
        
        request.responseData { response in
            do {
                guard let data = response.data else {
                    keyWindow?.hideAllToasts()
                    keyWindow?.makeToast("请求失败", position: .center)
                    failure(PromiseError.Error(message: "请求失败"))
                    return
                }
                if let code = response.response?.statusCode, code == 200 {
                    success(try JSON(data: data))
                } else {
                    keyWindow?.hideAllToasts()
                    keyWindow?.makeToast(try JSON(data: data)["message"].stringValue, position: .center)
                    failure(PromiseError.Error(message: try JSON(data: data)["message"].stringValue))
                }
            } catch {
                keyWindow?.hideAllToasts()
                keyWindow?.makeToast("请求失败", position: .center)
                failure(PromiseError.Error(message: "请求失败"))
            }
        }
    }
    
    //上传图片
    static func uploadImage(rootApi: String = rootApi, router: Router, method: HTTPMethod = .post, parameters: [String: Any]? = nil, file: Data, file_name: String = "avatar", uploadType: UploadType = .image, progressCall: @escaping (Double) -> (), success: @escaping (JSON?) -> (), failure: @escaping (Error) -> ()) {
        let headers: HTTPHeaders = ["Content-Type": "multipart/form-data"]
        let request = AF.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(file, withName: "file", fileName: "\(file_name)\(Date().timeIntervalSince1970).jpg", mimeType: "image/jpg")
        }, to: rootApi + router.rawValue, usingThreshold: UInt64(), method: method, headers: headers)
        request.uploadProgress { progress in
            progressCall(progress.fractionCompleted)
        }.responseData { (response) in
            switch response.result {
            case .success( _):
                success(try? JSON(data: response.data ?? Data()))
            case .failure( _):
                keyWindow?.makeToast("上传失败", position: .center)
                failure(PromiseError.Error(message: "上传失败"))
            }
        }
    }
    
    //多图片上传
    static func uploadMoreImage(rootApi: String, router: Router, method: HTTPMethod = .get, parameters: [String: Any]? = nil, image: [Data], file_name: String = "avatar", progressCall: @escaping (Double) -> (), success: @escaping (JSON?) -> (), failure: @escaping (Error) -> ()) {
        let headers: HTTPHeaders = ["Content-Type": "application/x-www-form-urlencoded"]
        let request = AF.upload(multipartFormData: { (multipartFormData) in
            for data in image {
                multipartFormData.append(data, withName: "fileList", fileName: "\(file_name)\(Date().timeIntervalSince1970).jpg", mimeType: "image/jpg")
            }
        }, to: rootApi + router.rawValue, usingThreshold: UInt64(), method: method, headers: headers)
        request.uploadProgress { progress in
            progressCall(progress.fractionCompleted)
        }.responseData { (response) in
            switch response.result {
            case .success( _):
                success(try? JSON(data: response.data ?? Data()))
            case .failure( _):
                keyWindow?.makeToast("上传失败", position: .center)
                failure(PromiseError.Error(message: "上传失败"))
            }
        }
    }
    
}
