//
//  UserDefaultsModel.swift
//  family
//
//  Created by APPLE on 2019/8/22.
//  
//

import UIKit

open class UserDefaultsModel: NSObject {
    
    public func setObjc(objc: Any?, key: String) {
        UserDefaults.standard.set(objc, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    public func objcForKey(key: String) -> Any? {
        return UserDefaults.standard.object(forKey: key)
    }
    
    public func setBool(bool: Bool, key: String) {
        UserDefaults.standard.set(bool, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    public func boolKey(key: String) -> Bool {
        return UserDefaults.standard.bool(forKey: key)
    }
    
    public func setInt(num: Int, key: String) {
        UserDefaults.standard.set(num, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    public func intForKey(key: String) -> Int{
        return UserDefaults.standard.integer(forKey: key)
    }
    
    public func setFloat(num: Float, key: String) {
        UserDefaults.standard.set(num, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    public func floatForKey(key: String) -> Float {
        return UserDefaults.standard.float(forKey: key)
    }
    
    class public func setObjc(objc: Any?, key: String) {
        UserDefaults.standard.set(objc, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    class public func objcForKey(key: String) -> Any? {
        return UserDefaults.standard.object(forKey: key)
    }
    
    class public func setBool(bool: Bool, key: String) {
        UserDefaults.standard.set(bool, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    class public func boolKey(key: String) -> Bool {
        return UserDefaults.standard.bool(forKey: key)
    }
    
    class public func setInt(num: Int, key: String) {
        UserDefaults.standard.set(num, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    class public func intForKey(key: String) -> Int{
        return UserDefaults.standard.integer(forKey: key)
    }
    
    class public func setFloat(num: Float, key: String) {
        UserDefaults.standard.set(num, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    class public func floatForKey(key: String) -> Float {
        return UserDefaults.standard.float(forKey: key)
    }
}
