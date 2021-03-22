//
//  FontExtension.swift
//  wbzhan
//
//  Created by design on 2020/12/3.
//  Copyright © 2020年 design. All rights reserved.
//

import Foundation
import UIKit

@objc public extension UIFont {
    //regular
 class func font(_ size: CGFloat) -> UIFont {
        return UIFont.init(name: "PingFangSC-Regular", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    //medium
    class func mediumFont(_ size:CGFloat ) ->UIFont {
        return UIFont.init(name: "PingFangSC-Medium", size: size) ?? UIFont.boldSystemFont(ofSize: size)
    }
    //semibold
    class func semiboldFont(_ size: CGFloat) -> UIFont {
        return UIFont.init(name: "PingFangSC-Semibold", size: size) ?? UIFont.boldSystemFont(ofSize: size)
    }
}
