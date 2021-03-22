//
//  CKConstant.swift
//  wbzhan
//
//  Created by design on 2020/12/3.
//  Copyright © 2020年 design. All rights reserved.
//

import UIKit
import AppTrackingTransparency
import AdSupport
//MARK:  --  Frame
///屏幕宽度
public let kScreenWidth = UIScreen.main.bounds.size.width
///屏幕高度
public let kScreenHeight = UIScreen.main.bounds.size.height
///nav height
public let kNavHeight = CGFloat(44.0)
///status bar height
public let kStatusBarHeight = UIApplication.shared.statusBarFrame.size.height
///main view height
public let kMainHeight = kScreenHeight - kNavHeight - kStatusBarHeight
///nav and status bar height
public let kTopHeight = kNavHeight + kStatusBarHeight
///底部高度
public let kBottomHeight = (iPhoneX_All ? CGFloat(34.0) : CGFloat(0.0))
///tabBar height
public let kTabBarHeight = CGFloat(49.0)
///mainScale
public let kMainScale = UIScreen.main.scale
///one_px
public let kOne_px = 1 / kMainScale
///0高度
public let kZeroHeight = CGFloat(0.000001)


public let kServer = "server"

public let kImageDomin = "imageDomin"

public let APP_Domin = (UserDefaults.standard.object(forKey: kServer) ?? "" ) as? String ?? ""
//网络图前置地址
public let APP_image_Domin = (UserDefaults.standard.object(forKey: kImageDomin) ?? "") as? String ?? ""
//白色背景
public let kWhiteColor = UIColor.colorSrting("#FFFFFF")

public let kPlaceHolderImage = UIImage.init(named: "placeHolderImage")

//MARK:  --  System INFO
///APP  version
public let kAppVersion =  Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
///system version
public let kSystemVersion = UIDevice.current.systemVersion
///App名称
public let kAppName = (Bundle.main.infoDictionary!["CFBundleDisplayName"] as? String) ?? ""
///udid
public var kDeviceUDID :String!{
    if #available(iOS 14, *) {
        var udid = ""
        ///询问用户是否同意获取IDFA
        ATTrackingManager.requestTrackingAuthorization { (status) in
            if status == .authorized {
                udid =  ASIdentifierManager.shared().advertisingIdentifier.uuidString
            }
        }
        return udid
    }else {
        return ASIdentifierManager.shared().advertisingIdentifier.uuidString
    }
}
///判断iPhoneX所有系列
public var iPhoneX_All: Bool! {
    get {
        if UIDevice.current.userInterfaceIdiom != .phone {
            return false
        }
        if #available(iOS 11.0, *) {
            return (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0) > 0
        }
        return false
    }
}


//MARK:   --    通用闭包
///begin request data
public typealias Prepare = () -> Void
///request data success
///request data failur
public typealias Failure = (_ error: Error?) -> Void
///finished something call back
public typealias Completed = () -> Void
///带参数的回调
public typealias CallBackClosure = (_ obj: Any?) -> Void

//MARK:   ----   environment
///当前部署环境
public enum DeveloperTarget {
    ///开发
    case dev
    ///测试
    case test
    ///预发布
    case preRelease
    ///正式环境
    case release
}


