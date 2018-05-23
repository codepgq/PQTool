//
//  ViewController.swift
//  TestPQTool
//
//  Created by pgq on 2018/5/7.
//  Copyright © 2018年 pgq. All rights reserved.
//

import UIKit
import PQTool

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("dd".pq.tempDir())
        PQHUD.defaultSetHUD(nil)
        
        let btn = PQButton(.bottomText)
        btn.setImage(#imageLiteral(resourceName: "device_add_device"), for: .normal)
        btn.frame.size = CGSize(width: 95, height: 95)
        btn.setTitle("ddd", for: .normal)
        btn.frame.origin = CGPoint(x: 100, y: 100)
        view.addSubview(btn)
    }
    
    @IBOutlet weak var textTF: PQTextField!{
        didSet{
            textTF.textfiledTextChange { (tf) in
                print(tf.text)
            }
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        PQHUD.share.showError("error").dismiss(2)
//        PQHUD.share.show
        
//        PQHUD.share.show("dddd").dismiss()
//        PQHUD.share.showInfo("dddd").dismiss()
//        PQHUD.share.showError("dddd").dismiss()
//        PQHUD.share.showSuccess("ddd").dismiss()
        
        print(Date().pq.nowUTC())
        
//        if let vc = TestXIBController.loadXIB(){
//            present(vc, animated: true, completion: nil)
//        }
//        return
        
//        let alert = PQAlertController("dd", message: "dd")
//        alert.addTextInput("...", textStr: "input", secure: false) { (tf, alert) in
//                print(tf.text)
//            }.addButton("quxiao") { (action, alert) in
//
//            }
//        present(alert, animated: true, completion: nil)
        
    }
}

