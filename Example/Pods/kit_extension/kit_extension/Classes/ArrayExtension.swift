//
//  ArrayExtension.swift
//  wbzhan
//
//  Created by design on 2020/12/3.
//  Copyright © 2020年 design. All rights reserved.
//

import Foundation
public extension Array {
   
   func objAtIndex(_ index: Int) -> Element? {
       if self.isEmpty {
           return nil
       }
       if index < 0 || index >= self.count {
           return self.first
       }
       return self[index]
   }
   
}

// MARK:-、遵守 Equatable 协议的数组
public extension Array where Element : Equatable {
    
    func indexObj(_  obj: Element) -> Int {
        return self.firstIndex(of: obj) ?? 0
    }
   
    mutating func removeObj(_ obj: Element){
       let index = self.indexObj(obj)
       if index <= self.count && index > 0 {
           self.remove(at: index)
       }
   }
   
   /// 删除数组的中的元素(可删除第一个出现的或者删除全部出现的)
   /// - Parameters:
   ///   - element: 要删除的元素
   ///   - isRepeat: 是否删除重复的元素
   @discardableResult
   mutating func removeObj(_ element: Element, isRepeat: Bool = true) -> Array {
       var removeIndexs: [Int] = []
   
       for i in 0 ..< count {
           if self[i] == element {
               removeIndexs.append(i)
               if !isRepeat { break }
           }
       }
       // 倒序删除
       for index in removeIndexs.reversed() {
           self.remove(at: index)
       }
       return self
   }

   /// 从删除数组中删除一个数组中出现的元素，支持是否重复删除, 否则只删除第一次出现的元素
   /// - Parameters:
   ///   - elements: 被删除的数组元素
   ///   - isRepeat: 是否删除重复的元素
   @discardableResult
   mutating func removeArray(_ elements: [Element], isRepeat: Bool = true) -> Array {
       for element in elements {
           if self.contains(element) {
               self.removeObj(element, isRepeat: isRepeat)
           }
       }
       return self
   }
}

public extension Array where Self.Element == String {
    ///String数组生成字符串
    func toStrinig(separator: String = "") -> String {
        return self.joined(separator: separator)
    }
}
