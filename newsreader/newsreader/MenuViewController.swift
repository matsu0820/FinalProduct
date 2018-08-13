//
//  MenuViewController.swift
//  newsreader
//
//  Created by 松田 拓也 on 2018/05/16.
//  Copyright © 2018年 松田 拓也. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import LocalAuthentication

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var testTableView: UITableView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var search: UISearchBar!
    var tag:Int = 0
    var tagSection:Int = 0
    
    
    
    static let categoryArray =
        ["国内", "国際", "経済", "エンタメ", "スポーツ", "IT・科学", "地域"]
    static let favarite = ["お気に入り"]
    static let top = ["新しい"]
    
    
    var category = ["","","ジャンル"]
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        testTableView.delegate = self
        testTableView.dataSource = self
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
    }
    
    // メニュー外をタップした場合に非表示にする
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesEnded(touches, with: event)
        for touch in touches {
            if touch.view?.tag == 1 {
//                UIView.animate(withDuration: 0.2,delay: 0,options: .curveEaseIn,animations: {
//                    self.menuView.layer.position.x = -self.menuView.frame.width
//                },
//                               completion: { bool in
                                self.navigationController?.popViewController(animated: true)
   //            })
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return category.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return category[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        switch section {
        case 0:
            return MenuViewController.top.count
        case 1:
            return MenuViewController.favarite.count
        case 2:
            return MenuViewController.categoryArray.count
        default:
            return 0
        }
    }
    
    //カテゴリーテーブル内容作成
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell") as! CategoryCell
        
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = MenuViewController.top[indexPath.row]
        case 1:
            cell.textLabel?.text = MenuViewController.favarite[indexPath.row]
        case 2:
            cell.textLabel?.text = MenuViewController.categoryArray[indexPath.row]
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tag = indexPath.row
        tagSection = indexPath.section
            switch indexPath.section {
            case 1:
//                let context = LAContext()
//                var error :NSError?
//                let description = "認証する理由を入力"
//
//                if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
//
//                    //TocuhIDに対応している場合
//                    context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: description, reply: {
//                        success, evaluateError  in
//
//                        if success {
//                            print("認証成功")
//                            DispatchQueue.main.async {
                                self.performSegue(withIdentifier: "favoList" , sender: self)
//                            }
//
//                        } else {
//                            print("失敗")
//                            return
//                        }
//                    })
//
//                }else{
//                    //TocuhIDに対応していない場合
//                    print("TourchIDに対応してない")
//                }
            default:
                self.performSegue(withIdentifier: "segueCategory", sender: self)
            }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        var sendtext:String = ""
        
        if (segue.identifier == "segueCategory") {
            
            let ListViewController = segue.destination as! ListViewController
            
            switch self.tagSection {
            case 2:
                switch self.tag {
                //国内
                case 0:
                    sendtext = "https://headlines.yahoo.co.jp/rss/all-dom.xml"
                //国際
                case 1:
                    sendtext = "https://headlines.yahoo.co.jp/rss/all-c_int.xml"
                //経済
                case 2:
                    sendtext = "https://headlines.yahoo.co.jp/rss/all-bus.xml"
                //エンタメ
                case 3:
                    sendtext = "https://headlines.yahoo.co.jp/rss/all-c_ent.xml"
                //スポーツ
                case 4:
                    sendtext = "https://headlines.yahoo.co.jp/rss/all-c_spo.xml"
                //IT・科学
                case 5:
                    sendtext = "https://headlines.yahoo.co.jp/rss/all-c_sci.xml"
                //地域
                case 6:
                    sendtext = "https://headlines.yahoo.co.jp/rss/all-loc.xml"
                default:
                    break
                }
                default :
                    sendtext = "https://news.yahoo.co.jp/byline/rss/all.xml"
            }
            ListViewController.sendtext = sendtext
        }
    }
}

