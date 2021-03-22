//
//  RefreshFooterView.swift
//  
//
//  Created by apple on 23.10.20.
//

import MJRefresh
public class RefreshHeaderView: MJRefreshHeader {
    
    var canRefresh = true
    
    weak var bgView : UIView?
    
    weak var loading : UIActivityIndicatorView?
    
    public  override func prepare() {
        super.prepare()
        let view = UIView()
        view.backgroundColor = .clear
        self.addSubview(view)
        self.bgView = view
        self.mj_h = kNavHeight
       
        let loading = UIActivityIndicatorView.init(style: .gray)
        loading.hidesWhenStopped = false
        self.addSubview(loading)
        self.loading = loading
    }
    
    public override func placeSubviews() {
        super.placeSubviews()
        let ViewHeight = kScreenHeight - self.mj_h;
     
        self.bgView!.frame = .init(x: 0, y: self.mj_h - ViewHeight, width: kScreenHeight, height: ViewHeight)
        self.loading?.snp.makeConstraints({ (make) in
            make.center.equalTo(self)
        })
    }
    
    public override var state: MJRefreshState{
        didSet{
            if !self.canRefresh {
                return
            }
            switch state {
            case .refreshing:
                self.loading?.startAnimating()
            default:
                self.loading?.stopAnimating()
            }
        }
    }
    
    public override var pullingPercent: CGFloat{
        didSet{
            let large =  min(1.5, (pullingPercent + 0.5))
            self.loading?.alpha = pullingPercent/1.0
            self.loading?.transform = CGAffineTransform.init(translationX: large, y: large)
        }
    }
}
