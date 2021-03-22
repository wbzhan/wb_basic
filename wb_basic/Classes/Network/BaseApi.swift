//
//  BaseApi.swift
//  net
//
//  Created by apple on 2019/9/12.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit
import Moya
import AppTrackingTransparency
import AdSupport
import kit_extension
public enum BaseApi {
    case get(_ param: Any?, _ url: String)
    case post(_ param: Any?, _ url: String)
    case upload(_ param: Any?, _ base: String, _ url: String, _ uplaod: UplaodDataModel)
    case base(_ param: Any?, _ base: String, _ url: String)
    case put(_ param:Any? , _ url:String)
    case delete(_ param:Any? ,_ url:String)
}

extension BaseApi: TargetType {
    
    public var baseURL: URL {
        
        switch self {
        case .base(_, let base, _):
            return URL.init(string: base)!
        default:
            return URL.init(string: APP_Domin)!
        }
    }
    
    public var path: String  {
        
        switch self {
        case .get(_, let url),
             .post(_, let url),
             .upload(_, _, let url, _),
             .base(_, _, let url),
             .delete(_, let url),
             .put(_ , let url):
            return url
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .get(_, _), .base(_, _, _):
            return .get
        case .post(_, _), .upload(_, _, _, _):
            return .post
        case .delete(_ ,  _):
        return .delete
        case .put(_, _):
        return .put
        }
    }
    
    public var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
    
    public var task: Task {
        switch self {
        case .get(let params, let url):
            print("--get--\(url) \n \(params ?? "")")
            if params == nil {
                return .requestPlain
            }
            return .requestParameters(parameters: params as? [String:Any] ?? [:], encoding: URLEncoding.default)
        case .post(let params, let url) ,
             .put(let params, let url):
            print("--post--\(url) \n \(params ?? "")")
            let data = try! JSONSerialization.data(withJSONObject: params ?? [:], options: [.fragmentsAllowed])
            return .requestData(data)
        case .upload(let params, _, let url, let upload):
            print("--upload--\(url) \(params ?? "")")
            let formData = MultipartFormData.init(provider: .data(upload.data!), name: upload.name, fileName: upload.fileName, mimeType: upload.mineType)
            return .uploadCompositeMultipart([formData], urlParameters: (params as? [String: Any]) ?? [:])
        case .base(let params, _, let url) , .delete(let params, let url):
            print("\(url) \n \(params ?? "")")
            return .requestPlain
        }
    }
    
    public var headers: [String : String]? {
        switch self {
        case .base(_, _, _):
            return nil
        default:
            let dic: [String: String] = ["Accept": "application/json",
                                         "Content-Type": "application/json",
                                         "versionCode": kAppVersion]
            DLog(dic)
            
            return dic
        }
    }
    
}


