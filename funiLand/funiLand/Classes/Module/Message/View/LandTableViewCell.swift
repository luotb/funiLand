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
            self.typeLabel.text  = newValue.type!
            self.typeLabel.backgroundColor = UIColor.getLandTypeColor(newValue.type!)
            self.titleLabel.text = newValue.title!
            self.projectNameLabel.text = newValue.description1!
            self.descLabel.text = newValue.description2!
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
