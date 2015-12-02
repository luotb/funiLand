//
//  BaseCell.swift
//  funiLand
//
//  Created by You on 15/12/2.
//  Copyright © 2015年 funi. All rights reserved.
//

import UIKit

class BaseCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = UITableViewCellSelectionStyle.None
    }

}
