//
//  MoyaManager.swift
//  net
//
//  Created by apple on 2019/9/12.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit
import Moya
import RxSwift
import Alamofire
@objc public class MoyaManager: NSObject {
    
    ///request data success
    public typealias Success = (_ result: ResultModel?) -> Void

    public typealias Prepare = () -> Void

    @objc public static let shared = MoyaManager()
    
    private let provider = MoyaProvider<BaseApi>()
    
    var disposeBag = DisposeBag()
    
    // 网络变化监测
    private let manager = NetworkReachabilityManager.init(host: APP_Domin)
    
    private let netTips = "网络不给力，请检查您的网络"

    private override init() {
        super.init()
//        self.startNetMonitoring()
        
    }
    //MARK:    ---    开启网络监测
    func startNetMonitoring() {
        
        self.manager?.startListening(onUpdatePerforming: { (status) in

            switch status {
            case .notReachable:///没网
                print("没有网络")
                break
            case .unknown:///未知网络
                print("未知网络")
                break
            case .reachable(.ethernetOrWiFi):///wifi
                print("wifi")
                break
            case .reachable(.cellular):///蜂窝网络
                print("蜂窝网络")
                break
            }
            
            
        })
    }


    ///开始网络请求
    public func requestDatas(api: BaseApi, prepare: Prepare?) -> Observable<ResultModel?> {

        if !self.haveNet {
            return Observable<ResultModel?>.just(nil)
        }
        ///请求操作之前
        prepare?()
        switch api {
        case .upload(_, _, _, _):
            ///上传图片
            return self.provider.rx.request(api)
                .map{ (data) -> ResultModel? in
                    print(data)
                    var rst = ResultModel()
                    rst.code = "-100"
                    if let str = String.init(data: data.data, encoding: String.Encoding.utf8) {
                        rst.data = str
                        rst.code = "1"
                    }

                    return rst

             }.catchError(self.catchError()).asObservable()
        default:
            return self.provider.rx.request(api).mapJSON()
                .map{
                    print("请求结果: \(api.path) \n \($0)")
                    return ResultModel.deserialize(from: $0 as? [String: Any])
            }.catchError(self.catchError()).asObservable()
                .flatMapLatest{[weak self] in (self?.ck_requesetInvalid($0, api: api))! }
        }
    }
    
    ///其他非本App内部URL请求
    public func baseRequestDatas(api: BaseApi, prepare: Prepare?) -> Observable<Any> {
        if !self.haveNet {
            return Observable<Any>.just("")
        }
        ///请求操作之前
        prepare?()

        return self.provider.rx.request(api)
        .mapJSON().asObservable()
    }
    
    ///处理请求结果异常报错
    private func catchError() -> (_ error: Error) -> PrimitiveSequence<SingleTrait, ResultModel?> {
        return { (error) -> PrimitiveSequence<SingleTrait, ResultModel?> in
            print(error)
            var model = ResultModel()
            model.msg = error.localizedDescription
            return PrimitiveSequence<SingleTrait, ResultModel?>.just(model)
        }
    }

    ///处理网络请求异常
    private func ck_requesetInvalid(_ rs: ResultModel?, api: BaseApi) -> Observable<ResultModel?> {
        self.showErrorMessage(rs)
        return Observable<ResultModel?>.just(rs)
    }
    
    private func showErrorMessage(_ rs: ResultModel?) {
        if !(rs?.code == SUCCESS_CODE) {
            //--系统内部的错误提示给弹框，系统外的不显示
            #if Development
            UIView.showErrorText(rs?.msg ?? rs?.message)
            #elseif Distribution
            UIView.showErrorText(rs?.msg ?? "error")
            #endif
            print("错误提示")
        }
    }

    //MARK:    ----    class  func
    ///网络请求
    ///prepare   nil则没有加载toast
    public class func requestDatas(api: BaseApi, prepare: Prepare?) -> Observable<ResultModel?> {
        return MoyaManager.shared.requestDatas(api: api, prepare: prepare)
    }

    ///其他非本App内部URL请求
    ///prepare   nil则没有加载toast
    public class func baseRequestDatas(api: BaseApi, prepare: Prepare?) -> Observable<Any> {
        return MoyaManager.shared.baseRequestDatas(api: api, prepare: prepare)
    }
    ///Oc调用
    @objc func postUrl(url: String, params: NSDictionary, success: ((_ reslut: NSDictionary?) -> Void)?) {

        var urlStr = url
        if urlStr.hasPrefix("http") {
            urlStr = urlStr.components(separatedBy: APP_Domin).last ?? ""
        }
        let api = BaseApi.post(params, urlStr)
        self.requestDatas(api: api) {
            
        }.subscribe(onNext: { (rs) in
            self.showErrorMessage(rs)
            success?(rs?.toJSON()  as NSDictionary?)
        }).disposed(by: self.disposeBag)
            
    }
    
    @objc func getUrl(url: String, params: NSDictionary, success: ((_ reslut: Any) -> Void)?) {

        var url = url
        if !url.hasPrefix("http") {
            url = "https:" + url
        }
        
        AF.request(url, method: .get).responseJSON { (response) in
            switch response.result {
            case .success(let json):
                success?(json)
                break
            case .failure(let error):
                print("error:\(error)")
                break
            }
        }
    }

    
    //MARK:   ----   get
    @objc var haveNet: Bool {
        if !self.manager!.isReachable {
            UIView.showErrorText(self.netTips)
        }
        return self.manager!.isReachable
    }
    
}
