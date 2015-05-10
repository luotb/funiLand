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
            self.typeLabel.text  = newValue.type
            self.typeLabel.backgroundColor = UIColor.getLandTypeColor(newValue.type)
            self.titleLabel.text = newValue.title
            self.distanceLabel.text = newValue.distance
            self.areaLabel.text = newValue.netAreaMu
            if let cub = newValue.cubagerateMax {
                self.cubagerateLabel.text = String(cub)
            }
            self.transferDateLabel.text = newValue.transferDate
            self.fieldusageNameLabel.text = newValue.fieldusageName
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
