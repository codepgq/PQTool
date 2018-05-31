//
//  PQPublicFunction.swift
//  BaseAPP
//
//  Created by pgq on 2017/11/20.
//  Copyright © 2017年 pgq. All rights reserved.
//

import UIKit

//public extension NSObject{
    public var pqScreenW: CGFloat {
       return UIScreen.main.bounds.width
    }
    public var pqScreenH: CGFloat {
       return UIScreen.main.bounds.height
    }
    
    public func pq_iPhoneXBottom() -> CGFloat{
        if let window = UIApplication.shared.keyWindow {
            if window.frame.size == CGSize(width: 375, height: 812){
                return -20
            }
        }
        return -0
    }
    
    public func pq_isIpad() -> Bool {
        return (UI_USER_INTERFACE_IDIOM() == .pad)
    }
    
    public func pq_isiPhone() -> Bool {
        return (UI_USER_INTERFACE_IDIOM() == .phone)
    }
    
    public func pq_isiPhoneX() -> Bool {
        let bounds = UIScreen.main.bounds
        return (bounds.width == 375) && (bounds.height == 812)
    }
    
    @discardableResult public func dPrintData(_ item: Data?) -> Bool{
        if let data = item {
            var dataStr = "data is <0-3> "
            var i :Int = 0
            for c in data{
                dataStr.append(String(format: "%02x", c) )
                i += 1
                if i%4 == 0 {
                    dataStr.append(" <\(i)-\(i+3)> ")
                }
                
            }
            dPrint(dataStr)
            return true
        }
        
        dPrint("空的Data")
        return false
    }
    
    public func dPrint(_ items: Any...,  function:String = #function,file : String = #file, lineNumber : Int = #line){
        #if DEBUG
        //获取文件名
        let fileName = (file as NSString).lastPathComponent
        let interval = TimeZone.current.secondsFromGMT(for: Date())
        let date = Date().addingTimeInterval(TimeInterval(interval))
        //打印日志内容
        //        print("[日志] \(date) \(fileName):\(lineNumber) > \(function) info：\(items)")
        print("[日志] \(date) \(fileName):\(lineNumber) > \(function) ",items)
        #endif
    }
    
    public func pqLog<T>(message : T, file : String = #file, lineNumber : Int = #line) {
        
        #if DEBUG
        
        let fileName = (file as NSString).lastPathComponent
        print("[\(fileName):line:\(lineNumber)]- \(message)")
        
        #endif
    }
    
    // 锁
    public func synchronized(lock: AnyObject, closure:()->()) {
        objc_sync_enter(lock)
        closure()
        objc_sync_exit(lock)
    }
    
    //关闭定时器
    public func closeTimer(_ timer:inout Timer?){
        timer?.invalidate()
        timer?.fireDate = Date.distantFuture
        timer = nil
    }
    
    // 创建定时器
    public func openTimer(timeInterval: TimeInterval, target: Any, selector: Selector, repeats: Bool) -> Timer {
        let timer = Timer.scheduledTimer(timeInterval: timeInterval, target: target, selector: selector, userInfo: nil, repeats: repeats)
        RunLoop.current.add(timer, forMode: .commonModes)
        return timer
    }
    
    
    
    
    // MARK: block
    public typealias callbackFloat = (_ value: Float) -> ()
//}


