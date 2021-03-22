//
//  UILabelExtension.swift
//  wbzhan
//
//  Created by design on 2020/12/3.
//  Copyright © 2020年 design. All rights reserved.
//

import Foundation
import UIKit

@objc public extension UILabel {
     func textShadow(_ str: String) {
        let myShadow = NSShadow()
        myShadow.shadowBlurRadius = 3
        myShadow.shadowOffset = CGSize.init(width: 1, height: 1)
        myShadow.shadowColor = UIColor.gray
        
        let attributedStr = NSAttributedString.init(string: str.nilString(), attributes: [NSAttributedString.Key.shadow : myShadow])
        self.attributedText = attributedStr
    }
    ///快速实例化label
    class func kit_label(_ fontSize: CGFloat) ->  UILabel {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: fontSize)
        return label
    }
    
    ///设置颜色
     func setAttibuesText(_ text: String, subText: String?, color: UIColor) {
        self.attributedText = text.attributeText(subText ?? "", color)
    }
    
    ///设置字体
     func setAttibuesText(_ text: String, subText: String?, font: UIFont) {
        self.attributedText = text.attributeText(subText ?? "", font)
    }
    ///设置字体和颜色
     func setAttibuesText(_ text: String, subText: String?, color: UIColor ,font : UIFont) {
        self.attributedText = text.attributeText(subText ?? "", font, color)

    }
    ///获取attr
     class func getAttibuesText(_ text: String, subText: String?, font: UIFont) -> NSAttributedString {
           let attStr = NSMutableAttributedString.init(string: text)
           attStr.addAttributes([.font : font], range: text.nsRangeString(subText ?? ""))
          return attStr
       }
    ///设置行间距
     func setAttributeTxt(_ text: String, lineSpace:CGFloat){
        let attStr = NSMutableAttributedString.init(string: text)
        
        let paragraphStype = NSMutableParagraphStyle.init()
        paragraphStype.lineSpacing = lineSpace
        paragraphStype.lineBreakMode = self.lineBreakMode
        paragraphStype.alignment = self.textAlignment
        attStr.addAttributes([.paragraphStyle : paragraphStype], range: text.nsRangeString(text))
        self.attributedText = attStr
    }
}
