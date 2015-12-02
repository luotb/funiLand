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
    
    var fieldDomain:FieldDomain = FieldDomain(){
        willSet{
            self.keyLabel.text = newValue.name
            self.valueLabel.text = newValue.value
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
