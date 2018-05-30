//
//  CustomTableViewCell.swift
//  newsreader
//
//  Created by 松田 拓也 on 2018/05/08.
//  Copyright © 2018年 松田 拓也. All rights reserved.
//

import UIKit
import RealmSwift

class CustomTableViewCell: UITableViewCell, UITableViewDelegate {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bookMark: UIButton!
    @IBAction func bookMark(_ sender: UIButton) {
           return
       }
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
