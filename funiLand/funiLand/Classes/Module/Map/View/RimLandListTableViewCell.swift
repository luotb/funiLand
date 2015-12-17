//
//  RimLandListTableViewCell.swift
//  funiLand
//
//  Created by You on 15/5/9.
//  Copyright © 2015年 funi. All rights reserved.
//

import UIKit

class RimLandListTableViewCell: BaseCell {
    
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var areaLabel: UILabel!
    @IBOutlet var cubagerateLabel: UILabel!
    @IBOutlet var transferDateLabel: UILabel!
    @IBOutlet var fieldusageNameLabel: UILabel!
    
    var rimLandDomain:RimLandInfoDomain = RimLandInfoDomain(){
        willSet{
            self.typeLabel.text            = String.excludeEmpty(newValue.type)
            self.typeLabel.backgroundColor = UIColor.landTypeColor(newValue.type)
            self.titleLabel.text           = String.excludeEmpty(newValue.title)
            self.distanceLabel.text        = String.excludeEmpty(newValue.distance)
            self.areaLabel.text            = String.excludeEmpty(newValue.netAreaMu)
            self.cubagerateLabel.text      = String.excludeEmpty(newValue.cubagerateMax)
            self.transferDateLabel.text    = String.excludeEmpty(newValue.transferDate)
            self.fieldusageNameLabel.text  = String.excludeEmpty(newValue.fieldusageName)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
