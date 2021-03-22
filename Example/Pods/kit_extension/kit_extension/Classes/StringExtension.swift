//
//  StringExtension.swift
//  wbzhan
//
//  Created by design on 2020/12/3.
//  Copyright © 2020年 design. All rights reserved.
//

import UIKit

public extension String {
    ///过滤空字符串
    func nilString() -> String {
        if (self == "" || self == "<null>" || self == "nil" || self == "null" || self == "(null)"){
            return ""
        }
        return self
    }
    
    func stringToNum() -> NSNumber {
        if self == "(null)" || self == "null" || self == "<null>" || self.isEmpty {
            return 0
        }
        let nonDigits = CharacterSet.decimalDigits.inverted
        let numStr = self.trimmingCharacters(in: nonDigits)
        if let num = Float(numStr) {
            
            return NSNumber.init(value: num)
        }
        return 0
    }
    
    ///验证是否为合格邮箱
    func isEmail() -> Bool {
        let rule = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        
        return self.checkString(rule)
    }
    
    ///只包含英文和数字
    func isLettersNumber() -> Bool {
        let rule = "[a-zA-Z0-9]+"
        return self.checkString(rule)
        
    }
    
    ///是否是纯数字
    func isNumber() -> Bool {
        let rule = "^[0-9]*[1-9][0-9]*$"
        return self.checkString(rule)
    }
    
    ///只包含英文和汉字
    func isLettersWords() -> Bool {
        let rule = "[a-zA-Z|\\u4e00-\\u9fa5]+"
        return self.checkString(rule)
    }
    
    ///只包含英文、汉字、数字
    func isLettersWordsNumber() -> Bool {
        let rule = "^[A-Za-z0-9\\u4e00-\\u9fa5]+$"
        return self.checkString(rule)
    }
    
    ///验证是否是身份证
    func isIdNumber() -> Bool {
        if self.count == 18 {
            let rule = "/^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{4}$"
            return self.checkString(rule)
        }
        return false
    }
    
    ///check phone number is true
    func checkPhoneNumber() -> Bool {
        if self.count == 11 {
            let rule = "^[1][3,4,5,7,8][0-9]{9}$"
            return self.checkString(rule)
        }
        return false
    }
    /// check something with regular
    func checkString(_ rule: String) -> Bool  {
        let predicate = NSPredicate(format: "SELF MATCHES %@", rule)
        return predicate.evaluate(with: self)
    }
    ///获取字节数
    func stringBytes() -> Int {
        var count = 0
        for item in self {
            if ("\u{4E00}" <= item  && item <= "\u{9FA5}")  ||  ("A" <= item && item <= "Z") {
                count += 2
            }else {
                count += 1
            }
        }
        return count
    }
    
    ///字符串转base64
    func stringToBase64() -> String {
        return self.data(using: .utf8)?.base64EncodedString() ?? ""
    }
    
    ///
    func attametText(_ subText: String, _ attributeds :[NSAttributedString.Key : Any]) -> NSAttributedString {
        let mutiAttStr = NSMutableAttributedString.init(string: self)
        mutiAttStr.addAttributes(attributeds, range: self.nsRangeString(subText))
        
        return mutiAttStr
    }
    
    func nsRangeString(_ rangeStr: String) -> NSRange {
        let range = self.range(of: rangeStr)
        guard let from = range?.lowerBound.samePosition(in: self.utf16),
            let to = range?.upperBound.samePosition(in: self.utf16) else {
                return NSMakeRange(0, 0)
        }
        return NSMakeRange(self.utf16.distance(from: self.utf16.startIndex, to: from), self.utf16.distance(from: from, to: to))
    }
    
    func customSubString(_ from : Int, length : Int) -> String {
        if from >= self.count || from < 0 {
            return ""
        }
        let began = self.index(self.startIndex, offsetBy: from)
        let end = self.index(began, offsetBy: length)
        let subString = String(self[began ..< end])
        
        return subString
    }
    
