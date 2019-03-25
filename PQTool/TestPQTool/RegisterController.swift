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
    
    var tempView: UIView?
    func findFirstResponder(_ findView: UIView) -> CGRect{
        var frame : CGRect = .zero
        for view in findView.subviews {
            if view.subviews.count > 0,
                view.subviews.contains(where: { $0 is UITextView || $0 is UITextField }){
                frame = findFirstResponder(view)
            }
            if view.isFirstResponder {
                tempView = view
                break
            }
        }
        guard let tempView = tempView else { return .zero }
        frame = view.convert(tempView.frame, to: self.view)
        return frame
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let frame = findFirstResponder(self.view)
        print("touch began", frame)
    }
}
