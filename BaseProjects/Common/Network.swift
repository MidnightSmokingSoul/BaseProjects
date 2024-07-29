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
    case getUserinfo = "/v1/auth/user/userinfo"
}

class Network {
    
    static let iphon_uuid = "7b1798ce-ab02-4d0a-bd05-124ac9239c80"
    
    //测试环境
//    static let rootApi = "http://192.168.3.216:8081/app/"
    //线上环境
    static let rootApi = "https://video-api.ddhmit.net"
    
    class func doRequest(rootApi: String = rootApi, router: Router, method: HTTPMethod = .get, parameters: [String: Any]? = [:], success: @escaping (JSON?) -> (), failure: @escaping (Error) -> ()) {
        let request = Config.sharedManager.requestManager.request(rootApi + router.rawValue, method: method, parameters: parameters)
        Toast.showToast()
        guard Reachability.isConnectedToNetwork() else {
            Toast.hideAllToasts()
            Toast.makeToast(message: "请检测网络连接")
            failure(PromiseError.Error(message: "请检测网络连接"))
            return
        }
        request.responseData { response in
            do {
                guard let data = response.data else {
                    Toast.hideAllToasts()
                    Toast.makeToast(message: "请求失败")
                    failure(PromiseError.Error(message: "请求失败"))
                    return
                }
                if let code = response.response?.statusCode, code == 200 {
                    Toast.hideAllToasts()
                    if JSON(response.data as Any)["result"].intValue == 0 {
                        Toast.makeToast(message: JSON(response.data as Any)["msg"].stringValue)
                        failure(PromiseError.Error(message: JSON(response.data as Any)["msg"].stringValue, result: 0))
                    } else {
                        success(JSON(response.data as Any)["data"])
                    }
                } else {
                    Toast.hideAllToasts()
                    Toast.makeToast(message: try JSON(data: data)["message"].stringValue)
                    failure(PromiseError.Error(message: try JSON(data: data)["message"].stringValue))
                }
            } catch {
                Toast.hideAllToasts()
                Toast.makeToast(message: "请求失败")
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

/*
 直接传参给body
 */
struct BodyStringEncoding: ParameterEncoding {

    //body类型可以更改
    private let body: Data

    init(body: Data) { self.body = body }

    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        guard var urlRequest = urlRequest.urlRequest else { throw Errors.emptyURLRequest }
//        guard let data = body.data(using: .utf8) else { throw Errors.encodingProblem }
        urlRequest.httpBody = body
        return urlRequest
    }
}

extension BodyStringEncoding {
    enum Errors: Error {
        case emptyURLRequest
        case encodingProblem
    }
}
//encoding里调用这个
extension BodyStringEncoding.Errors: LocalizedError {
    var errorDescription: String? {
        switch self {
            case .emptyURLRequest: return "Empty url request"
            case .encodingProblem: return "Encoding problem"
        }
    }
}
