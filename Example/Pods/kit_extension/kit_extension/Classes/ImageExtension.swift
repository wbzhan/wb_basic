//
//  ImageExtension.swift
//  wbzhan
//
//  Created by design on 2020/12/3.
//  Copyright © 2020年 design. All rights reserved.
//

import Foundation
import UIKit

@objc extension UIImage {
    ///init image form file
    class public func kit_image(_ imageName: String?) -> UIImage? {
        return UIImage.init(named: imageName!)
    }
    
    ///init image form color
    class public func imageWithColor(_ color: UIColor) -> UIImage? {
        return self.imageWithColor(color, size: CGSize.init(width: 1.0, height: 1.0))
    }
    ///init image form color, custom image size
    class public func imageWithColor(_  color: UIColor, size: CGSize) -> UIImage? {
        let rect = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? nil
    }
    
    ///image clips to fillet
    public func filletImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.size, false, 2.0)
        let rect = CGRect.init(x: 0, y: 0, width: self.size.width, height: self.size.height)
        UIGraphicsGetCurrentContext()?.addEllipse(in: rect)
        UIGraphicsGetCurrentContext()?.clip()
        
        self.draw(in: rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image ?? nil
        
    }
    
    public func resetImageOrientation() -> UIImage? {
        UIGraphicsBeginImageContext(self.size)
        let rect = CGRect.init(x: 0, y: 0, width: self.size.width, height: self.size.height)
//        UIGraphicsGetCurrentContext()?.addEllipse(in: rect)
//        UIGraphicsGetCurrentContext()?.clip()
        
        self.draw(in: rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image ?? nil
    }

}
