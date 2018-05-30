//
//  DetailViewController.swift
//  newsreader
//
//  Created by 松田 拓也 on 2018/04/16.
//  Copyright © 2018年 松田 拓也. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController : UIViewController, WKNavigationDelegate, UITabBarDelegate{
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var loadAnimetion: UIActivityIndicatorView!
    @IBOutlet weak var moveWeb: UITabBar!
    var link:String!
    override func viewDidLoad() {
        self.webView.navigationDelegate = self
        self.moveWeb.delegate = self
        super.viewDidLoad()
        if let url = URL(string: self.link){
            let request = URLRequest(url: url)
            self.webView.load(request)
        }
    }
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        loadAnimetion.startAnimating()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadAnimetion.stopAnimating()
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 1 {
//            let url = webView.backForwardList.forwardItem?.url
//            let bfourl = URLRequest(url: url!)
//            self.webView.load(bfourl)
            print("タブぶぶぶb")
        }
        else if item.tag == 2 {
            print("多々タタタタt部")
        }
    }
    
    
    
}
