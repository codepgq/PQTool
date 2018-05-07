//
//  PQAlertController.swift
//  HappyFamily
//
//  Created by pgq on 2018/4/9.
//  Copyright © 2018年 pgq. All rights reserved.
//

import UIKit

public class PQAlertController: UIAlertController {
    
    public typealias PQActionBlock = ((_ action: UIAlertAction,_ alert: PQAlertController) -> Void)
    public typealias PQTextFieldBlock = ((_ action: UITextField,_ alert: PQAlertController) -> Void)
    @discardableResult public func addButton(_ title: String?, style: UIAlertActionStyle = .default, handler: PQActionBlock?) -> PQAlertController{
        let action = UIAlertAction(title: title, style: style) { (action) in
            if let block = handler{
                block(action,self)
            }
        }
        self.addAction(action)
        return self
    }
    
    @discardableResult public func addTextInput(_ placeHolder: String? = nil, textStr: String? = nil, secure: Bool = false, handler: PQTextFieldBlock? = nil) -> PQAlertController{
        if preferredStyle == .actionSheet { return self }
        
        self.addTextField { (text) in
            text.placeholder = placeHolder
            text.text = textStr
            text.isSecureTextEntry = secure
            text.addTarget(self, action: #selector(self.listenTextFieldValueChanged(_:)), for: .valueChanged)
            //保存block
            if let block = handler {
                text.tag = self.nextTag()
                let key = self.getTextFieldKey(text.tag)
                self.textFieldsBlock[key] = block
            }
        }
        
        return self
    }
    
    private func getTextFieldKey(_ tag: Int) -> String{
        return "PQAlertTextField-\(tag)"
    }
    
    private func nextTag() -> Int{
        tag += 1
        return tag
    }
    
    private var textFieldsBlock: [String : PQTextFieldBlock] = [:]
    private var tag: Int = 1
    
}

extension PQAlertController{
    @objc private func listenTextFieldValueChanged(_ textfield: UITextField){
        let key = getTextFieldKey(textfield.tag)
        if let block: PQTextFieldBlock = textFieldsBlock[key] {
            block(textfield,self)
        }
    }
}

public extension UIAlertController{
    public convenience init(_ title: String?, message: String?, preferredStyle: UIAlertControllerStyle = .alert){
        self.init(title: title, message: message, preferredStyle: preferredStyle)
        
        if preferredStyle == .actionSheet, let popPresenter = popoverPresentationController {
            popPresenter.sourceView = UIApplication.shared.keyWindow?.rootViewController?.view
            let bounds = UIScreen.main.bounds
            popPresenter.sourceRect = CGRect(x: bounds.width * 0.5, y: bounds.height, width: 1.0, height: 1.0)
        }
    }
}
