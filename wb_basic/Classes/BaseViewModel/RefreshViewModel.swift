//
//  RefreshViewModel.swift
//  family
//
//  Created by APPLE on 2019/8/28.
//  Copyright © 2019 xiaoma. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import MJRefresh
 open class RefreshViewModel: BaseViewModel {
    
    
  public var dataSource = BehaviorRelay<[SectionModel<String, Any>]>.init(value: [])
    ///停止刷新状态序列
    public var endRefreshing: Observable<Bool>!
    //停止加载状态序列
    public  var endLoading: Observable<Bool>!
    public  var endLoadNoMore: Observable<Bool>!
        
    public var isRefersh = true
    
    public  var scrollView: UIScrollView!
    
    public  var page = 1
    public  let pageSize = "10"
    
    public  var section: Int!
    
    public  var noMoreText = "No More Data~" {
        didSet {
            if let footer = self.scrollView?.mj_footer as? RefreshFooterView {
                footer.noMoreText = self.noMoreText
            }
        }
    }
    
    public init(input: (
        headerRefresh: Observable<Void>,
        footerRefresh: Observable<Void>?)) {
        super.init()
        
        self.refershLoadingSeting(input.headerRefresh, input.footerRefresh)
        
    }
    
    public init(scrollView: UIScrollView) {
        super.init()
        
        scrollView.mj_header = RefreshHeaderView()
        scrollView.mj_footer = RefreshFooterView()
        
        self.refershLoadingSeting((scrollView.mj_header?.rx.refreshing.asObservable())!, scrollView.mj_footer?.rx.refreshing.asObservable())
        
        self.bindTable(scrollView)
    }
    
    public override init() {
        super.init()
    }
    
    private func refershLoadingSeting(_ headerRefresh: Observable<Void>, _ footerRefresh: Observable<Void>?) {
        ///刷新数据
         let refreshData = headerRefresh
             .flatMapLatest{ [weak self] in self!.refreshData() }
             .share(replay: 1)
         refreshData.subscribe(onNext: {[weak self] in
            self?.refreshDatas($0)
            self?.isEmpty.accept($0.isEmpty)
         }).disposed(by: self.disposeBag)
         self.endRefreshing = refreshData.map{_ in true }
         
         if let footerRefresh = footerRefresh {
             ///加载数据
             let loadDatas = footerRefresh.flatMapLatest{[weak self] in self!.loadData() }
                 .share(replay: 1)
             loadDatas.subscribe(onNext: {[weak self] in
                self?.loadMoreDatas($0)
 
             }).disposed(by: self.disposeBag)
             
            self.endLoading = loadDatas.map{_ in
                true
                
            }
            self.endLoadNoMore = loadDatas.map{[weak self] in
                $0.count < self!.pageSize.stringToNum().intValue
                
            }
            
        }
    }
        
    ///刷新数据
    private func refreshData() -> Observable<[Any]> {
        self.page = 1
        self.scrollView?.mj_footer?.endRefreshing()
        let params = ["page": "\(self.page)", "rows": self.pageSize]
        self.isRefersh = true
        return self.refreshLoadDatas(params)
    }
    
    ///加载数据
    private func loadData() -> Observable<[Any]> {
        self.page += 1
        let params = ["page": "\(self.page)", "rows": self.pageSize]
        self.isRefersh = false
        return self.refreshLoadDatas(params)
    }
    
    //刷新数据
    public func reloadData() {
        
        let params = ["page": "\(self.page)", "rows": self.pageSize]
        self.isRefersh = true
        self.scrollView.mj_footer?.endRefreshing()
        self.refreshLoadDatas(params)
            .subscribe(onNext: {
                var array = self.dataSource.value
                if array.count == 0{
                 array = [SectionModel<String,Any>.init(model: "", items: $0)]
                }else{
                    array[self.section == nil ? array.count - 1 : self.section] = SectionModel<String,Any>.init(model: "", items: $0)
                }
                self.dataSource.accept(array)
                self.isEmpty.accept(array.count <= 0)
            }).disposed(by: self.disposeBag)
    }
    
    //MARK:   --   public func
   open func refreshLoadDatas(_ params: Any?) -> Observable<[Any]> {
        
        return Observable<[Any]>.just([])
    }
    
    ///处理刷新返回数据
    func refreshDatas(_ arr: [Any]) {
        var array = self.dataSource.value
        if array.count > 0 {
            array[self.section == nil ? array.count - 1 : self.section] = SectionModel<String,Any>.init(model: "", items: arr)
        }else {
            array.append(SectionModel<String,Any>.init(model: "", items: arr))
        }
        
        self.dataSource.accept(array)
    }
    
    ///处理加载更多返回数据
    func loadMoreDatas(_ arr: [Any]) {

        
        let datas = (self.section == nil ? (self.dataSource.value.last?.items ?? []) :(self.dataSource.value[self.section].items)) + arr
        
        var array = self.dataSource.value
        
        array[self.section == nil ? array.count - 1 : self.section] = SectionModel<String,Any>.init(model: "", items: datas)
        
//        array.append(SectionModel<String,Any>.init(model: "", items: datas))
        self.dataSource.accept(array)
    }
    
    func bindTable(_ scrollView: UIScrollView) {
        
        self.endRefreshing
            .bind(to: (scrollView.mj_header?.rx.endRefreshing)!)
            .disposed(by: self.disposeBag)

        if let footer = scrollView.mj_footer {
            self.endLoading?
                .bind(to: footer.rx.endRefreshing)
                .disposed(by: self.disposeBag)
            self.endLoadNoMore?
                .bind(to: footer.rx.endRefreshingNoMoreData)
                .disposed(by: self.disposeBag)
        }
        
        self.scrollView = scrollView
    }
    
    func setScrollView(scrollView:UIScrollView){
        scrollView.mj_header = RefreshHeaderView()
        scrollView.mj_footer = RefreshFooterView()
        
        self.refershLoadingSeting((scrollView.mj_header?.rx.refreshing.asObservable())!, scrollView.mj_footer?.rx.refreshing.asObservable())
        
        self.bindTable(scrollView)
    }
}


extension Reactive where Base: MJRefreshComponent {
    
    //正在刷新事件
    var refreshing: ControlEvent<Void> {
        let source: Observable<Void> = Observable.create {
            [weak control = self.base] observer  in
            if let control = control {
                control.refreshingBlock = {
                    observer.on(.next(()))
                }
            }
            return Disposables.create()
        }
        return ControlEvent(events: source)
    }
    
    //停止刷新
    var endRefreshing: Binder<Bool> {
        return Binder(base) { refresh, isEnd in
            if isEnd {
                refresh.endRefreshing()
            }
        }
    }
}

extension Reactive where Base: MJRefreshFooter {
    
    //没有更多数据
    var endRefreshingNoMoreData: Binder<Bool> {
        return Binder(base) { refresh, isEnd in
            if isEnd {
                refresh.endRefreshingWithNoMoreData()
            }
        }
    }
}

