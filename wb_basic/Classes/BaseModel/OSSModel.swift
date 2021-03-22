//
//  OSSModel.swift
//  MarkerMall
//
//  Created by apple on 2020/9/7.
//  Copyright © 2020 杭州之江之约科技有限公司. All rights reserved.
//

import UIKit

public class OSSModel: CKJSON {

    var StatusCode: String!
    
    var AccessKeyId: String!
    
    var AccessKeySecret: String!
    
    var Expiration: String!
    
    var SecurityToken: String!
    
    var bucket: String!
    
    var host: String!
    
    var privateBucket: String!
    
    var callback: String!
    
    public required init() {
        
    }
}
