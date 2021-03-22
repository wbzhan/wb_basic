//
//  BaseWebVc.swift
//  VBCOIN
//
//  Created by wbzhan on 2020/10/28.
//

import Foundation
import WebKit
open class BaseWebVc: BaseViewController {
    
    public var webUrl : String?
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        _ = self.webView
        _ = self.progressView
        self.loadUrl(urlPath: self.webUrl)
        
    }
    //webView
    open lazy var webView : WKWebView = {
       let web = WKWebView()
        view.addSubview(web)
        web.navigationDelegate = self
        web.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        return web
    }()
    //进度条
    open lazy var progressView : UIProgressView = {
        let progress = UIProgressView()
        progress.frame = .init(x: 0, y: kNavHeight+kStatusBarHeight, width: kScreenWidth, height: 1)
        progress.progressTintColor = .blue
        progress.trackTintColor = UIColor.clear
        view.addSubview(progress)
        return progress
    }()
    //返回上一页
    open func toBack() {
       if self.webView.canGoBack {
         self.webView.goBack()
        }
      }
    
    open func loadUrl(urlPath:String?){
           //创建请求
        let request = NSURLRequest(url: NSURL(string:self.webUrl ?? "")! as URL)
           //加载请求
        self.webView.load(request as URLRequest)

    }
}

extension BaseWebVc : WKNavigationDelegate {
    
    public  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
         //  加载进度条
         if keyPath == "estimatedProgress"{
             progressView.alpha = 1.0
             progressView.setProgress(Float((self.webView.estimatedProgress) ), animated: true)
             if (self.webView.estimatedProgress )  >= 1.0 {
                 UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseOut, animations: {
                     self.progressView.alpha = 0
                 }, completion: { (finish) in
                     self.progressView.setProgress(0.0, animated: false)
                 })
             }
         }
     }

}
