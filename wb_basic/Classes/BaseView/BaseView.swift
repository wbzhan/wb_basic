//
//  BaseView.swift
//  family
//
//  Created by APPLE on 2019/8/27.
//  
//

import UIKit
import RxSwift

open class BaseView: UIView {
    
    var isNib: Bool! = true
    
   public var disposeBag = DisposeBag()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    public init() {
        super.init(frame: CGRect.zero)
        self.isNib = false
        self.initUI()
        self.initData()
        self.addOthers()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.isNib = false
        self.initUI()
        self.initData()
        self.addOthers()
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        self.isNib = true
        self.initUI()
        self.initData()
        self.addOthers()
        self.layoutIfNeeded()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK:  --  publick func
   open func initData() {
        
    }
    
    open func initUI() {
        
    }
    
    open func addOthers() {
        
    }
    
}
