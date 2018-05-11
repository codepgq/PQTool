//
//  Extensions.swift
//  BaseAPP
//
//  Created by pgq on 2017/11/20.
//  Copyright © 2017年 pgq. All rights reserved.
//

import UIKit

// MARK: CG系列



// MARK: UIView
public extension  UIView {
    var width: CGFloat {
        get{ return frame.width }
        set{ self.frame.size.width = width }
    }
    
    var height: CGFloat{
        get{ return frame.height }
        set{ self.frame.size.height = height }
    }
    
    var x: CGFloat {
        get{ return frame.origin.x }
        set{ self.frame.origin.x = x }
    }
    
    var y: CGFloat {
        get{ return frame.origin.y }
        set{ self.frame.origin.x = y }
    }
}

public extension UITableView{
    convenience init(delegate: UITableViewDelegate, dataSource: UITableViewDataSource, rowHeight: CGFloat = 44){
        self.init(frame: CGRect.zero)
        self.delegate = delegate
        self.dataSource = dataSource
        self.rowHeight = rowHeight
    }
}

// MARK: UICollectionView
public extension UICollectionView{
    convenience init(item size: CGSize, derection: UICollectionViewScrollDirection = .vertical, minLineSpacing: CGFloat, minInterItemSpacing: CGFloat, delegate: UICollectionViewDelegate?, dataSource: UICollectionViewDataSource?){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = derection
        layout.minimumLineSpacing = minLineSpacing
        layout.minimumInteritemSpacing = minInterItemSpacing
        layout.itemSize = size
        self.init(frame: .zero, collectionViewLayout: layout)
        self.delegate = delegate
        self.dataSource = dataSource
    }
}

// MARK: UILabel
public extension  UILabel {
    
    convenience init(textColor: UIColor, size: CGFloat) {
        self.init()
        self.textColor = textColor
        self.font = UIFont.systemFont(ofSize: size)
    }
    
    convenience init(textColor: UIColor, size: CGFloat, text: String?) {
        self.init(textColor: textColor, size: size)
        self.text = text
    }
    
    convenience init(textColor: UIColor, size: CGFloat, textAlignment: NSTextAlignment) {
        self.init(textColor: textColor, size: size)
        self.textAlignment = textAlignment
    }
    
    convenience init(textColor: UIColor, size: CGFloat, textAlignment: NSTextAlignment, text: String?) {
        self.init(textColor: textColor, size: size, textAlignment: textAlignment)
        self.text = text
    }
}


// MARK: UISlider
public extension UISlider{
    convenience init(_ targer: Any?, selector: Selector){
        self.init(frame: .zero)
        addTarget(targer, action: selector, for: .valueChanged)
    }
}

// MARK: UIStackView
public extension UIStackView{
    convenience init(_ axis: UILayoutConstraintAxis, alignment: UIStackViewAlignment, distribution: UIStackViewDistribution){
        self.init(frame: .zero)
        self.axis = axis
        self.alignment = alignment
        self.distribution = distribution
    }
}


// MARK: UIViewController
public extension UIViewController {
    
    class func loadSB(storyboard: String, identifier: String?) -> UIViewController?{
        if identifier == nil {
            return UIStoryboard(name: storyboard, bundle: nil).instantiateInitialViewController()
        }
        return UIStoryboard(name: storyboard, bundle: nil).instantiateViewController(withIdentifier: identifier!)
    }
    
    class func loadXIB() -> UIViewController?{
        return UIViewController(nibName: NSStringFromClass(self), bundle: nil)
    }
    
    func navTintColor(_ tintColor: UIColor = .white, barTintColor: UIColor = .white, textColor: UIColor = .white){
        self.navigationController?.navigationBar.tintColor = tintColor
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedStringKey.foregroundColor: textColor]
    }
    
    func keyboardLayout(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardFrameWiiChange(_:)), name: .UIKeyboardWillChangeFrame, object: nil)
    }
    
    @objc private func keyboardFrameWiiChange(_ noti : Notification){
        
        let keyboardFrame : CGRect = ((noti.userInfo![UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue)!
        
        if (keyboardFrame.origin.y - UIScreen.main.bounds.size.height) == 0 {
            //回收
            UIView.animate(withDuration: 0.25, animations: {[weak self] in
                self?.view.transform = .identity
            })
        }else{
            //展示
            let frame : CGRect = findFirstResponder(view)
            //得到最大的y轴坐标
            let bottom = frame.origin.y + frame.size.height + 30
            
            if bottom > keyboardFrame.origin.y {//表示会被挡住
                UIView.animate(withDuration: 0.25, animations: {[weak self] in
                    self?.view.transform = CGAffineTransform(translationX: 0, y:  keyboardFrame.origin.y - bottom)
                })
            }
            
        }
    }
    
    private func findFirstResponder(_ findView: UIView) -> CGRect{
        var frame : CGRect = .zero
        for view in findView.subviews {
            if view.subviews.count > 0 {
                frame = findFirstResponder(view)
            }
            if view.isFirstResponder {
                if let superV = view.superview {
                    //如果是view的一级子类，就不用转化坐标了
                    if superV.isEqual(self.view) {
                        return view.frame
                    }
                }
                
                frame = view.convert(view.frame, to: self.view)
                return frame
            }
        }
        return frame
    }
}


