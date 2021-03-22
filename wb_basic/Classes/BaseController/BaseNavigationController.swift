//
//  BaseNavigationController.swift
//  MarkerMall
//
//  Created by apple on 2020/7/17.
//

import UIKit
import RxSwift


@objcMembers public class BaseNavigationController: UINavigationController {
    
    @objc public var barStyle: UIStatusBarStyle = .lightContent
    
    public let disposeBag = DisposeBag()
        
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = kWhiteColor
        
        self.interactivePopGestureRecognizer?.delegate = self
        
        self.navigationBar.setBackgroundImage(UIImage.imageWithColor(UIColor.clear, size: CGSize.init(width: kScreenWidth, height: kTopHeight)), for: .default)
        self.navigationBar.shadowImage = UIImage.imageWithColor(UIColor.clear)
        

        self.navigationItem.titleView = self.titleLabel
        
        let dict:NSDictionary = [NSAttributedString.Key.foregroundColor: UIColor.black,NSAttributedString.Key.font : MediumSize(18)]
        //标题设置颜色与字体大小
        self.navigationController?.navigationBar.titleTextAttributes = dict as? [NSAttributedString.Key : AnyObject]
        self.extendedLayoutIncludesOpaqueBars = true
                
    }
    
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return self.barStyle
        }
    }
    
    public override var childForStatusBarStyle: UIViewController? {
       return self.topViewController
    }

    public override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        //若是push到第二个控制器
        if self.children.count > 0 && self.children.count == 1 {
            //显示tabbar
            viewController.hidesBottomBarWhenPushed = true;
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: self.backBtn)
        }
        if self.children.count > 1 {
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: self.backBtn)
        }
        
        super.pushViewController(viewController, animated: true)
    }
    
    
    public var titleColor: UIColor! {
        didSet {
            self.titleLabel.textColor = self.titleColor
        }
    }
    
    public override var title: String? {
        didSet {
            self.titleLabel.text = self.title
        }
    }
    
    //MARK:    --    lazy
    public lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = self.title
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.font = MediumSize(18)
        titleLabel.size = CGSize.init(width: kScreenWidth - kNavHeight * 4, height: kNavHeight)
        
        return titleLabel
    }()
    
    public lazy var backBtn: UIButton = {
        let backButton = UIButton.kit_item(UIImage.kit_image("nav_back_black"))
        backButton.contentHorizontalAlignment = .left
        backButton.rx.tap
            .subscribe {[weak self] _ in
                if let vc = self?.viewControllers.last as? BaseViewController {
                    vc.pop()
                }else{
                    self?.popViewController(animated: true)
                }
        }
            .disposed(by: self.disposeBag)
        
        return backButton
    }()

}

extension BaseNavigationController: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.children.count > 1 && gestureRecognizer == self.interactivePopGestureRecognizer {

            return true
        }
        return false
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == self.interactivePopGestureRecognizer, let pan = gestureRecognizer as? UIPanGestureRecognizer {
            if pan.translation(in: self.view).x > 0 {
                return true
            }
        }
        return false
    }
    
}
