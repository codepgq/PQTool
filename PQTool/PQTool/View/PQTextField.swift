//
//  PQTextField.swift
//  BaseAPP
//
//  Created by pgq on 2017/11/17.
//  Copyright © 2017年 pgq. All rights reserved.
//

import UIKit

public class PQTextField: UITextField {
    
    var maxCount: Int = -1
    override init(frame: CGRect){
        super.init(frame: frame)
        delegate = self
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        delegate = self
        self.setValue(self.placeholderColor, forKey: "placeholderColor")
        self.setValue(self.leftMargin, forKey: "leftMargin")
    }
    
    public override func setValue(_ value: Any?, forUndefinedKey key: String) {
        if key == "placeholderColor"{
            self.placeholderColor = value as? UIColor
        }
        
        if key == "leftMargin" {
            self.leftMargin = value as! CGFloat
        }
    }
    
    public func textfiledClickReturn(_ block : ((_ textfield : PQTextField)->Void)?){
        returnBlock = block
    }
    public func textfiledBeginEditing(_ block : ((_ textfield : PQTextField)->Void)?){
        beginBlock = block
    }
    public func textfiledEndEditing(_ block : ((_ textfield : PQTextField)->Void)?){
        endBlock = block
    }
    public func textfiledTextChange(_ block : ((_ textfield : PQTextField)->Void)?){
        addTarget(self, action: #selector(textValueChange(_:)), for: .editingChanged)
        changeBlock = block
    }
    
    @objc private func textValueChange(_ textfield : PQTextField) {
        if let block = changeBlock {
            block(textfield)
        }
    }
    
    // MARK: 属性
    public var placeholderColor: UIColor? = UIColor.black
    {
        didSet{
            self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? " ", attributes: [.foregroundColor:placeholderColor ?? .black])
        }
    }
    public var leftMargin : CGFloat = 10 {
        didSet{
            self.pq_leftView.frame.size.width = leftMargin
        }
    }
    
    private lazy var pq_leftView: UIView = {
         let view = UIView(frame: self.bounds)
        view.frame.size.width = self.leftMargin
        self.leftView = view
        self.leftViewMode = .always
        return view
    }()
    private lazy var returnBlock : ((_ textfield : PQTextField)->Void)? = nil
    private lazy var beginBlock : ((_ textfield : PQTextField)->Void)? = nil
    private lazy var endBlock : ((_ textfield : PQTextField)->Void)? = nil
    private lazy var changeBlock : ((_ textfield : PQTextField)->Void)? = nil
}

public extension PQTextField {
    convenience init(textColor : UIColor, placeholderColor: UIColor, palceholder: String?, leftMargin : CGFloat = 15) {
        self.init(frame: CGRect.zero)
        self.placeholder = placeholder
        self.placeholderColor = placeholderColor
        self.textColor = textColor
        self.leftMargin = leftMargin
    }
}

extension PQTextField : UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let block = returnBlock {
            block(textField as! PQTextField)
        }
        textField.resignFirstResponder()
        return true
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        if let block = beginBlock {
            block(textField as! PQTextField)
        }
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        if let block = endBlock {
            block(textField as! PQTextField)
        }
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        if maxCount == -1 {
            return true
        }
        
        if range.location < maxCount {
            return true
        }
        
        return false
        
    }
}
