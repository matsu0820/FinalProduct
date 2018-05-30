//
//  FavoListViewController.swift
//  newsreader
//
//  Created by 松田 拓也 on 2018/05/24.
//  Copyright © 2018年 松田 拓也. All rights reserved.
//

import UIKit
import RealmSwift

class FavoListViewController: UITableViewController {
    
    var items = [Item]()
    var item:Item?
    let realm = try! Realm()
    var bookMarklink = [String?]()
    var readedLink = [String?]()
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int{
        print(items.count)
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoCell", for: indexPath) as! CustomTableViewCell
        //タイトルをセルに格納
        cell.titleLabel?.text = items[indexPath.row].title
        //テーブルが再利用対策としてタイトルの色をデフォルトの黒色にする
        cell.titleLabel?.textColor = UIColor.black
        cell.bookMark.tag = indexPath.row
        cell.bookMark.setTitleColor(UIColor.init(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0), for: .normal)
        cell.bookMark?.addTarget(self, action: #selector(self.bookMarkAdd(sender:)) , for: UIControlEvents.touchUpInside)
        
        //ブックマークボタンが押下されているタイトルとリンクを格納
        let reserveBookMark = realm.objects(RealmDataSet.self).filter("favo == true")
        let reserveReaded = realm.objects(RealmDataSet.self).filter("readed == true")
        print(reserveReaded, reserveBookMark)
        
        for dataBook in reserveBookMark {
            bookMarklink.append(dataBook.link)
        }
        
        for dataRead in reserveReaded {
            readedLink.append(dataRead.link)
        }
        
        if bookMarklink.index(of: items[indexPath.row].link) != nil{
            cell.bookMark.setTitleColor(UIColor.orange, for: .normal)
        }
        
        if readedLink.index(of: items[indexPath.row].link) != nil{
            cell.titleLabel.textColor = UIColor.red
        }
        return cell
    }
    
    @objc func bookMarkAdd(sender: UIButton){
        let cell = sender.superview?.superview as! UITableViewCell
        guard let bookMarkNum = self.tableView.indexPath(for: cell)?.row else {
            return
        }
        print(bookMarkNum)
        if sender.currentTitleColor == UIColor.orange {
            
            sender.setTitleColor(UIColor.init(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0), for: .normal)
            
            //お気に入りの判定変更
            try! realm.write {
                
                self.realm.create(RealmDataSet.self, value:["link":items[bookMarkNum].link, "favo":false],update: true)
            }
            
        }
            //ブックマークのボタンの色がオレンジ以外だった場合
        else {
            
            sender.setTitleColor(UIColor.orange, for: .normal)
            
            //お気に入りのデータ保存
            try! realm.write {
                
                realm.create(RealmDataSet.self, value: ["link": items[bookMarkNum].link, "name": items[bookMarkNum].title, "favo":true], update:true)
            }
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let bookMarkData = RealmDataSet()
        //let favoList = realm.objects(RealmDataSet.self).filter("favo == true")
        if  let indexPath = self.tableView.indexPathForSelectedRow{
            let item = items[indexPath.row]
            let controller = segue.destination as! DetailViewController
            controller.title = item.title
            controller.link = item.link
            let Link = controller.link
            let name = controller.title
            bookMarkData.name = name!
            bookMarkData.link = Link!
            try! realm.write {
                realm.create(RealmDataSet.self, value:["link": Link!, "name":name!, "readed": true], update:true)
            }
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let favoList = realm.objects(RealmDataSet.self).filter("favo == true")
        for favoData in favoList {
            var item:Item = Item()
            item.title = favoData.name
            item.link = favoData.link
            items.append(item)
        }
    }
        //リロード処理
//        self.refreshControl = UIRefreshControl()
//        self.refreshControl?.attributedTitle = NSAttributedString(string: "引っ張って更新")
//        self.refreshControl?.addTarget(self, action: #selector(self.refresh(sender:)), for:UIControlEvents.valueChanged)
//        self.refreshControl = refreshControl
//        self.tableView.addSubview(refreshControl!)
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
}
