//
//  BaseViewController.swift
//  newsreader
//
//  Created by 松田 拓也 on 2018/05/16.
//  Copyright © 2018年 松田 拓也. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // ハンバーガーメニューボタンタップ処理
    @IBAction func tapMenu(_ sender: UIBarButtonItem) {
//        self.performSegue(withIdentifier: "showMenu", sender: nil)
    }
    
}
