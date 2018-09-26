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

public enum RegexType: String {
    case onceOrMore = ".+?"
    case zeroOrMore = ".*?"
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
    
    /// Bundle.main.infoDictionary
    var infoDictionary: [String:Any] {
        return Bundle.main.infoDictionary ?? [:]
    }
    
    var appVersion: String? {
        return infoDictionary["CFBundleShortVersionString"] as? String
    }
    
    var appBuildVersion: String? {
        return infoDictionary["CFBundleVersion"] as? String
    }
    
    var appName: String? {
        return infoDictionary["CFBundleName"] as? String
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
    
    /// 判断是否输入的是全中文或者不包含中文
    ///
    /// - Parameter all: 是否
    /// - Returns: bool
    func isAllChinese(_ all: Bool = true) -> Bool {
        let partten = all ? "^[\\u4e00-\\u9fa5]{0,}$" : "^[^\\u4e00-\\u9fa5]{0,}$"
        return regex(partten: partten)
    }
    
    func isEmail() -> Bool {
        return regex(partten: "^[\\w\\.-]+@([\\w\\-]+\\.)+[A-Z]{2,4}$")
    }
    
    func isPhoneNumber() -> Bool {
        return regex(partten: "^[1][3,4,5,7,8][0-9]{9}$")
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
    
    
    
    func sub(start: Character, end: Character) -> String? {
        guard var sIdx = pq.index(of: start),
              let eIdx = pq.index(of: end),
              sIdx < eIdx  else {
                return nil
        }
        sIdx = pq.index(sIdx, offsetBy: 1)
        return String(pq[sIdx..<eIdx])
    }
    
    subscript(_ range: Range<Int>) -> String {
        let newStartIndex = pq.index(pq.startIndex, offsetBy: range.lowerBound)
        let newEndIndex   = pq.index(pq.startIndex, offsetBy: range.upperBound)
        return String(pq[newStartIndex..<newEndIndex])
    }
    
    subscript(_ range: NSRange) -> String? {
        guard let dd = Range(range) else { return nil }
        let newStartIndex = pq.index(pq.startIndex, offsetBy: dd.lowerBound)
        let newEndIndex   = pq.index(pq.startIndex, offsetBy: dd.upperBound)
        return String(pq[newStartIndex..<newEndIndex])
    }
    
    func findStrStart(_ first: String, end: String) -> [String] {
        return findStart(first, end: end).compactMap { range -> String?in
            return self[range]
        }
    }
    
    func findStart(_ first: String, end: String) -> [NSRange]{
        do{
            let partten = "\(first)(.+?)\(end)"
            let regex = try NSRegularExpression(pattern: partten, options: NSRegularExpression.Options.caseInsensitive)
            let results = regex.matches(in: pq, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSRange(location: 0, length: pq.count))
            return results.map({
                let range = $0.range
                let loction = range.location + first.count - 1
                let length = range.length - first.count - end.count + 2
                return NSRange(location: loction, length: length) })
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
    
    //将十六进制字符串转化为 Data
    func data() -> Data {
        let bytes = self.bytes()
        return Data(bytes: bytes)
    }
    
    // 将16进制字符串转化为 [UInt8]
    // 使用的时候直接初始化出 Data
    // Data(bytes: Array<UInt8>)
    func bytes() -> [UInt8] {
        var hexStr = ""
        pq.components(separatedBy: " ").forEach({ hexStr.append($0) })
        
        assert(hexStr.count % 2 == 0, "输入字符串格式不对，8位代表一个字符")
        var bytes = [UInt8]()
        var sum = 0
        // 整形的 utf8 编码范围
        let intRange = 48...57
        // 小写 a~f 的 utf8 的编码范围
        let lowercaseRange = 97...102
        // 大写 A~F 的 utf8 的编码范围
        let uppercasedRange = 65...70
        for (index, c) in hexStr.utf8CString.enumerated() {
            var intC = Int(c.byteSwapped)
            if intC == 0 {
                break
            } else if intRange.contains(intC) {
                intC -= 48
            } else if lowercaseRange.contains(intC) {
                intC -= 87
            } else if uppercasedRange.contains(intC) {
                intC -= 55
            } else {
                assertionFailure("输入字符串格式不对，每个字符都需要在0~9，a~f，A~F内")
            }
            sum = sum * 16 + intC
            // 每两个十六进制字母代表8位，即一个字节
            if index % 2 != 0 {
                bytes.append(UInt8(sum))
                sum = 0
            }
        }
        return bytes
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

