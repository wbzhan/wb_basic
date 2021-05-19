//
//  JsonExtension.swift
//  kit_extension
//
//  Created by wbzhan on 2021/5/19.
//

import Foundation
extension Dictionary {
    //json转jsonstring
   func toJsonString() ->String{
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: []) else { return ""}
        let jsonstr = String.init(data: data, encoding: .utf8) ?? ""
    return jsonstr
    }
}
