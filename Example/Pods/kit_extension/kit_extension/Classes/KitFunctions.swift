//
//  KitFunctions.swift
//  Extension
//
//  Created by wbzhan on 2020/12/3.
//

import UIKit
///当前环境是否是生产环境
public func isDistribution() ->  Bool {
    var isDis = true
    #if DEBUG
    isDis = false
    #endif
    return isDis
}
///本地化语言
public func LocaledString(_ key: String) -> String{
    return NSLocalizedString(key, comment: "")
}
//MARK:  --    以6为标准比例缩放
///width scaled
public func kWidthScale(_ num: CGFloat) -> CGFloat {
    return (kScreenWidth / 375.0) * (num)
}
//颜色
public func HEX(_ col:String) -> UIColor {
    return UIColor.colorSrting(col)
}

public func HEX(_ col:String ,_ alpha: CGFloat) -> UIColor {
    return UIColor.colorSrting(col, alpha: alpha)
}

///按宽度比例适配size
public func kSizeScale(_ size: CGSize) -> CGSize {
    let width = kWidthScale(size.width)
    let height = width / size.width * size.height
    return CGSize.init(width: width, height: height)
}

///判断字符串为空
public func IsEmptyStr(_ string: Any?) -> Bool{
    
    if string == nil {
        return true
    }
    if string is String{
        let str = string as! String
        if (str=="" || str == "<null>" || str == "nil" || str == "null" || str == "(null)"){
            return true
        }
        return false
    }else{
        return true
    }
}
///百分比
public func PercentageNumber(_ number: Float) -> String {

    let formatter = NumberFormatter()
    formatter.numberStyle = .percent
    formatter.minimumIntegerDigits = 1//小数点前最小位数
    formatter.maximumFractionDigits = 2//小数点后最大位数
   return formatter.string(for: number)!

  }
///判断两个json数据是否相同
public func IsSameData(oldData: [String: Any], newData: [String: Any] ) -> Bool {
       return NSDictionary(dictionary: oldData).isEqual(to: newData)
   }
///价格显示（默认保留2位小数，末位为0的省略）
public func getPriceTxt(price :String!) -> String{
    
    if IsEmptyStr(price){
        return ""
    }
    let s = NSString.init(format: "%.2f", StringToFloat(str: price))
    let array = s.components(separatedBy: ".")
    
    let first = array.first!
//    var last = NSString.init(string: array.last! as NSString)
    var last =  array.last!
    while last .hasSuffix("0") {
        last = last.replacingOccurrences(of: "0", with: "")
    }
    
    if IsEmptyStr(last){
        return first
    }
        return first + "." + last
}
//MARK: --获取带图像的富文本
public func getIconText(_ iconName: String ,_ title : String ,_ originY: CGFloat) ->NSAttributedString{
    let titleStr = NSMutableAttributedString.init(string: " " + title)
    //创建图片
    let  attacment = NSTextAttachment()
    attacment.image = UIImage(named:iconName)
    attacment.bounds = CGRect.init(x: 0, y: -originY, width: attacment.image?.size.width ?? 0 , height: attacment.image?.size.height ?? 0)
    let attacStr = NSAttributedString(attachment: attacment)
    //拼接字符串
    let mutableStr = NSMutableAttributedString()
    mutableStr.append(attacStr)
    mutableStr.append(titleStr)
    return mutableStr
}


//MARK: -- 数据类型转换
public func StringToFloat(str:String)->(Float){
        
        let string = str
        var cgFloat: CGFloat = 0
        
        if let doubleValue = Double(string)
        {
            cgFloat = CGFloat(doubleValue)
        }
    return Float(cgFloat)
}

public func StringToDouble(str:String)->(Double){
        
        let string = str
    var cgFloat: Double = 0.0
        
        if let doubleValue = Double(string)
        {
            cgFloat = doubleValue
        }
    return cgFloat
}

public func StringToInt(str:String)->(Int){
        
        let string = str
        var cgInt: Int = 0
        
        if let doubleValue = Double(string)
        {
            cgInt = Int(doubleValue)
        }
        return cgInt
}
//MARK:      ---    当前显示window和vc
public func kCurrentWindow() -> UIWindow? {
    if let window = UIApplication.shared.windows.last, NSStringFromClass(window.classForCoder) == "UIRemoteKeyboardWindow" {
        return window
    }
    return UIApplication.shared.keyWindow
}

public func goTabbarIndex(_ index:Int){
  let tabarVc =  UIApplication.shared.keyWindow?.rootViewController as! UITabBarController
    kCurrentVC()?.navigationController?.popToRootViewController(animated: false)
    tabarVc.selectedIndex = index
}

