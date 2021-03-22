//
//  File.swift
//  MarkerMall
//
//  Created by apple on 2020/6/4.
//

import Foundation
import UIKit
import Kingfisher

public extension UIImageView {
    
    ///加载网络图片
    @objc func setWebImage(_ url: String?) {
        self.setWebImage(url, success: nil)
    }
    
    ///加载网络图片,  加载完成回调
    @objc func setWebImage(_ url: String?, success: ((_ image: UIImage) -> Void)?) {
        self.setWebImage(url, placeholder: kPlaceHolderImage, success: success)
        
    }
    
   
    ///加载网络图片
    ///设置加载中图片
    @objc func setWebImage(_ url: String?, placeholder: UIImage?) {
        self.setWebImage(url, placeholder: placeholder, success: nil)
        
    }
    
    ///加载网络图片,  加载完成回调
    ///设置加载中图片
    @objc func setWebImage(_ url: String?, placeholder: UIImage?, success: ((_ image: UIImage) -> Void)?) {
        guard var url = url, !url.isEmpty else {
            self.image = placeholder
            return
        }
        
        url = url.replacingOccurrences(of: " ", with: "")
        url = (url.hasPrefix("http") ? "" : "http:") + url
        
        guard let imgUrl = URL.init(string: url) else {
            self.image = placeholder
            return
        }
        self.kf.setImage(with: imgUrl, placeholder: placeholder, options: [.transition(.fade(1))], progressBlock: nil) { (rs) in
            switch rs {
            case .success(let sus): do {
                    
                success?(sus.image)
                
                }
            case .failure(let error): do {
                DLog(error.localizedDescription)
                
                }
            }
        }
        
    }
    
    //MARK:    ----    class   func
    @objc class func setWebImage(_ url: String?, success: ((_ image: UIImage) -> Void)?) {
        guard var str = url else {
            return
        }
        if str.hasPrefix("//") {
            str = "https:" + str
        }
        guard let imgUrl = URL.init(string: str) else {
            return
        }
        KingfisherManager.shared.downloader.downloadImage(with: imgUrl, options: [.transition(.fade(1))], progressBlock: nil)  { (rs) in
                   switch rs {
                   case .success(let sus): do {
                           
                           success?(sus.image)
                       }
                   case .failure(let error): do {
                           DLog(error.localizedDescription)
                       }
                   }
               }

    }
    
    ///设置本地图片
    @objc func setLocalImage(name:String?){
        self.image = UIImage.init(named: name ?? "zhanweitu")
    }
}

