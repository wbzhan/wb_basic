//
//  UIViewExtension.swift.swift
//  wbzhan
//
//  Created by design on 2020/12/3.
//  Copyright © 2020年 design. All rights reserved.
//

import Foundation
import UIKit


//MARK:   --    分类设置
@objc public extension UIView {
    
    var left:CGFloat {
       get {
           return self.frame.origin.x
       }
       set(newLeft) {
           var frame = self.frame
           frame.origin.x = newLeft
           self.frame = frame
       }
   }
   
    var top:CGFloat {
       get {
           return self.frame.origin.y
       }
       
       set(newTop) {
           var frame = self.frame
           frame.origin.y = newTop
           self.frame = frame
       }
   }
   
   var width:CGFloat {
       get {
           return self.frame.size.width
       }
       
       set(newWidth) {
           var frame = self.frame
           frame.size.width = newWidth
           self.frame = frame
       }
   }
   
   var height:CGFloat {
       get {
           return self.frame.size.height
       }
       
       set(newHeight) {
           var frame = self.frame
           frame.size.height = newHeight
           self.frame = frame
       }
   }
   
   var right:CGFloat {
       get {
           return self.left + self.width
       }
       set(newRight) {
                  var frame = self.frame
           frame.origin.x = newRight - self.width
                  self.frame = frame
              }
   }
   
   var bottom:CGFloat {
       get {
           return self.top + self.height
       }
       set(newBottom) {
              var frame = self.frame
           frame.origin.y = newBottom - self.height
              self.frame = frame
          }
   }
    
   
   var centerX:CGFloat {
       get {
           return self.center.x
       }
       
       set(newCenterX) {
           var center = self.center
           center.x = newCenterX
           self.center = center
       }
   }
   
   var centerY:CGFloat {
       get {
           return self.center.y
       }
       
       set(newCenterY) {
           var center = self.center
           center.y = newCenterY
           self.center = center
       }
   }

    var size: CGSize{
        get{
            return self.frame.size
        }
        set{
            var frame = self.frame
            frame.size = newValue
            self.frame = frame
        }
    }
    
    ///设置部分圆角
    func addRoundedCorners(corners: UIRectCorner, radii: CGSize, viewRect: CGRect) {
        let path = UIBezierPath.init(roundedRect: viewRect, byRoundingCorners: corners, cornerRadii: radii)
        let layer = CAShapeLayer()
        layer.frame = viewRect
        layer.path = path.cgPath
        
        self.layer.mask = layer
    }
    
    //MARK:    --   func
    /// 添加自定义阴影
    /// - Parameters:
    ///   - color: 阴影颜色
    ///   - shadowOpacity: 阴影透明度
    ///   - shadowRadius: 阴影半径
    ///   - shadowOffset: 阴影偏移,x向右偏移0，y向下偏移，默认(0, -3),和shadowRadius配合使用
    func setShadow(color:UIColor = UIColor.lightGray,shadowOpacity:Float = 0.3,shadowRadius:CGFloat = 3,shadowOffset:CGSize = .init(width: 0, height: 3)){
        self.layoutIfNeeded()
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowRadius = shadowRadius
    }
    
    ///设置显示模式
    func setShowMode(_ mode:  UIView.ContentMode) {
        self.clipsToBounds = true
        self.contentMode = mode
    }
    
    /// 添加渐变色图层
    func gradientColor(_ colors: [Any]) {
        self.removeGradientLayer()
        self.superview?.layoutIfNeeded()
        if self.width <= 0 || self.height <= 0 {
            return
        }
        let layer = CAGradientLayer()
        layer.frame = self.bounds
        ///设置颜色
        layer.colors = colors
        ///设置颜色渐变的位置 （我这里是横向 中间点开始变化）
        layer.locations = [0,1]
        
        ///开始的坐标点
        layer.startPoint = CGPoint(x: 0, y: 0)
        ///结束的坐标点
        layer.endPoint = CGPoint(x: 1, y: 0)
        self.layer.addSublayer(layer)
    }
    
    /// 移除渐变图层
    func removeGradientLayer() {
        if let sl = self.layer.sublayers {
            for layer in sl {
                if layer.isKind(of: CAGradientLayer.self) {
                    layer.removeFromSuperlayer()
                }
            }
        }
    }
    
    ///MARK: - UIView转UIImage
     func viewToImage() -> UIImage {
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale)
    let context = UIGraphicsGetCurrentContext()
    self.layer.render(in: context!)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image!
    }
    

}