public func kCurrentVC() -> UIViewController? {
    var VC = UIApplication.shared.keyWindow?.rootViewController

    if let nav = VC as? UINavigationController {
        VC = nav.viewControllers.last
        if let tab = VC as? UITabBarController {
            VC = tab.viewControllers![tab.selectedIndex]
        }
    }else if let tab = VC as? UITabBarController {
        VC = tab.viewControllers![tab.selectedIndex]
        if let nav = VC as? UINavigationController {
            VC = nav.viewControllers.last
        }
    }
    if let presetVC = VC?.presentedViewController {
        if let nav = presetVC as? UINavigationController {
            VC = nav.viewControllers.last
        }else {
            VC = presetVC
        }
    }

    return VC
}

///获取设备型号
public func kGetDeviceModel () -> String? {
    var systemInfo = utsname()
    uname(&systemInfo)
    let machineMirror = Mirror(reflecting: systemInfo.machine)
    let identifier = machineMirror.children.reduce("") { identifier, element in
        guard let value = element.value as? Int8, value != 0 else { return identifier }
        return identifier + String(UnicodeScalar(UInt8(value)))
    }
    switch identifier {
    //iPhone
    case "iPhone1,1":                 return "iPhone 1G"
    case "iPhone1,2":                 return "iPhone 3G"
    case "iPhone2,1":                 return "iPhone 3GS"
    case "iPhone3,1", "iPhone3,2":    return "iPhone 4"
    case "iPhone4,1":                 return "iPhone 4S"
    case "iPhone5,1", "iPhone5,2":    return "iPhone 5"
    case "iPhone5,3", "iPhone5,4":    return "iPhone 5C"
    case "iPhone6,1", "iPhone6,2":    return "iPhone 5S"
    case "iPhone7,1":                 return "iPhone 6 Plus"
    case "iPhone7,2":                 return "iPhone 6"
    case "iPhone8,1":                 return "iPhone 6s"
    case "iPhone8,2":                 return "iPhone 6s Plus"
    case "iPhone8,4":                 return "iPhone SE"
    case "iPhone9,1", "iPhone9,3":    return "iPhone 7"
    case "iPhone9,2", "iPhone9,4":    return "iPhone 7 Plus"
    case "iPhone10,1", "iPhone10,4":  return "iPhone 8"
    case "iPhone10,2", "iPhone10,5":  return "iPhone 8 Plus"
    case "iPhone10,3", "iPhone10,6":  return "iPhone X"
    case "iPhone11,2":                return "iPhone XS"
    case "iPhone11,4", "iPhone11,6":  return "iPhone XS Max"
    case "iPhone11,8":                return "iPhone XR"
    case "iPhone12,1":                return "iPhone 11"
    case "iPhone12,3":                return "iPhone 11 Pro"
    case "iPhone12,5":                return "iPhone SE 2"
    case "iPhone13,1":                return "iPhone 12 mini"
    case "iPhone13,2":                return "iPhone 12"
    case "iPhone13,3":                return "iPhone 12 Pro"
    case "iPhone13,4":                return "iPhone 12 Pro Max"

    case "i386", "x86_64":                          return "Simulator"
    default:
        return identifier
    }
}


/// 计算缓存大小
var cacheSize: String{
    get{
        // 路径
        let basePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        let fileManager = FileManager.default
        // 遍历出所有缓存文件加起来的大小
         func caculateCache() -> Float{
            var total: Float = 0
            if fileManager.fileExists(atPath: basePath!){
                let childrenPath = fileManager.subpaths(atPath: basePath!)
                if childrenPath != nil{
                    for path in childrenPath!{
                        let childPath = basePath!.appending("/").appending(path)
                        do{
                            let attr:NSDictionary = try fileManager.attributesOfItem(atPath: childPath) as NSDictionary
                            let fileSize = attr["NSFileSize"] as! Float
                            total += fileSize
                            
                        }catch _{
                            
                        }
                    }
                }
            }
            return total
        }
        // 调用函数
        let totalCache = caculateCache()
        return NSString(format: "%.2fMB", totalCache / 1024.0 / 1024.0 ) as String
    }
}
///清除文件缓存
public func cleanFileCache() -> Bool {
    //       var result = true
    // 取出cache文件夹目录 缓存文件都在这个目录下
    let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
    // 取出文件夹下所有文件数组
    let fileArr = FileManager.default.subpaths(atPath: cachePath!)
    // 遍历删除
    for file in fileArr! {
        // 拼接文件路径
        let path = cachePath?.appending("/\(file)")
        if FileManager.default.fileExists(atPath: path!) {
            // 循环删除
            do {
                try FileManager.default.removeItem(atPath: path!)
            } catch let error {
                DLog(error.localizedDescription)
                // 删除失败
                //                   result = false
            }
        }
    }
    return true
}
//打印内容
public func DLog<T>(_ messsage : T, file : String = #file, funcName : String = #function, lineNum : Int = #line) {
    #if DEBUG
        let fileName = (file as NSString).lastPathComponent
        print("\(fileName):(\(lineNum))：\(messsage)")
    #endif
}
