//
//  BaseViewController.swift
//  family
//
//  Created by APPLE on 2019/8/22.
//  
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
@_exported import kit_extension
open class BaseViewController: UIViewController {
    
   public var disposeBag = DisposeBag()
    //是否返回rootvc
    public var isBackToRoot:Bool = false
    ///从哪个VC推出的界面
    public var fromVC: UIViewController?
    
    public var rightAction: CallBackClosure?
    public var leftAction: CallBackClosure?
    public var rightItems: [UIBarButtonItem]!
    public var letfItems: [UIBarButtonItem]!
    public var titleText: String!
    
   private let btnTag = 10
    
    deinit {
        ///释放时注销通知
        NotificationCenter.default.removeObserver(self)
        DLog("\(self.classForCoder)--deinit")
    }
    
    //MARK:  --  life cycle
    open override func viewDidLoad() {
        super.viewDidLoad()
        _ = self.backNavView
        self.navigationItem.titleView = self.titleLabel
        self.view.backgroundColor = kWhiteColor
        self.initUI()
        self.requestInfo()
        self.initData()
        self.initLanguage()
        self.addOthers()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationBarHidden = false
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIView.hudHide()
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK:  --  public func
    ///网络请求
    open func requestInfo() {
        
    }
    
    ///初始化数据源
    open func initData() {
        
    }
    
    ///初始化话界面视图
    open func initUI() {
        
    }
    ///初始化语言翻译
    open func initLanguage() {
        
    }
    
    ///手势、通知等事件的添加
    open func addOthers() {
        
    }
    ///返回上一级页面
    open func pop() {
        if self.isBackToRoot {
            self.navigationController?.popToRootViewController(animated: true)
        }else if  let vc = self.fromVC {
            self.navigationController?.popToViewController(vc, animated: true)
        }else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    ///添加导航栏右边儿按钮
    open func rightItem(_ obj: Any?) -> ControlEvent<Void> {
        var btn : UIButton!
        if obj as? UIImage != nil || obj as? String != nil {
            btn = UIButton.kit_item(obj)
            btn.titleLabel?.font = UIFont.font(16)
            btn.setTitleColor(UIColor.black, for: .normal)
            btn.contentHorizontalAlignment = .right
        }else if let button =  obj as? UIButton{
            btn = button
        }
       let item  = UIBarButtonItem.init(customView: btn)
        self.rightItems = [item]
        self.navigationItem.rightBarButtonItems = [item]
        return btn.rx.tap
    }
    
    ///设置导航栏右边按钮
    open  func rightItmes(_ array: [Any]?, _ action: CallBackClosure?) {
        self.rightAction = action
        if let items = array {
            var itemBtns: [UIBarButtonItem] = []
            for item in items {
                let rightBtn = UIButton.kit_item(item)
                rightBtn.tag = self.btnTag + items.count
                rightBtn.setTitleColor(.black, for: .normal)
                rightBtn.titleLabel?.font = UIFont.font(16)
                let item = UIBarButtonItem.init(customView: rightBtn)
                itemBtns.append(item)
                
                rightBtn.rx.tap
                    .subscribe {[weak self] _ in
                        action?(rightBtn.tag - (self?.btnTag)!)
                        
                }.disposed(by: self.disposeBag)
                
            }
            self.rightItems = itemBtns
            self.navigationItem.rightBarButtonItems = itemBtns
        }else {
            self.navigationItem.rightBarButtonItems = nil
        }
        
    }
    
    ///设置导航栏左边按钮
    open func leftItmes(_ array: [Any]?, _ action: CallBackClosure?) {
        self.leftAction = action
        if let items = array {
            var itemBtns: [UIBarButtonItem] = []
            for item in items {
                let leftBtn = UIButton.kit_item(item)
                leftBtn.width = kNavHeight
                leftBtn.tag = self.btnTag + items.count
                leftBtn.contentHorizontalAlignment = .left
                let item = UIBarButtonItem.init(customView: leftBtn)
                itemBtns.append(item)
                leftBtn.rx.tap
                    .subscribe {[weak self] _ in
                        action?(leftBtn.tag - (self?.btnTag)!)
                        
                }.disposed(by: self.disposeBag)
                
            }
            self.letfItems = itemBtns
            self.navigationItem.leftBarButtonItems = itemBtns
        }else {
            self.navigationItem.leftBarButtonItems = nil
        }
        
    }
    
    //MARK:    ---    set
    open override var title: String? {
        didSet {
            self.titleLabel.text = self.title
            self.titleText = self.title
            self.view.bringSubviewToFront(self.backNavView)
        }
    }
    
    ///隐藏导航栏
    open  var navigationBarHidden: Bool! {
        didSet {
            self.navigationController?.setNavigationBarHidden(self.navigationBarHidden, animated: false)
            self.backNavView.isHidden = self.navigationBarHidden
        }
    }
    
    //MARK:   ---     lazy
    @objc open lazy var backNavView: UIView = {
        let view = UIView.init(frame: .init(x: 0, y: 0, width: kScreenWidth, height: kTopHeight))
        view.backgroundColor = kWhiteColor
        self.view.addSubview(view)
        self.view.bringSubviewToFront(view)
        
        return view
    }()

    open lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = self.title
        titleLabel.textColor = self.titleColor ?? .black
        titleLabel.textAlignment = .center
        titleLabel.font = MediumSize(18)
        titleLabel.size = CGSize.init(width: kScreenWidth - kNavHeight * 4, height: kNavHeight)
        return titleLabel
    }()
    
    public var titleColor: UIColor! {
          didSet {
              self.titleLabel.textColor = self.titleColor
          }
      }


}

