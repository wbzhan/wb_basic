//
//  ActionShow.swift
//  MarkerMall
//
//  Created by Mac on 24.7.20.
//
///选择器
import UIKit
import RxSwift
import RxCocoa
import AVFoundation
///弹窗
@objcMembers open class ActionShow : NSObject, UIImagePickerControllerDelegate , UINavigationControllerDelegate {
       
    var getImage = PublishRelay<UIImage>()
    
   public static let shared = ActionShow()
    
    ///图像选择
    public  func showPhotoAction () {
        let alert = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let action1 = UIAlertAction.init(title: LocaledString("camera"), style: .default) { (_) in
                   self.goCamera()
               }
        let action = UIAlertAction.init(title: LocaledString("photos"), style: .default) { (_ ) in
            self.goImage()
        }
       
        let cancel = UIAlertAction.init(title: LocaledString("cancel"), style: .cancel, handler: nil)
        
        alert.addAction(action1)
        alert.addAction(action)
        alert.addAction(cancel)
        kCurrentVC()?.modalPresentationStyle = .fullScreen
        kCurrentVC()?.present(alert, animated: true, completion: nil)
    }
    
    public func goCamera(){
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let  cameraPicker = UIImagePickerController()
            cameraPicker.delegate = self
            cameraPicker.allowsEditing = true
            cameraPicker.sourceType = .camera
            
            let status = AVCaptureDevice.authorizationStatus(for: .video)
            if status == .denied {
                ActionShow.showAlert(title: "", message: "请在iPhone“设置-隐私-相机”选项中,允许多点访问你的相机")
            }else if(status == .restricted || status == .notDetermined){
                AVCaptureDevice.requestAccess(for: .video) { (authed) in
                    if authed{
                        kCurrentVC()?.present(cameraPicker, animated: true, completion: nil)
                    }
                }
            }else{
                kCurrentVC()?.present(cameraPicker, animated: true, completion: nil)
            }
        } else {
            UIView.showInfoText("un support")
        }
        
    }
    
    public  func goImage(){
        
        let photoPicker =  UIImagePickerController()
        photoPicker.delegate = self
        photoPicker.allowsEditing = true
        photoPicker.sourceType = .photoLibrary
        kCurrentVC()?.present(photoPicker, animated: true, completion: nil)
        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .automatic
        } else {
            // Fallback on earlier versions
        }
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        print("获得照片============= \(info)")
        
        let image : UIImage = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        self.getImage.accept(image)
        kCurrentVC()?.dismiss(animated: true, completion: nil)
        
    }
    
    ///内容选择
    open func showAction (_ title:String?,titles:Array<String> , _ didSelected:@escaping CallBackClosure){
        let alert = UIAlertController.init(title: title, message: nil, preferredStyle: .actionSheet)
        
        for index in 0..<titles.count {
            let name = titles.objAtIndex(index)
            let action = UIAlertAction.init(title: name, style: .default) { (ac) in
                didSelected(ac.title)
            }
            alert.addAction(action)
        }
        let cancel = UIAlertAction.init(title: LocaledString("cancel"), style: .cancel, handler: nil)
        alert.addAction(cancel)
        kCurrentVC()?.modalPresentationStyle = .fullScreen
        kCurrentVC()?.present(alert, animated: true, completion: nil)
    }
    
    ///默认弹框内容选择
      @objc open class func showAlert (title:String?,message:String?, complete:@escaping Completed){
           let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction.init(title: LocaledString("sure"), style: .default) {(_) in
                complete()
            }
            alert.addAction(action)
           let cancel = UIAlertAction.init(title: LocaledString("cancel"), style: .cancel, handler: nil)
           alert.addAction(cancel)
        kCurrentVC()?.modalPresentationStyle = .fullScreen
        kCurrentVC()?.present(alert, animated: true, completion: nil)
       }
    
    ///单独弹框内容选择
        @objc open class func showAlert (title:String?,message:String?){
              let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
               let action = UIAlertAction.init(title: LocaledString("sure"), style: .cancel)
               alert.addAction(action)
            kCurrentVC()?.modalPresentationStyle = .fullScreen
            kCurrentVC()?.present(alert, animated: true, completion: nil)
          }
}
