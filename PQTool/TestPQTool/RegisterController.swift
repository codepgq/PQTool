//
//  RegisterController.swift
//  TestPQTool
//
//  Created by 盘国权 on 2018/9/27.
//  Copyright © 2018年 pgq. All rights reserved.
//

import UIKit
import PQTool

class RegisterController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        keyboardLayout()
    }
    
    func findFirstResponder(_ findView: UIView) -> CGRect{
        // view btn tf view
        var frame : CGRect = .zero
        for view in findView.subviews {
            if view.subviews.count > 0,
                view.subviews.contains(where: { $0 is UITextView || $0 is UITextField }){
                print("digui")
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
                print(frame)
                return frame
            }
        }
        return frame
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let frame = findFirstResponder(self.view)
        print("touch began", frame)
    }
}
