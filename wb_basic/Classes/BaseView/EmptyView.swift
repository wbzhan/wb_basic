//
//  EmptyView.swift
//  MarkerMall
//
//  Created by apple on 2020/7/23.
//

import UIKit
import RxSwift

@objcMembers  class EmptyView: BaseView {

    override func initUI() {
        _ = self.imgView
        _ = self.textLabel
    }
    
    //MARK:    ---   func
    func setBtnTitle(_ title: String, tapAction: Completed?) {
        self.btn.setTitle(title, for: .normal)
        self.btn.rx.tap.asObservable().subscribe { (_) in
            tapAction?()
        }.disposed(by: self.disposeBag)
    }
    
    //MARK:     ---   set
    var image: String! {
        didSet {
            self.imgView.image = UIImage.kit_image(self.image)
        }
    }
    
    var text: String! {
        didSet {
            self.textLabel.text = self.text
        }
    }
    
    var subText: String! {
        didSet {
            self.subtextLabel.text = self.subText
        }
    }
    
    //MARK:    ----    lazy
    private lazy var imgView: UIImageView = {
       let view = UIImageView()
        view.image = UIImage.kit_image("icons_nodata")
        self.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.centerX.top.equalToSuperview()
        }
        
        return view
    }()
    
    lazy var textLabel: UILabel = {
        let label = UILabel.kit_label(16)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.text = "No Data~"
        label.numberOfLines = 0
        self.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.top.equalTo(self.imgView.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(24)
        }
        
        return label
    }()
    
    lazy var subtextLabel: UILabel = {
        let label = UILabel.kit_label(12)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.numberOfLines = 0
        self.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.top.equalTo(self.textLabel.snp.bottom).offset(12)
            make.centerX.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(24)
        }
        
        return label
    }()
    
    lazy var btn: UIButton = {
        let btn = UIButton.kit_button(title: "")
        btn.backgroundColor = .red
        btn.layer.cornerRadius = 15
        btn.layer.masksToBounds = true
        self.addSubview(btn)
        btn.snp.makeConstraints { (make) in
            make.top.equalTo(self.textLabel.snp.bottom).offset(12)
            make.centerX.bottom.equalToSuperview()
            make.height.equalTo(30)
        }
        
        return btn
    }()

}
