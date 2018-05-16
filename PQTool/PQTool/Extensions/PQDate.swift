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
    func now() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-mm-dd hh-MM-ss.sss"
        return formatter.string(from: Date())
    }
    
    func newUTC() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-mm-ddThh-MM-ss.ssZ"
        return formatter.string(from: Date())
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