    //MARK:     ---      时间字符串
    ///时间戳转时间 --  "yyyy-MM-dd HH:mm"
    func timestampToTime() -> String {
//        let timestamp = self.timeToTimestamp()
        let timeStr = self.timestampToTime("yyyy-MM-dd HH:mm:ss")
        return timeStr
    }
    
    func timestampToTime(_ formatter: String) -> String {
        let timestamp = TimeInterval(self.stringToNum().floatValue)
        let date = Date.init(timeIntervalSince1970: timestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatter
        let timeStr = dateFormatter.string(from: date)
        return timeStr
    }

    ///时间转时间戳 --  "yyyy-MM-dd HH:mm"
    func timeToTimestamp() -> String {
        return timeToTimestamp("yyyy-MM-dd HH:mm:ss")
    }
    
    func timeToTimestamp(_ formatter: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatter
        var date = dateFormatter.date(from: self)
        if  date == nil {
            date = Date()
        }
        let timestamp = "\((date?.timeIntervalSince1970)!)"
        return timestamp
    }

    ///消息时间戳转时间
    ///毫秒为单位
    func millisecondTimeStampToString() -> String {
        return self.millisecondTimeStampToString("yyyy-MM-dd HH:mm:ss")
    }
    
    func millisecondTimeStampToString(_ formatter: String) -> String {
        let num = Int(self.stringToNum().floatValue)
        if num == 0 {
            let timeStr = self.timeToTimestamp("yyyy-MM-dd HH:mm:ss")
            return timeStr.timestampToTime(formatter)
        }
        let time = String(TimeInterval(self)! / 1000.0)
        return time.timestampToTime(formatter)
    }
    
    ///去掉字符串标签
     mutating func filterHTML() -> String? {
      let scanner = Scanner(string: self)
      var text: NSString?
      while !scanner.isAtEnd {
        scanner.scanUpTo("<", into: nil)
        scanner.scanUpTo(">", into: &text)
        self = self.replacingOccurrences(of: "\(text == nil ? "" : text!)>", with: "")
      }
      return self
    }
    
    ///计算当前文字长度
     func textSize(_ maxW: CGFloat, _ font: UIFont) -> CGSize {
        let str = NSString.init(string: self)
        let size = str.boundingRect(with: CGSize.init(width: maxW, height: kScreenHeight), options: .usesLineFragmentOrigin, attributes: [.font: font as Any], context: nil).size
        return size
    }
    ///字体
    func attributeText(_ text:String,_ font:UIFont) -> NSMutableAttributedString{
        return self.attributeText(text, font, nil)
    }
    ///颜色
    func attributeText(_ text:String,_ color:UIColor) -> NSMutableAttributedString{
        return self.attributeText(text, nil, color)
    }
    ///设定字体和颜色
    func attributeText(_ text: String, _ font: UIFont? , _ color:UIColor?) -> NSMutableAttributedString{
        let attStr = NSMutableAttributedString.init(string: self)
        let range = self.nsRangeString(text)
        if color != nil {
            attStr.addAttributes([.foregroundColor : color!], range: range)
        }
        if font != nil {
            attStr.addAttributes([.font : font!], range: range)
        }
        return attStr
    }
    static func jsonStr(_ obj: Any) -> String {
        let data = try? JSONSerialization.data(withJSONObject: obj, options: [])
        let str = String(data: data!, encoding: .utf8)
        
        return str ?? ""
    }
    
    ///获取二维码
     func generateQRCode(_ rectSize:CGSize) -> UIImage? {
        
        let data = self.data(using: String.Encoding.ascii)
        
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        
        filter.setValue(data, forKey: "inputMessage")
        
        let transform = CGAffineTransform(scaleX: rectSize.width, y: rectSize.height)
        
        guard let output = filter.outputImage?.transformed(by: transform) else { return nil }
        
        return UIImage(ciImage: output)
    }
}
