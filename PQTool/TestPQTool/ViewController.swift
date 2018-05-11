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
    }
    
    @IBOutlet weak var textTF: PQTextField!{
        didSet{
            textTF.textfiledTextChange { (tf) in
                print(tf.text)
            }
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        PQHUD.share.showError("error").dismiss(2)
    }
}

