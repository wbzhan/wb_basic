//
//  AlertHUD.swift
//  VBCOIN
//
//  Created by apple on 28.10.20.
//

import Foundation
import RxSwift
import RxCocoa

public class AlertHUD: UIView {

    var disposeBag = DisposeBag()
//    static let shared = AlertHUD()
        
    var sureAction: Completed?
    
    var cancelAction: Completed?
    
    ///当前toast是否为显示状态
    private var toastShow = false
        
    
    private init() {
        super.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
        self.backgroundColor = .colorSrting("#000000", alpha: 0.4)
        _ = self.singleBtn
        _ = self.cancelBtn
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
        view.backgroundColor = kWhiteColor
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        self.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(kScreenWidth - 104)
        }
        return view
    }()
    
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .mediumFont(16)
        label.textColor = .black
        label.numberOfLines = 0
        self.hudView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.left.top.equalTo(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        return label
    }()
    
    lazy var desLabel: UILabel = {
       let label = UILabel()
        label.font = .font(12)
        label.textColor = .black
        label.numberOfLines = 0
        self.hudView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.left.equalTo(self.titleLabel)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(6)
            make.right.equalToSuperview().offset(-16)
        }
        return label
    }()
    

    lazy var cancelBtn: UIButton = {
        let btn = UIButton.init()
        btn.setTitle(LocaledString("cancel"), for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = .mediumFont(15)
        self.hudView.addSubview(btn)
        btn.snp.makeConstraints { (make) in
            make.width.height.bottom.equalTo(self.sureBtn)
            make.right.equalTo(self.sureBtn.snp.left).offset(-30)
        }
        btn.rx.tap.subscribe(onNext: {
            AlertHUD.hideToast()
            self.cancelAction?()
        }).disposed(by: self.disposeBag)
        return btn
    }()
    
    lazy var sureBtn: UIButton = {
        let btn = UIButton.init()
        btn.setTitle(LocaledString("sure"), for: .normal)
        btn.setTitleColor(.blue, for: .normal)
        btn.titleLabel?.font = .mediumFont(15)
        self.hudView.addSubview(btn)
        btn.snp.makeConstraints { (make) in
            make.width.greaterThanOrEqualTo(50)
            make.height.equalTo(22)
            make.bottom.equalToSuperview().offset(-16)
            make.right.equalToSuperview().offset(-8)
            make.top.equalTo(self.desLabel.snp.bottom).offset(30)
        }
        btn.rx.tap.subscribe(onNext: {
            AlertHUD.hideToast()
            self.sureAction?()
        }).disposed(by: self.disposeBag)
        return btn
    }()
    
    lazy var singleBtn: UIButton = {
        let btn = UIButton.init()
        btn.setTitle(LocaledString("sure"), for: .normal)
        btn.setTitleColor(.blue, for: .normal)
        btn.titleLabel?.font = .mediumFont(15)
        btn.isHidden = true
        btn.rx.tap.subscribe(onNext: {
            AlertHUD.hideToast()
            self.sureAction?()
        }).disposed(by: self.disposeBag)
        btn.addLine(isBottom: false, color: .colorSrting("#3F3F3F"))
        self.hudView.addSubview(btn)
        btn.snp.makeConstraints { (make) in
            make.left.width.bottom.equalToSuperview()
            make.height.equalTo(40)
            make.top.equalTo(self.sureBtn)
        }
        return btn
    }()

}


////MARK:     ----      loading show
extension AlertHUD {
    

    ///创建hud
    ///view          从当前view上获取hud，如果没有就new一个
    class func hudFromView(_ view: UIView) -> AlertHUD {
        guard let hud = self.getHud(view) else {
            return AlertHUD.init()
        }
        return hud
    }
    
    class func ck_hudDimiss(_ fromView: UIView) {
        if let hudView = AlertHUD.getHud(fromView) {
            hudView.removeFromSuperview()
        }
        
    }
    
    ///获取当前显示的hud
    class func getHud(_ fromView: UIView) -> AlertHUD? {
        return fromView.subviews.filter({ $0.classForCoder is AlertHUD.Type }).first as? AlertHUD
    }
}


//MARK:     -----    toast show
extension AlertHUD {
    
    static var window: UIWindow? {
        UIApplication.shared.keyWindow
    }
    ///弹出警告文字，没有取消按钮
    class func alertInfo(_ text: String? , complete: Completed?){
        guard self.window != nil else {
            return
        }
        self.alertInfo(text, content: nil, isRemind: true, view: self.window!, cancel: nil, sure: complete)
    }
    ///弹出提示文字，有确认和取消
    class func alertInfo(_ text: String? , cancel: Completed? , sure: Completed?){
        guard self.window != nil else {
            return
        }
        self.alertInfo(text, nil, cancel: cancel, sure: sure)

    }
    //弹出带标题+文字说明的弹框
    class func alertInfo(_ text: String? , _ des: String?, cancel: Completed? , sure: Completed?){
        guard self.window != nil else {
            return
        }
        self.alertInfo(text, content: des, isRemind: false, view: self.window!, cancel: cancel, sure: sure)
    }
    
   private class func alertInfo(_ title: String?, content: String? ,isRemind : Bool!, view: UIView ,cancel:Completed? ,sure: Completed?) {
      
        let hudView = AlertHUD.makeToast()
        view.addSubview(hudView)
        
        hudView.titleLabel.text = title
        //没有说明，只有标题
        if content == nil {
            if isRemind {
                hudView.titleLabel.textAlignment = .center
            }else{
                hudView.titleLabel.textAlignment = .left
            }
            hudView.singleBtn.isHidden = !isRemind
            hudView.cancelBtn.isHidden = isRemind
            hudView.sureBtn.isHidden = isRemind

        }else{//有说明文字
            hudView.desLabel.text = content
        }
        hudView.toastShow = true
        
        hudView.cancelAction = cancel
        hudView.sureAction = sure
    
    }
    
    @objc private class func hideToast() {
        if let hudView = AlertHUD.getToast() {
            hudView.toastShow = false
            hudView.removeFromSuperview()
        }
        
    }
    
    ///创建toast, 从当前window上获取toast，如果没有就new一个
    class func makeToast() -> AlertHUD {
        guard let hud = self.getToast() else {
            return AlertHUD.init()
        }
        return hud
    }
    
    ///获取当前显示的toast
    private class func getToast() -> AlertHUD? {
        let views = UIApplication.shared.keyWindow?.subviews
        guard let hud = views?.filter({ $0.classForCoder is AlertHUD.Type }).first as? AlertHUD else {
            if let window = UIApplication.shared.windows.last {
                return window.subviews.filter({ $0.classForCoder is AlertHUD.Type }).first as? AlertHUD
            }
            return nil
        }
        return hud
    }
}
