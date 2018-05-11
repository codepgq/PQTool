//
//  PQString.swift
//  BaseSingleLight
//
//  Created by pgq on 2018/3/26.
//  Copyright © 2018年 pgq. All rights reserved.
//

import UIKit

public protocol PQStringEncodable {
    associatedtype WrapperType
    var pq: WrapperType { get }
}

public extension PQStringEncodable where WrapperType == String {
    
    func localized() -> String{
        return NSLocalizedString(pq, comment: pq)
    }
    
    func controller() -> UIViewController? {
        /*
         动态创建类，需要用到namesapce，命名空间，也就是前缀
         */
        
        //获取namespace info.plist中获取
        guard let infoPath : String = Bundle.main.path(forResource: "Info.plist", ofType: nil) else { return nil }
        //得到
        guard let infoDict : NSDictionary = NSDictionary(contentsOfFile: infoPath) else { return nil }
        //获取命名空间
        guard let nameSpace = infoDict["CFBundleName"] as? String else { return nil }
        
        //动态创建类，一定要包括 "命名空间." 比如 "Project."
        guard let cls : AnyClass = NSClassFromString(String(nameSpace + "." + pq)) else { return nil }
        //类型指定
        guard let controller = cls as? UIViewController.Type else { return nil }
        
        return controller.init()
    }
    
    func hex() -> UInt64 {
        let scanner = Scanner(string: pq)
        var hex: UInt64 = 0
        scanner.scanHexInt64(&hex)
        return hex
    }
    
    /**
     将当前字符串拼接到cache目录后面
     */
    func cacheDir() -> String{
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!  as NSString
        return path.appendingPathComponent(pq as String)
    }
    /**
     将当前字符串拼接到document目录后面
     */
    func documentDir() -> String
    {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!  as NSString
        return path.appendingPathComponent((pq as NSString).lastPathComponent)
    }
    /**
     将当前字符串拼接到temp目录后面
     */
    func tempDir() -> String
    {
        let path = NSTemporaryDirectory() as NSString
        return path.appendingPathComponent((pq as NSString).lastPathComponent)
    }
    
    /// 获取当前版本号
    ///
    /// - Returns: 版本号
    func currentVersion() -> String?{
        let info: [String:Any] = Bundle.main.infoDictionary ?? [:]
        return info["CFBundleShortVersionString"] as? String
    }
    
    
    
    /// 正则
    ///
    /// - Parameters:
    ///   - partten: 条件
    ///   - regexOptions: 模式
    ///   - match: 模式
    /// - Returns: bool
    func regex(partten: String, regexOptions: NSRegularExpression.Options = .caseInsensitive, match: NSRegularExpression.MatchingOptions = .reportProgress) -> Bool{
        do {
            //2、创建正则表达式
            let regex = try NSRegularExpression(pattern: partten, options: NSRegularExpression.Options.caseInsensitive)
            
            //3、匹配
            let range = regex.rangeOfFirstMatch(in: pq, options: NSRegularExpression.MatchingOptions(rawValue : 0), range: NSRange(location: 0, length: pq.count))
            
            if range.location == 0 && range.length >= 1 {
                return true
            }
            
        } catch{
            print(error)
        }
        
        return false
    }
    
    func isEmail() -> Bool {
        do {
            //1、创建规则
            let pattern = "^[\\w\\.-]+@([\\w\\-]+\\.)+[A-Z]{2,4}$"
            
            //2、创建正则表达式
            let regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
            
            //3、匹配
            let range = regex.rangeOfFirstMatch(in: pq, options: NSRegularExpression.MatchingOptions(rawValue : 0), range: NSRange(location: 0, length: pq.count))
            
            if range.location == 0 && range.length >= 5 {
                return true
            }
            
        } catch{
            print(error)
        }
        
        return false
    }
    
    /// 查找字符串
    ///
    /// - Parameter string: 字符串
    /// - Returns: ranges
    func findString(_ string: String) -> [NSRange] {
        do{
            let partten = NSString.init(format: "\\b%@\\b", [pq]) as String
            let regex = try NSRegularExpression(pattern: partten, options: NSRegularExpression.Options.caseInsensitive)
            let results = regex.matches(in: pq, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSRange(location: 0, length: pq.count))
            return results.map({ (result) -> NSRange in
                return result.range
            })
        }catch{
            print("find error",error)
        }
        return []
    }
    
    func findStart(_ first: String, end: String) -> [NSRange]{
        do{
            let partten = "\\\(first)(.+?)\\\(end)"
            let regex = try NSRegularExpression(pattern: partten, options: NSRegularExpression.Options.caseInsensitive)
            let results = regex.matches(in: pq, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSRange(location: 0, length: pq.count))
            return results.map({ (result) -> NSRange in
                return result.range
            })
        }catch{
            print("find error",error)
        }
        return []
    }
    
    /// 查找子串是否在字符串内
    ///
    /// - Parameter string: 子字符串
    /// - Returns: bool
    func has(_ string: String) -> Bool{
        do{
            let partten = "^.*(?=\(string).*$"
            let regex = try NSRegularExpression(pattern: partten, options: NSRegularExpression.Options.caseInsensitive)
            let results = regex.matches(in: pq, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSRange(location: 0, length: pq.count))
            return results.count > 0
        }catch{
            print("find error",error)
        }
        return false
    }
}

public struct ExtensionPQStringEncodable<T>: PQStringEncodable {
    public let pq: T
    public init(pq: T){
        self.pq = pq
    }
}

extension String {
    public var pq: ExtensionPQStringEncodable<String> {
        return ExtensionPQStringEncodable(pq: self)
    }
}

