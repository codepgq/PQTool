//
//  PQHUD.swift
//  SmartHub
//
//  Created by cxb on 17/4/7.
//  Copyright © 2017年 pgq. All rights reserved.
//

import UIKit

/*
public enum PQPushType: String {
    /// wifi
    case wifi =             "A p p - P r e f s : r o o t = WIFI"
    /// bluetooth
    case bluetooth =        "A p p - P r e f s : r o o t = Bluetooth"
    /// 蜂窝移动网络
    case wwan =             "A p p - P r e f s : r o o t = MOBILE_DATA_SETTINGS_ID"
    /// 热点
    case ap =               "A p p - P r e f s : r o o t = INTERNET_TETHERING"
    /// 运营商
    case carrier =          "A p p - P r e f s : r o o t = Carrier"
    /// 通知
    case noti =             "A p p - P r e f s : r o o t = NOTIFICATIONS_ID"
    /// 通用
    case general =          "A p p - P r e f s : r o o t = General"
    /// 关于手机
    case aboutPhone =       "A p p - P r e f s : r o o t = General&path=About"
    /// 键盘
    case keybaord =         "A p p - P r e f s : r o o t = General&path=Keyboard"
    /// 辅助功能
    case accessibility =    "A p p - P r e f s : r o o t = General&path=ACCESSIBILITY"
    /// 语言地区
    case region =           "A p p - P r e f s : r o o t = General&path=INTERNATIONAL"
    /// 重置手机
    case reset =            "A p p - P r e f s : r o o t = Reset"
    /// 墙纸
    case wallpaper =        "A p p - P r e f s : r o o t = Wallpaper"
    /// siri
    case siri =             "A p p - P r e f s : r o o t = SIRI"
    /// 隐私
    case privacy =          "A p p - P r e f s : r o o t = Privacy"
    /// safari
    case safari =           "A p p - P r e f s : r o o t = SAFARI"
    /// 音乐
    case music =            "A p p - P r e f s : r o o t = MUSIC"
    /// 音乐均衡器
    case musicEQ =          "A p p - P r e f s : r o o t = MUSIC&path=com.apple.Music:EQ"
    /// 照片与相机
    case photo =            "A p p - P r e f s : r o o t = Photos"
    /// facetime
    case facetime =         "A p p - P r e f s : r o o t = FACETIME"
    case vpn =              "A p p - P r e f s : r o o t = General&path=Network/VPN"
}*/

public class PQHUD: NSObject {
    
    public static let share: PQHUD = PQHUD()
    public static var dismissTimeInterval: TimeInterval = 0.75
    
    #if false
    public class func push(_ type: PQPushType){
        push(type.rawValue.split(separator: " ").map(String.init).reduce("", { $0 + $1 }))
    }
    
    /// 跳转到WIFI设置界面
    public class func jumpToWIFI(){
        push(.wifi)
    }
    
    public class func jumpToMusic(){
        push(.music)
    }
    public class func jumpToNoti(){
        push(.noti)
    }
    
    #endif
    
    class func push(_ string: String){
        let url = URL(string: string)
        if UIApplication.shared.canOpenURL(url!) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url!)
            }
        }
    }
    
    
    
    public class func jumpToMyAppSet(){
        push(UIApplicationOpenSettingsURLString)
    }
    
    public class func defaultSetHUD(_ block: (() -> ())?){
        SVProgressHUD.setMinimumDismissTimeInterval(50)
        //设置遮罩模式 不允许用户操作N
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.setAnimationCurve(.linear)
        SVProgressHUD.setFont(UIFont.systemFont(ofSize: 15))
        block?()
    }
    
    /// 设置遮罩
    ///
    /// - Parameter mask: 遮罩
    public class func setMask(_ mask : SVProgressHUDMaskType){
        SVProgressHUD.setDefaultMaskType(mask)
    }
    
    
    /// 显示HUD
    @discardableResult public func show() -> PQHUD{
        SVProgressHUD.show()
        return self
    }
    
    /// 显示一段文字，带转圈动画
    ///
    /// - Parameter status: 文字
    @discardableResult public func show(_ status : String?) -> PQHUD{
        SVProgressHUD.show(withStatus: status)
        return self
    }
    
    /// 设置文字,带感叹号
    ///
    /// - Parameter info: 文字
    @discardableResult public func showInfo(_ info : String?) -> PQHUD{
        SVProgressHUD.showInfo(withStatus: info)
        return self
    }
    
    /// 显示一张图片
    ///
    /// - Parameters:
    ///   - image: 图片
    ///   - status: 文字
    @discardableResult public func showImage(_ image :UIImage , status : String?) -> PQHUD{
        SVProgressHUD.show(image, status: status)
        return self
    }
    
    /// 显示错误信息，会显示一个x
    ///
    /// - Parameter status: 文字
    @discardableResult public func showError(_ status: String?) -> PQHUD{
        SVProgressHUD.showError(withStatus: status)
        return self
    }
    
    /// 显示进度
    ///
    /// - Parameter progress: 进度
    @discardableResult public func showProgress(_ progress : Float) -> PQHUD{
        SVProgressHUD.showProgress(progress)
        return self
    }
    
    @discardableResult public func showGIFImage(named imageNamed: String, status: String?) -> PQHUD{
        if let image = PQGIFImage.image(withGIFNamed: imageNamed) {
            SVProgressHUD.show(image, status: status)
        }else{
            print("gif image error")
        }
        return self
    }
    
    @discardableResult public func showGIFImage(data imageData: Data, status: String?) -> PQHUD{
        if let image = PQGIFImage.image(withGIFData: imageData) {
            SVProgressHUD.show(image, status: status)
        }else{
            print("gif image error")
        }
        return self
    }
    
    @discardableResult public func showGIFImage(url urlStr: String, status: String?) -> PQHUD{
        PQGIFImage.image(withGIFUrl: urlStr, and: { (image) in
            if let image = image {
                SVProgressHUD.show(image, status: status)
            }else{
                print("gif image error")
            }
            
        })
        return self
    }
    
    /// 显示成功信息，会显示一个✅
    ///
    /// - Parameter status: 文字
    @discardableResult public func showSuccess(_ status : String?) -> PQHUD{
        SVProgressHUD.showSuccess(withStatus: status)
        return self
    }
    
    /// 隐藏
    @discardableResult public func dismiss(_ timeInterval: TimeInterval = PQHUD.dismissTimeInterval) -> PQHUD{
        SVProgressHUD.dismiss(withDelay: timeInterval)
        return self
    }
    /// 隐藏
    @discardableResult public func dismissNow() -> PQHUD{
        SVProgressHUD.dismiss(withDelay: 0)
        return self
    }
    
    /// 隐藏之后如果需要处理，就调用这个方法
    ///
    /// - Parameter completion: 回调
    @discardableResult public func dismissWithCompletion(completion : @escaping
        SVProgressHUDDismissCompletion) -> PQHUD{
        SVProgressHUD.dismiss(completion: completion)
        return self
    }
    
    
    /// 设置消失时间，并且监听回调
    ///
    /// - Parameters:
    ///   - delay: 消失时间
    @discardableResult public func dismissWithDelay(_ delay : TimeInterval, completion : @escaping SVProgressHUDDismissCompletion) -> PQHUD{
        SVProgressHUD.dismiss(withDelay: delay, completion: completion)
        return self
    }
}

