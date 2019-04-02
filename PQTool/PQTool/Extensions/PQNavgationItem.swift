//
//  PQNavgationItem.swift
//  BaseAPP
//
//  Created by pgq on 2018/2/5.
//  Copyright © 2018年 pgq. All rights reserved.
//

import UIKit

// 依赖PQButton
// MARK: 导航栏按钮协议
public enum PQAddBarItemDirection: Int {
    case left = 0
    case right = 1
}

private var popImageColor: UIColor = .white

public typealias NavigationItemBlock = (_ btn: PQButton?) -> ()
public protocol NavigationItemProtocol where Self: UIViewController {
    
    func pq_pop()
    
    func pq_pop(_ block:@escaping NavigationItemBlock)
    
    func pq_pop(_ imageNamed: String, size: CGSize, block:@escaping NavigationItemBlock)
    
    func pq_pop(_ image: UIImage?, size: CGSize, block:@escaping NavigationItemBlock)
    
    func pq_addBarItem(_ imageNamed: String, size: CGSize, derection: PQAddBarItemDirection, block: NavigationItemBlock?)
    
    func pq_title(_ title: String, color: UIColor)
    
    func pq_title(_ view: UIView)
}
// MARK: 默认实现
public extension NavigationItemProtocol {
    
    /// 设置反馈箭头的颜色 default white
    ///
    /// - Parameter color: color
    func pq_setPopImageFillColor(_ color: UIColor = .white) {
        popImageColor = color
    }
    
    func pq_pop(){
        let b : NavigationItemBlock = {[weak self] (btn) in
            self?.navigationController?.popViewController(animated: true)
        }
        pq_pop(b)
    }
    
    func pq_pop(_ block:@escaping NavigationItemBlock){
        pq_pop(backImageColor: popImageColor, block)
    }
    
    func pq_pop(_ size: CGSize = CGSize(width: 45, height: 25), backImageColor: UIColor = .white ,_ block:@escaping NavigationItemBlock){
        let image = drawBackImage(backImageColor, lineWidth: 2, size: size)
        pq_pop(image, size: .zero, block: block)
    }
    
    func pq_pop(_ imageNamed: String, size: CGSize, block:@escaping NavigationItemBlock){
        let image = UIImage(named: imageNamed)
        pq_pop(image, size: size, block: block)
    }
    
    func pq_pop(_ image: UIImage?, size: CGSize, block: @escaping NavigationItemBlock){
        let button = PQButton(frame: CGRect(origin: .zero, size: size))
        if size == CGSize.zero {
            button.sizeToFit()
        }
        button.setImage(image, for: .normal)
        button.buttonClick { (btn) in
            block(btn)
        }
        pq_addBarItem(button, derection: .left)
    }
    
    func pq_addBarItem(_ imageNamed: String, size: CGSize, derection: PQAddBarItemDirection, block: NavigationItemBlock?){
        let button = PQButton(frame: .zero)
        let image = UIImage(named: imageNamed)
        button.sizeToFit()
        button.setImage(image, for: .normal)
        button.buttonClick { (btn) in
            if let b = block {
                b(btn)
            }
        }
        
        pq_addBarItem(button, derection: derection)
    }
    
    func pq_addBarItem(title: String, derection: PQAddBarItemDirection, titleColor: UIColor = .white, block: NavigationItemBlock?){
        let size = (title as NSString).boundingRect(with: CGSize(width: 0, height: 30), options: [.usesLineFragmentOrigin,.usesDeviceMetrics], attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 17)], context: nil).size
        let button = PQButton(frame: CGRect(origin: .zero, size: CGSize(width: size.width + 15, height: 30)))
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        button.buttonClick { (btn) in
            if let b = block {
                b(btn)
            }
        }
        pq_addBarItem(button, derection: derection)
    }
    
    func pq_addBarItem(_ button: PQButton, derection: PQAddBarItemDirection){
        var items: [UIBarButtonItem] = []
        if derection == .left {
            if let leftItems = navigationItem.leftBarButtonItems {
                items.append(contentsOf: leftItems)
            }
            items.append(UIBarButtonItem(customView: button))
            navigationItem.leftBarButtonItems = items
        }else{
            if let rightItmes = navigationItem.rightBarButtonItems {
                items.append(contentsOf: rightItmes)
            }
            items.append(UIBarButtonItem(customView: button))
            navigationItem.rightBarButtonItems = items
        }
    }
    
    /// 画一个 < 图片，可以自定义颜色
    ///
    /// - Parameters:
    ///   - color: 颜色
    ///   - lineWidth: 线宽
    ///   - size: 大小
    /// - Returns: 图片
    private func drawBackImage(_ color: UIColor, lineWidth: CGFloat, size: CGSize) -> UIImage?{
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        let height = size.height
        let path = UIBezierPath()
        path.lineCapStyle = .round
        path.lineWidth = lineWidth
        path.move(to: CGPoint(x: 12, y: (height - 24) * 0.5))
        path.addLine(to: CGPoint(x: 2, y: height * 0.5))
        path.addLine(to: CGPoint(x: 12, y: (height - 25) * 0.5 + 24))
        color.setStroke()
        path.stroke()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image
    }
    
    
    func pq_title(_ title: String, color: UIColor){
        let label = UILabel(frame: .zero)
        label.text = title
        label.textColor = color
        label.sizeToFit()
        pq_title(label)
    }
    
    func pq_title(_ view: UIView){
        navigationItem.titleView = view
    }
    
}

public extension UINavigationController {
    
    func showLine(_ show: Bool = true){
        findBotomLineUnder(navigationBar)?.isHidden = !show
    }
    
    private func findBotomLineUnder(_ view: UIView) -> UIView? {
        if view.isKind(of: UIImageView.self), view.bounds.height <= 1.0 {
            return view
        }
        
        for i in 0..<view.subviews.count {
            let v = findBotomLineUnder(view.subviews[i])
            if v != nil {
                return v
            }
        }
        return nil
    }
    
}

