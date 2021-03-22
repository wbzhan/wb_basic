//
//  BaseViewModel.swift
//  family
//
//  Created by APPLE on 2019/8/27.
//  
//

import UIKit
import RxSwift
import RxCocoa
open class BaseViewModel: NSObject  {
    
   public var disposeBag = DisposeBag()
    
    public var isEmpty = PublishRelay<Bool>()
    //旧数据,用来判断是否需要刷新页面
    public var oldData = [String: Any]()
    
    @objc public var versioModel: VersionModel!
        
    deinit {
        DLog("deint ------  \(self.classForCoder)")
    }

        
    ///加载缓存数据
    open func loadCacheData(_ completed: Completed) {
        
    }
    
    
    ///创建和更新数据库
    @objc public class func initDB() {
        DBManager.standard.initUpdateDB()
    }

}
