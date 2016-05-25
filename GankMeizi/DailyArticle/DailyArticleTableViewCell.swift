//
//  DailyArticleTableViewCell.swift
//  GankMeizi
//
//  Created by 卢小辉 on 16/5/24.
//  Copyright © 2016年 lulee007. All rights reserved.
//

import UIKit

class DailyArticleTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var from: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
