//
//  VersionModel.swift
//  MarkerMall
//
//  Created by apple on 2020/8/10.
//

import UIKit

@objcMembers public class VersionModel: NSObject, CKJSON {

    public required override init() {
        
    }
    
    ///操作系统 1：安卓 2：ios
    var appVersion: String!
    
    ///版本号
    var version: String!
    var versionCode: String!
    
    ///提示信息
    var info: String!
    
    ///版本号
    var edition: String!
    
    ///是否强制升级(1:是，2：否，3：静默更新)
    var upgradde: String!
    
    ///下载链接 | 新版App下载地址(灰度)
    var download: String!
    
    ///是否测试使用(1是 2：否)
    var status: String!
    
    ///最低支持版本，低于当前版本需要强制更新
    var latestUpdateVersion: String!
    
    
}
