//
//  NetworkResponse.swift
//  DDT
//
//  Created by 张轩赫 on 2025/7/12.
//

import UIKit
import SwiftyJSON

struct ParseError: Error {
    let message: String
}

/// 通用网络响应解析器，只判断成功与失败，不做模型转换
struct NetworkResponse {
    let code: Int
    let success: Bool
    let message: String
    let data: JSON

    /// 解析 JSON，返回 Result，成功携带 data，失败携带错误信息
    static func parse(from json: JSON?) -> Result<JSON, ParseError> {
        let code = json?["code"].string ?? json?["result"].stringValue ?? "-1"
        let msg = json?["message"].string ?? json?["msg"].string ?? "未知错误"
        if let data = json?["data"] {
            if code == "00000" {
                return .success(data)
            } else {
                return .failure(ParseError(message: msg))
            }
        } else {
            return .failure(ParseError(message: msg))
        }
        
    }
}
