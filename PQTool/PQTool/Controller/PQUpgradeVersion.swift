//
//  PQUpgradeVersion.swift
//  UpgradeAppUI
//
//  Created by 盘国权 on 2018/7/9.
//  Copyright © 2018年 pgq. All rights reserved.
//

import UIKit

open class PQUpgradeVersion: NSObject {
    ///  #appId
    open static var myAppId: String?
    
    /// title, message, cancel, ignore, upgrade
    public typealias NewVersion = (title: String?, message: String?, cancel: String?, ignore: String?, upgrade: String?)
    
    /// title, message, iknow
    public typealias LatestVersion = (title: String?, message: String?, iknow: String?)
    
    
    /// check app version
    ///
    /// - Parameters:
    ///   - appId: appId
    ///   - newVersion: new version
    ///   - latestVersion: latest version
    ///   - completion: callback alertController
    /// - Throws: catch some error
    public class func checkVersion(for appId: String? = myAppId, newVersion: (() -> (NewVersion))?, latestVersion: (() -> (LatestVersion))?, completion: @escaping (UIAlertController) -> ()) throws{
        guard let appId = appId, appId.count > 0 else  { print("PQUpgradeVersion: App id invalid"); return }
        myAppId = appId
        
        
        guard let url = URL(string: "http://itunes.apple.com/lookup?id=" + appId) else {
            throw (NSError(domain: "URL invalid", code: 0, userInfo: nil))
        }
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if let error = error {
                print("PQUpgradeVersion: ",error)
                return
            }
            
            if let data = data,
                let appMsg = String(data: data, encoding: .utf8),
                let appMsgDict = PQUpgradeVersion.getDictFromString(appMsg),
                let appResultsArray = (appMsgDict["results"] as? NSArray),
                let appResultsDict = appResultsArray.lastObject as? NSDictionary,
                let appStoreVersion = appResultsDict["version"] as? String,
                let dict = Bundle.main.infoDictionary,
                let version = dict["CFBundleShortVersionString"] as? String{
                
                var isShowAlert = appStoreVersion.compare(version) == .orderedDescending
                
                if let localVersion = UserDefaults.standard.value(forKey: "PQLocalVersion") as? String{
                    isShowAlert = appStoreVersion.compare(localVersion) == .orderedDescending
                }
                
                if isShowAlert {
                    guard let tuple = newVersion?() else { return }
                    let alertController = UIAlertController(title: tuple.title, message: tuple.message, preferredStyle: .alert)
                    
                    if let cancel = tuple.cancel, !cancel.isEmpty {
                        alertController.addAction(PQAlertAction(title: cancel, textColor: .darkGray, handler: nil))
                    }
                    
                    if let ignore = tuple.ignore, !ignore.isEmpty {
                        alertController.addAction(PQAlertAction(title: ignore, handler: { (action) in
                            UserDefaults.standard.setValue(appStoreVersion, forKey: "PQLocalVersion")
                        }))
                    }
                    
                    if let upgrade = tuple.upgrade, !upgrade.isEmpty {
                        alertController.addAction(PQAlertAction(title: upgrade, handler: { (action) in
                            try? self.jumpToAppStore()
                        }))
                    }
                    completion(alertController)
                    
                } else {
                    
                    guard let tuple = latestVersion?() else { return }
                    let alertController = UIAlertController(title: tuple.title, message: tuple.message, preferredStyle: .alert)
                    
                    if let iknow = tuple.iknow, !iknow.isEmpty {
                        alertController.addAction(PQAlertAction(title: iknow, textColor: .darkGray, handler: { (action) in
                            
                        }))
                    }
                    
                    completion(alertController)
                }
            }
        }).resume()
    }
    
    
    
    class func jumpToAppStore() throws {
        
        guard let appId = PQUpgradeVersion.myAppId, !appId.isEmpty else {
            throw (NSError(domain: "Please check your appId", code: 0, userInfo: nil) as Error)
        }
        
        guard let url = URL(string: "http://itunes.apple.com/app/id" + appId)  else {
            throw (NSError(domain: "URL invalid", code: 0, userInfo: nil) as Error)
        }
        
        if UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        } else {
            throw (NSError(domain: "Can not open this url", code: 0, userInfo: nil) as Error)
        }
        
    }
    
    private class func getDictFromString(_ jsonString: String) -> [String: Any]? {
        
        if let jsonData = jsonString.data(using: .utf8) {
            
            if let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) {
                
                return dict as? [String: Any]
            }
            return nil
        }
        return nil
    }
    
    
    
    
}


public class PQAlertAction: UIAlertAction {
    
    public convenience init(title: String, textColor: UIColor? = nil, handler: ((UIAlertAction) -> Void)?){
        self.init(title: title, style: .default, handler: handler)
        if textColor != nil {
            self.setValue(textColor, forKey: "textColor")
        }
    }
    
    public var textColor: UIColor? {
        didSet{
            var count: UInt32 = 0
            if let ivars = class_copyIvarList(UIAlertAction.self, &count) {
                var i = 0
                while i != count {
                    //取出属性名
                    let ivar = ivars[Int(i)]
                    if let ivarName = ivar_getName(ivar) {
                        let nName = String(cString: ivarName)
                        if nName == "_titleTextColor" {
                            self.setValue(textColor, forKey: "titleTextColor")
                        }
                    }
                    i += 1
                }
            }
            
        }
    }
    
    override public func setValue(_ value: Any?, forKey key: String) {
        if key == "textColor" {
            self.textColor = value as? UIColor
        } else {
            super.setValue(value, forKey: key)
        }
    }
    
}













