//
//  RestAPIRequest.swift
//  BYMoyaHttpRequestDeom
//
//  Created by by_chen on 2017/6/21.
//  Copyright © 2017年 BYChen. All rights reserved.
//

import Foundation
import Moya
import Alamofire

//  自行定義Response Status Code
public enum httpStatusCode: Int {
    case ok = 200
    case created = 201
    case badRequest = 400
    case unAuthorized = 401
    case forbidden = 403
    case timeout = 408
    case internalServerError = 500
    case badGateway = 502
    case gatewayTimeOut = 504
}


// 創建Request類型
enum RestAPIReqeust {
    // 使用ObjectId 取得單張Photo, 使用HTTP GET方式取得, Response 的資料格式為 JSON
    case photo(objectId: String)
    
    // 創建單張Photo並且使用form-data方式傳送相關訊息與圖片檔案, 使用HTTP POST方法
    case createPhoto(image: Data)
    
    // 更新單張Photo, 使用HTTP PUT方法
    case putPhoto(objectId: String, title: String, description: String)
}


//  自行建立Header的參數

extension TargetType {
    var header: [String: String] {
        return [:]
    }
    
    var multiParts: [Moya.MultipartFormData] {
        return []
    }
}

extension RestAPIReqeust: TargetType {
    
    /// The target's base `URL`.
    var baseURL: URL {
        return URL(string: "https://{Domain Name}/1")!
    }
    
    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String {
        switch self {
        case .createPhoto:
            return "classes/Photo"
            
        case let .photo(objectId):
            return "classes/Photo/\(objectId)"
            
        case let .putPhoto(objectId, _, _):
            return "classes/Photo/\(objectId)"
        }
    }
    
    /// The HTTP method used in the request.
    var method: Moya.Method {
        switch self {
        case .createPhoto:
            return .post
            
        case .photo:
            return .get
            
        case .putPhoto:
            return .put
        }
    }
    
    /// The parameters to be encoded in the request.
    var parameters: [String : Any]? {
        switch self {
        case .createPhoto:
            return nil
            
        case .photo:
            return [:]
            
        case let .putPhoto(_, title, description):
            return [
                "title": title,
                "description": description
            ]
        }
    }
    
    /// The method used for parameter encoding.
    var parameterEncoding: Moya.ParameterEncoding {
        switch self {
        case .createPhoto:
            return Moya.PropertyListEncoding.default
            
        default:
            return Moya.JSONEncoding.default
        }
        
    }
    
    var task: Task {
        switch self {
        case .createPhoto:
            return .upload(UploadType.multipart(multiParts))
        
        default:
            return .request
        }
    }

    /// Provides stub data for use in testing.
    var sampleData: Data {
        return "{}".data(using: .utf8)!
    }
    
    /// 自行定義Header要傳送的參數, 如: Content-Type
    var header: [String : String] {
        return [
            "Content-Type" : "application/json"
        ]
    }
    
    /// 自行封裝form-data的格式
    var multiParts: [Moya.MultipartFormData] {
        switch self {
        case let .createPhoto(image):
            var multiparts: [Moya.MultipartFormData] = []
            let m = Moya.MultipartFormData(provider: .data(image), name: "file", fileName: "test.png", mimeType: "image/png")
            multiparts.append(m)
            return multiparts
            
        default:
            return []
        }
    }
    
    //  自行封裝Endpoint
    private func endpoint() -> (RestAPIReqeust) -> Endpoint<RestAPIReqeust> {
        let endpointClosure = { (target: RestAPIReqeust) -> Endpoint<RestAPIReqeust> in
            
            // 取得預設的Endpoint
            var defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
            
            //  加入自行定義的Header
            if !self.header.isEmpty {
                defaultEndpoint = defaultEndpoint.adding(newHTTPHeaderFields: self.header)
            }
            
            return defaultEndpoint
        }
        
        return endpointClosure
    }
    
    public func execute() {
        //  endpointClosure: 傳入客製化的Endpoint
        //  plugins: 啟動debugMode 會在Console印出 verbose 跟 cURL
        let provider = MoyaProvider<RestAPIReqeust>(endpointClosure: self.endpoint(),
                                                plugins: [NetworkLoggerPlugin(verbose: true, cURL: true)])
        
        //  執行request, 並且以background Mode執行
        provider.request(self, queue: DispatchQueue.global(qos: .background), completion: {
            (request) in
            switch request {
            case let .success(response):
                if let _ = httpStatusCode(rawValue: response.statusCode) {
                    print("Parse Response JSON Format \(response.data)")
                } else {
                    print("Status Code :  \(response.statusCode)")
                }
            case let .failure(error):
                print("Error Status Code :  \(error.localizedDescription)")
            }
        })
    }
}
