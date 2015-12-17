//
//  LandInfoTableViewCell.swift
//  funiLand
//
//  Created by You on 15/12/2.
//  Copyright © 2015年 funi. All rights reserved.
//

import UIKit

class LandInfoTableViewCell: BaseCell {

    
    @IBOutlet var keyLabel: UILabel!
    @IBOutlet var valueLabel: UILabel!
    @IBOutlet var valueLabelTopConstraint: NSLayoutConstraint!
    var isSettingTop: Bool = false
    
    var fieldDomain:FieldDomain = FieldDomain(){
        willSet{
            self.keyLabel.text   = String.excludeEmpty(newValue.name)
            self.valueLabel.text = String.excludeEmpty(newValue.value)
            if newValue.height > 25 {
                self.valueLabel.height        = newValue.height!
                self.valueLabel.numberOfLines = 0
                self.isSettingTop             = true
                self.valueLabelTopConstraint.constant = 0
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
