//
//  ResultModel.swift
//  net
//
//  Created by apple on 2019/9/12.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit
import HandyJSON

let SUCCESS_CODE = "1"
public struct ResultModel: HandyJSON {
    
    public init() {
        
    }
    public var code: String!
    public var data: Any!
    public var message: String!
    public var msg: String!
    ///请求是否成功
    public var success: Bool! {
        get {
            self.code == SUCCESS_CODE
        }
    }
    
    mutating public func mapping(mapper: HelpingMapper) {
            mapper.specify(property: &code, name: "status")
            mapper.specify(property: &data, name: "content")
    }
}
