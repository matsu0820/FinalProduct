//
//  ListViewController.swift
//  newsreader
//
//  Created by 松田 拓也 on 2018/04/13.
//  Copyright © 2018年 松田 拓也. All rights reserved.
//

import UIKit
import RealmSwift

class ListViewController: UITableViewController, XMLParserDelegate {
    var parser:XMLParser!
    var items = [Item]()
    var item:Item?
    var currentString = ""
    var sendtext:String = "https://news.yahoo.co.jp/byline/rss/all.xml"
    let realm = try! Realm()
    var bookMarklink = [String?]()
    var readedLink = [String?]()
    var tagNumber = 0
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // ハンバーガーメニューボタンタップ処理
    @IBAction func tapMenu(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "showMenu", sender: nil)
    }
    
    @IBAction func refreshButton(_ sender: UIBarButtonItem) {
        startDownload()
    }
    
    //セルの数をカウント
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int{
        return items.count
    }
    //セルの内容を設定
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //リロード処理
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.attributedTitle = NSAttributedString(string: "引っ張って更新")
        self.refreshControl?.addTarget(self, action: #selector(self.refresh(sender:)), for:UIControlEvents.valueChanged)
        self.refreshControl = refreshControl
        self.tableView.addSubview(refreshControl!)
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        startDownload()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func startDownload(){
        self.items = []
            if let url =  URL(string: sendtext){
                if let parser = XMLParser(contentsOf: url){
                    
                    self.parser = parser
                    self.parser.delegate = self
                    self.parser.parse()
                }
            }
        
    }
    
    func parser(_ parser: XMLParser,
                didStartElement elementName: String, namespaceURI: String?,
                qualifiedName qName: String?,
                attributes attributeDict: [String : String]){
        self.currentString = ""
        if elementName == "item"{
            self.item = Item()
        }
    }
    
    func parser(_ parser:XMLParser, foundCharacters string: String){
        self.currentString += string
    }
    
    func parser(_ parser: XMLParser,
                didEndElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?){
        
        switch elementName{
        case "title": self.item?.title = currentString
        case "link": self.item?.link = currentString
        case "item": self.items.append(self.item!)
        default : break
        }
    }
    
    @objc func parserDidEndDocument(_ parser: XMLParser) {
        self.tableView.reloadData()
        refreshControl?.endRefreshing()
    }
    
    //画面遷移時の処理
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let bookMarkData = RealmDataSet()
        if  let indexPath = self.tableView.indexPathForSelectedRow{
            let item = items[indexPath.row]
            let controller = segue.destination as! DetailViewController
            controller.title = item.title
            controller.link = item.link
            let Link = controller.link
            let name = controller.title
            bookMarkData.name = name!
            bookMarkData.link = Link!
            print(items)
            try! realm.write {
                realm.create(RealmDataSet.self, value:["link": Link!, "name":name!, "readed": true], update:true)
            }
        }
    }
    
    //リフレッシュした時の処理
    @objc func refresh(sender : UIRefreshControl) {
        refreshControl?.beginRefreshing()
        self.tableView.reloadData()
        startDownload()
    }
    
    //ブックマークボタンを押下した時の処理
    @objc func bookMarkAdd(sender: UIButton){
        let cell = sender.superview?.superview as! UITableViewCell
        guard let bookMarkNum = self.tableView.indexPath(for: cell)?.row else {
            return
        }
        print(bookMarkNum)
        if sender.currentTitleColor == UIColor.orange {
            
            //アラート機能
            let alert = UIAlertController(title: "お気に入り", message: "削除しますか？", preferredStyle: .alert)
            
            //削除アクション
            let okAction = UIAlertAction(title: "削除", style: .destructive, handler: {
                (action: UIAlertAction!) in
                print("アクション１をタップした時の処理")
                deleteFavo()
            })
            //キャンセルアクション
            let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler:nil)
            
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true, completion: nil)
            
            func deleteFavo() {
                sender.setTitleColor(UIColor.init(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0), for: .normal)
                
                //お気に入りの判定変更
                try! realm.write {
                    
                    self.realm.create(RealmDataSet.self, value:["link":items[bookMarkNum].link, "favo":false],update: true)
                }
            
        }
        }    //ブックマークのボタンの色がオレンジ以外だった場合
        else {
            
            sender.setTitleColor(UIColor.orange, for: .normal)
            
            //お気に入りのデータ保存
            try! realm.write {
                
                realm.create(RealmDataSet.self, value: ["link": items[bookMarkNum].link, "name": items[bookMarkNum].title, "favo":true], update:true)
            }
            
        }
    }
}
