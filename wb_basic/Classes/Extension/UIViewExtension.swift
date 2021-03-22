//
//  UIViewExtension.swift
//  TCBase
//
//  Created by wbzhan on 2020/12/3.
//

import UIKit
extension UIView {
    
    //MARK:     ----   loading
    ///加载框显示
    @objc public func hudShow() {
        self.hudShow("")
    }
    
    @objc public func hudShow(_ text: String?) {
        ToastHUD.ck_hudShow(text ?? "", toView: self)
    }
    
    @objc public func hudHide() {
        ToastHUD.ck_hudDimiss(self)
    }
    
    @objc public class func hudShow() {
        self.hudShow("")
    }
    
    @objc public class func hudShow(_ text: String?) {
        ToastHUD.ck_hudShow(text ?? "", toView: kCurrentVC()?.view ?? UIApplication.shared.keyWindow!)
    }
    
    @objc public class func hudHide() {
        guard kCurrentWindow() != nil else{
            return
        }
        ToastHUD.ck_hudDimiss(kCurrentVC()?.view ?? kCurrentWindow()!)
    }
    
    //MARK:   ----    toast
    /** 错误提示信息 */
    @objc public class func showErrorText(_ text: String?) {
        ToastHUD.ck_toastError(text)
    }
    /** 成功提示信息 */
    @objc public class func showSuccessText(_ text: String?) {
        ToastHUD.ck_toastSuccess(text)
    }

    /** 提示信息 */
    @objc public class func showInfoText(_ text: String?) {
        ToastHUD.ck_toastInfo(text)
    }

    /** 展示信息纯文字 */
    @objc public class func show(_ text: String?) {
        ToastHUD.ck_toast(text, image: nil)
    }
    
    ///添加分割线
    public func addLine(isBottom:Bool!){
        addLine(isBottom: isBottom, color: UIColor.colorSrting("#F2F2F2"))
    }
    
    public  func addLine(isBottom:Bool!,color:UIColor?){
        let line = UIView.init()
        line.backgroundColor = color
        self.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.width.equalToSuperview()
            make.height.equalTo(kOne_px)
            if isBottom{
                make.bottom.equalToSuperview()
            }else{
                make.top.equalToSuperview()
            }
        }
    }
    
}
