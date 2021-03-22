//
//  ObserverExtension.swift
//  MarkerMall
//
//  Created by apple on 2020/7/13.
//

import Foundation
import RxSwift
import HandyJSON
public extension Observable {
    ///body数组
    func responseModel<T: HandyJSON>(_ type: [T].Type) -> Observable<[Any]> {
        return self.responseModel(type, nil)
    }
    ///body内包含key的数组
    func responseModel<T: HandyJSON>(_ type: [T].Type, _ dataKey: String?) -> Observable<[Any]> {
        return self.map { (obj) -> [Any] in
            if let model = obj as? ResultModel, model.success {
                var datas = model.data
                if let dataKey = dataKey, let dic = datas as? [String: Any] {
                    datas = dic[dataKey]
                }
                let data = try JSONSerialization.data(withJSONObject: datas ?? [], options: [])
                let str = String.init(data: data, encoding: .utf8)
                return type.deserialize(from: str) as! [T]
            }
            return []
        }
    }
    ///body作为model解析
    func responseModel<T: HandyJSON>(_ type: T.Type) -> Observable<T?> {
        return self.map { (obj) -> T? in
            if let model = obj as? ResultModel, model.success {
                let data = try JSONSerialization.data(withJSONObject: model.data ?? [], options: [])
                let str = String.init(data: data, encoding: .utf8)
                return type.deserialize(from: str)
            }
            return nil
        }
    }

}
