//
//  LandDetailsTitleTableViewCell.swift
//  funiLand
//
//  Created by You on 15/12/18.
//  Copyright © 2015年 funi. All rights reserved.
//

import UIKit

class LandDetailsTitleTableViewCell: BaseCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var titleHeightConstraint: NSLayoutConstraint!
    @IBOutlet var subTitleLabel: UILabel!
    
    var landInfoObj: LandInfoDomain = LandInfoDomain() {
        willSet{
            self.titleLabel.text = String.excludeEmpty(newValue.title)
            
            let emojilabel = MLEmojiLabel(frame: CGRectZero)
            let labelWidth = CGRectGetWidth(self.contentView.frame) - 40
            let size: CGSize = emojilabel.boundingRectWithSize(self.titleLabel.text, w: labelWidth, font: 18)
            if size.height > 18 {
                self.titleLabel.numberOfLines = 0;
                self.titleHeightConstraint.constant = size.height
            }
            
            var str = ""
            if let area = newValue.region {
                str += area + "     "
            }
            
            if let date = newValue.fieldNo {
                str += date
            }
            
            self.subTitleLabel.text = str
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
