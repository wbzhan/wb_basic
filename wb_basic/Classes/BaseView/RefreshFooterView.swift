//
//  RefreshFooterView.swift
//  MarkerMall
//
//  Created by apple on 2020/7/31.
//

import UIKit
import MJRefresh
@objcMembers public class RefreshFooterView: MJRefreshBackNormalFooter {

    var noMoreText = "No More Data~"
    
    public  override func prepare() {
        super.prepare()
        
//        self.arrowView?.isHidden = true
//        self.arrowView?.alpha = 0.0
        self.stateLabel?.isHidden = true
        self.textL.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        self.leftLine.snp.makeConstraints { (make) in
            make.right.equalTo(self.textL.snp.left).offset(-15)
            make.centerY.equalTo(self.textL)
            make.size.equalTo(CGSize.init(width: 55, height: kOne_px))
        }
        self.rightLine.snp.makeConstraints { (make) in
            make.left.equalTo(self.textL.snp.right).offset(15)
            make.centerY.equalTo(self.textL)
            make.size.equalTo(CGSize.init(width: 55, height: kOne_px))
        }

        self.setNoMoreData(false)
    }
    
    public  override func endRefreshing() {
        super.endRefreshing()
        self.setNoMoreData(false)
    }
    
    public  override func endRefreshingWithNoMoreData() {
        super.endRefreshingWithNoMoreData()
        self.setNoMoreData(true)
    }
    
    public func setNoMoreData(_ noMore: Bool) {
        self.textL.text = noMore ? self.noMoreText : ""
        self.textL.isHidden = !noMore
        self.leftLine.isHidden = !noMore
        self.rightLine.isHidden = !noMore
    }
    
    lazy var textL: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.font(16)
        label.textColor = UIColor.colorSrting("#999999", alpha: 0.6)
        self.addSubview(label)
        
        return label
    }()
    
    private lazy var leftLine: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.colorSrting("#999999", alpha: 0.6)
        self.addSubview(line)
        
        return line
    }()
    
    private lazy var rightLine: UIView = {
        let line = UIView()
        line.backgroundColor = .lightGray
        self.addSubview(line)
        
        return line
    }()
}
