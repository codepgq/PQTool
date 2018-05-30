//
//  PQDate.swift
//  HappyFamily
//
//  Created by pgq on 2018/4/8.
//  Copyright © 2018年 pgq. All rights reserved.
//

import UIKit


public protocol PQDateEncodable {
    associatedtype WrapperType
    var pq: WrapperType { get }
}


public extension PQDateEncodable where WrapperType == Date {
    
    func format(_ format: String) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: Date())
    }
    
    func type(_ type: DateFormat) -> String {
        return format(type.rawValue)
    }
    
    func types(_ types: [DateFormat]) -> String{
        var str = ""
        types.forEach { (type) in
            str = str.appending(type.rawValue)
        }
        return format(str)
    }
    
    /// 获取当前时间 yyyy-MM-dd HH:mm:ss.sss
    func now() -> String{
        return format("yyyy-MM-dd HH:mm:ss.sss")
    }
    
    /// 获取当前时间 yyyy-MM-dd'T'HH:mm:ss.ssZ
    func nowUTC() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.ssZ"
        return formatter.string(from: Date())
    }
    
    /// 获取UTC的时间戳
    func utcTimeinterval() -> String {
        let date = Date()
        let time = date.timeIntervalSince1970 * 1000
        return "\(time)"
    }
    
    /// 获取GMT的时间戳
    func gmtTimeinterval() -> String {
        let date = Date()
        let zone = TimeZone.current
        let interval = zone.secondsFromGMT(for: date)
        let localDate = date.addingTimeInterval(Double(interval))
        let time = localDate.timeIntervalSince1970 * 1000
        return "\(time)"
    }
    
}

public struct ExtensionPQDateEncodable<T>: PQDateEncodable{
    //internal 默认的访问级别，可以不写
    public let pq: T
    public init(pq: T){
        self.pq = pq
    }
}

extension Date {
    public var pq: ExtensionPQDateEncodable<Date> {
        return ExtensionPQDateEncodable(pq: self)
    }
}
