//
//  PQData.swift
//  BaseSingleLight
//
//  Created by pgq on 2018/3/26.
//  Copyright © 2018年 pgq. All rights reserved.
//

import UIKit

public protocol PQDataEncodable {
    associatedtype WrapperType
    var pq: WrapperType { get }
}

public extension PQDataEncodable where WrapperType == Data {
    
    /// 把data转为Uint8数组
    ///
    /// - Returns: 数组
    func toUInt8() -> [UInt8]{
        var byteArray = [UInt8](repeating: 0, count: pq.count)
        pq.copyBytes(to: &byteArray, count: pq.count)
        return byteArray
    }
    
    /// 把Data转为字符串
    ///
    /// - Returns: 字符串
    func toHex() -> String {
        var hex: String = ""
        for i in 0..<toUInt8().count {
            hex.append(NSString(format: "%02x", pq[i]) as String)
            if (i + 1) % 4 == 0 { hex.append(" ") }
        }
        return hex
    }
    
    /// 提取
    ///
    /// - Parameters:
    ///   - loc: 开始位置
    ///   - len: 结束位置
    /// - Returns: data
    func sub(_ loc: Int, _ len: Int) -> Data?{
        guard (loc + len < pq.count + 1) else { return nil }
        guard let range = Range(NSRange(location: loc, length: len)) else { return nil }
        return sub(range)
    }

    
    /// 提取
    ///
    /// - Parameter range: 范围
    /// - Returns: data
    func sub(_ range: Range<Int>) -> Data?{
        guard range.upperBound < pq.count + 1 else { return nil }
        return pq.subdata(in: range)
    }
}

public struct ExtensionPQDataEncodable<T>: PQDataEncodable{
    //internal 默认的访问级别，可以不写
    public let pq: T
    public init(pq: T){
        self.pq = pq
    }
}

extension Data {
    public var pq: ExtensionPQDataEncodable<Data> {
        return ExtensionPQDataEncodable(pq: self)
    }
}
