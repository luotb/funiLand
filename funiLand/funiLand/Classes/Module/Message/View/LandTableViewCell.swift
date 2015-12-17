//
//  LandTableViewCell.swift
//  funiLand
//
//  Created by yangyangxun on 15/11/26.
//  Copyright © 2015年 funi. All rights reserved.
//

import UIKit

class LandTableViewCell: BaseCell {

    
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var projectNameLabel: UILabel!
    @IBOutlet var descLabel: UILabel!
    
    var landDomain:LandDomain = LandDomain(){
        willSet{
            self.typeLabel.text            = String.excludeEmpty(newValue.type)
            self.typeLabel.backgroundColor = UIColor.landTypeColor(newValue.type!)
            self.titleLabel.text           = String.excludeEmpty(newValue.title)
            self.projectNameLabel.text     = String.excludeEmpty(newValue.description1)
            self.descLabel.text            = String.excludeEmpty(newValue.description2)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
