//
//  ToastHUD.swift
//  family
//
//  Created by 陈凯文 on 2019/9/26.
//  
//

import UIKit

public class ToastHUD: UIView {

//    static let shared = ToastHUD()
    
    ///toast延迟消失时间
    var delayTime = CGFloat(1.5)
    
    ///当前toast是否为显示状态
    private var toastShow = false
    
    private let leftEdge = CGFloat(50)
    
    private let topeEdge = CGFloat(20)
    
    ///最大显示宽度
    private static let maxW = kScreenWidth - 148
    
    public init() {
        super.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
//        self.backgroundColor = UIColor.red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func imageAcitivityTopeEdge() -> CGFloat {
        return 20
    }
    
    //MARK:    ----   lazy
    lazy var hudView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.7)
        view.setShadow()
        view.layer.cornerRadius = 10
        self.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-40)
//            make.top.equalToSuperview().offset(kScreenHeight * 0.3)
        }
        
        return view
    }()
    
    lazy var acitivityView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView.init(style: .whiteLarge)
        self.hudView.addSubview(indicatorView)
        indicatorView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(self.topeEdge)
        }
        
        return indicatorView
    }()
    
    lazy var textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.font(14)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = UIColor.white
        self.hudView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.right.bottom.equalToSuperview().offset(-self.topeEdge)
            make.left.equalToSuperview().offset(self.topeEdge)
        }
        
        return label
    }()
    
    lazy var imgView: UIImageView = {
        let imgView = UIImageView()
        imgView.tintColor = UIColor.white
        self.hudView.addSubview(imgView)
        imgView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(self.topeEdge)
        }
        
        return imgView
    }()
}


////MARK:     ----      loading show
public extension ToastHUD {
    class func ck_hudShow(_ text: String, toView: UIView) {
        let hudView = ToastHUD.hudFromView(toView)
        hudView.frame = toView.bounds
        toView.addSubview(hudView)
        
        let size = text.textSize(maxW, hudView.textLabel.font)
        hudView.textLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(hudView.acitivityView.snp.bottom).offset(self.imageAcitivityTopeEdge())
            make.width.equalTo(max(min(maxW, size.width + 10), 80))
            make.left.equalToSuperview().offset(20)
            make.right.bottom.equalToSuperview().offset(-20)
        }
        hudView.acitivityView.snp.updateConstraints { (make) in
            make.top.equalToSuperview().offset(size.width > 0 ? 20 : 40)
        }
        hudView.layoutIfNeeded()
        hudView.acitivityView.startAnimating()
        hudView.textLabel.text = text
        toView.bringSubviewToFront(hudView)
    }
    
    
    ///创建hud
    ///view          从当前view上获取hud，如果没有就new一个
    class func hudFromView(_ view: UIView) -> ToastHUD {
        guard let hud = self.getHud(view) else {
            return ToastHUD.init()
        }
        return hud
    }
    
    class func ck_hudDimiss(_ fromView: UIView) {
        if let hudView = ToastHUD.getHud(fromView) {
            hudView.acitivityView.startAnimating()
            hudView.removeFromSuperview()
        }
        
    }
    
    ///获取当前显示的hud
    class func getHud(_ fromView: UIView) -> ToastHUD? {
        return fromView.subviews.filter({ $0.classForCoder is ToastHUD.Type }).first as? ToastHUD
    }
}


//MARK:     -----    toast show
public extension ToastHUD {
    
    static var window: UIWindow? {
        UIApplication.shared.keyWindow
    }
    
    class func ck_toastError(_ text: String?) {
        self.ck_toast(text, image: UIImage.kit_image("error"))
        
    }
    
    class func ck_toastInfo(_ text: String?) {
        self.ck_toast(text, image: nil)
        
    }
    
    class func ck_toastSuccess(_ text: String?) {
        self.ck_toast(text, image: UIImage.kit_image("hudSuccess"))
        
    }

    
    class func ck_toast(_ text: String?, image: UIImage?) {
        guard self.window != nil else {
            return
        }
        self.ck_toast(text, image: image, view: self.window!)
    }
    
    class func ck_toast(_ text: String?, image: UIImage?, view: UIView) {
      
        let hudView = ToastHUD.makeToast()
        view.addSubview(hudView)
        self.perform(#selector(hideToast), with: nil, afterDelay: TimeInterval(hudView.delayTime))
        if hudView.toastShow {
            hudView.textLabel.text = text
            return
        }
        
        hudView.toastShow = true
        
        let size = text?.textSize(maxW, hudView.textLabel.font) ?? CGSize.zero
        hudView.textLabel.snp.remakeConstraints { (make) in
            if image == nil {
                make.top.equalToSuperview().offset(self.imageAcitivityTopeEdge() * 0.5)
            }else {
                make.top.equalTo(hudView.imgView.snp.bottom).offset(self.imageAcitivityTopeEdge())
            }
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.bottom.equalToSuperview().offset(-10)
            make.width.equalTo(max(min(maxW, size.width + 10), 60))
        }
        hudView.layoutIfNeeded()
        hudView.frame = hudView.hudView.frame
        hudView.textLabel.text = text
        if let img = image {
            hudView.imgView.image = img
            
        }
        
    }
    
    @objc private class func hideToast() {
//        ToastHUD.shared.removeFromSuperview()
        if let hudView = ToastHUD.getToast() {
            hudView.toastShow = false
            hudView.removeFromSuperview()
        }
        
    }
    
    ///创建toast, 从当前window上获取toast，如果没有就new一个
    class func makeToast() -> ToastHUD {
        guard let hud = self.getToast() else {
            return ToastHUD.init()
        }
        return hud
    }
    
    ///获取当前显示的toast
    private class func getToast() -> ToastHUD? {
        let views = UIApplication.shared.keyWindow?.subviews
        guard let hud = views?.filter({ $0.classForCoder is ToastHUD.Type }).first as? ToastHUD else {
            if let window = UIApplication.shared.windows.last {
                return window.subviews.filter({ $0.classForCoder is ToastHUD.Type }).first as? ToastHUD
            }
            return nil
        }
        return hud
    }
}

