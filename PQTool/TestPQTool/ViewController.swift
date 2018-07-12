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
        
        newBtn()
        
        let btn = PQButton()
        btn.setImage(UIImage(named: "device_add_device"), for: .normal)
        btn.setTitle("ddd", for: .normal)
        //        btn.frame.size = CGSize(width: 200, height: 50)
        btn.sizeToFit()
        btn.spacing = 20
        btn.center = view.center
        view.addSubview(btn)
        
        
        let tf = PQTextField(textColor: UIColor.red, placeholderColor: .orange, palceholder: "dfdfd", leftMargin: 14)
        tf.frame = CGRect(x: 0, y: 300, width: 100, height: 40)
        tf.backgroundColor = .white
        view.addSubview(tf)
    }
    
    private func newBtn(){
        let btn = PQButton()
        btn.setTitle("ddd", for: .normal)
        btn.setImage(UIImage(named: "schedule_room"), for: .normal)
        btn.spacing = 8
        //        btn.frame.size = CGSize(width: 200, height: 50)
        btn.sizeToFit()
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
//        PQHUD.share.show()
        
//        PQHUD.share.show("dddd").dismiss()
//        PQHUD.share.showInfo("dddd").dismiss()
//        PQHUD.share.showError("")
//        PQHUD.share.showSuccess("ddd").dismiss()

        var x: Int?
        self?.wite
        
//        print("sddsf".pq.isAllChinese(),"是全中文")
//        print("地方".pq.isAllChinese(),"是全中文")
//        print("是否fd放到".pq.isAllChinese(false),"是全非中文")
//        print("ddd".pq.isAllChinese(false),"是全非中文")
//
//        print(Date().pq.nowUTC())
        
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

