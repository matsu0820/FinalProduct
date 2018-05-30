//
//  RealmDataSet.swift
//  newsreader
//
//  Created by 松田 拓也 on 2018/05/14.
//  Copyright © 2018年 松田 拓也. All rights reserved.
//

import UIKit
import RealmSwift

class RealmDataSet: Object{
    
    @objc dynamic var name = String()
    @objc dynamic var link = String()
    @objc dynamic var favo = false
    @objc dynamic var readed = false
    
    @objc override static func primaryKey() -> String? {
        return "link"
    }
}
