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
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        PQHUD.share.show("啊哈哈哈").dismiss(3)
    }
}

