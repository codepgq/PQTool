//
//  PQColor.swift
//  BaseSingleLight
//
//  Created by pgq on 2018/3/26.
//  Copyright © 2018年 pgq. All rights reserved.
//

import UIKit
/*
 如果优雅的给一个类进行扩展 2 3 顺序可换
 1、新建一个自己的协议
 2、新建一个自己的结构体或者新建一个自己的类 final class ，并且继承于自己的协议
 3、为自己的协议实现方法
 4、为你想要扩展的类新增一个成员变量，使用自己的结构体进行初始化
 */

public protocol PQColorEncodable {
    associatedtype WrapperType
    var pq: WrapperType { get }
}

public extension PQColorEncodable where WrapperType == UIColor {
    func red() -> Float {
        var red: CGFloat = 0
        pq.getRed(&red, green: nil, blue: nil, alpha: nil)
        return Float(red)
    }
    func green() -> Float {
        var green: CGFloat = 0
        pq.getRed(nil, green: &green, blue: nil, alpha: nil)
        return Float(green)
    }
    func blue() -> Float {
        var blue: CGFloat = 0
        pq.getRed(nil, green: nil, blue: &blue, alpha: nil)
        return Float(blue)
    }
    func alpha() -> Float {
        var alpha: CGFloat = 0
        pq.getRed(nil, green: nil, blue: nil, alpha: &alpha)
        return Float(alpha)
    }
    func hue() -> Float {
        var hue: CGFloat = 0
        pq.getHue(&hue, saturation: nil, brightness: nil, alpha: nil)
        return Float(hue)
    }
    func saturation() -> Float {
        var saturation: CGFloat = 0
        pq.getHue(nil, saturation: &saturation, brightness: nil, alpha: nil)
        return Float(saturation)
    }
    func brightness() -> Float {
        var brightness: CGFloat = 0
        pq.getHue(nil, saturation: nil, brightness: &brightness, alpha: nil)
        return Float(brightness)
    }
    
    func redUInt8() -> UInt8 {
        return UInt8(red() * 255)
    }
    func greenUInt8() -> UInt8 {
        return UInt8(green() * 255)
    }
    func blueUInt8() -> UInt8 {
        return UInt8(blue() * 255)
    }
    func alphaUInt8() -> UInt8 {
        return UInt8(alpha() * 255)
    }
    func hueUInt8() -> UInt8 {
        return UInt8(hue() * 255)
    }
    func saturationUInt8() -> UInt8 {
        return UInt8(saturation() * 255)
    }
    func brightnessUInt8() -> UInt8 {
        return UInt8(brightnessUInt8() * 255)
    }
    
    func rgbUInt8() -> [UInt8] {
        return [redUInt8(),greenUInt8(),blueUInt8()]
    }
    
    func hsbUInt8() -> [UInt8] {
        return [hueUInt8(),saturationUInt8(),brightnessUInt8()]
    }
    
    
    /// 获取颜色的HSB值
    ///
    /// - Returns: 元祖
    func hsb() -> (h: CGFloat, s: CGFloat, b: CGFloat, a: CGFloat){
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        if pq.responds(to: #selector(pq.getHue(_:saturation:brightness:alpha:))) {
            pq.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        }
        return (h,s,b,a)
        
    }
    
    /// 随机颜色HSB
    ///
    /// - Returns: 颜色
    func randomHSBColor() -> UIColor {
        return UIColor(hue: CGFloat(arc4random() % 100) / 100.0, saturation: 1, brightness: CGFloat(arc4random() % 100) / 100.0, alpha: 1)
    }
    
    /// 随机颜色RGB
    ///
    /// - Returns: 颜色
    func RandomRGBColor() -> UIColor{
        return UIColor(red: CGFloat(arc4random() % 255) / 255.0, green: CGFloat(arc4random() % 255) / 255.0, blue: CGFloat(arc4random() % 255) / 255.0, alpha: CGFloat(arc4random() % 255) / 255.0)
    }
    
    /// r g b [0 - 255] a [0 - 100]
    func rgba(r: UInt8, g: UInt8, b: UInt8, a: UInt8) -> UIColor{
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(a) / 100.0)
    }
    
    /// h s b a [0.0 - 1.0]
    func hsba(h: Double, s: Double, b: Double, a: Double) -> UIColor {
        return UIColor(hue: CGFloat(h), saturation: CGFloat(s), brightness: CGFloat(b), alpha: CGFloat(a))
    }
    
    
    /// 16进制转化颜色
    ///
    /// - Parameters:
    ///   - value: 数据
    ///   - alpha: 透明度
    /// - Returns: color
    func hexColor(_ value : Int64, alpha : CGFloat = 1) -> UIColor {
        return UIColor(red: CGFloat((((value & 0xFF0000) >> 16))) / 255.0, green: CGFloat((((value & 0xFF00) >> 8))) / 255.0, blue: CGFloat(((value & 0xFF))) / 255.0, alpha: alpha)
    }
}

public struct ExtensionPQColorEncodable<T>: PQColorEncodable{
    //internal 默认的访问级别，可以不写
    public let pq: T
    public init(pq: T){
        self.pq = pq
    }
}

public extension UIColor {
    public var pq: ExtensionPQColorEncodable<UIColor> {
        return ExtensionPQColorEncodable(pq: self)
    }
}
