//
//  LandTableViewCell.swift
//  funiLand
//
//  Created by yangyangxun on 15/11/26.
//  Copyright © 2015年 funi. All rights reserved.
//

import UIKit

class LandTableViewCell: UITableViewCell {

//    @IBOutlet var typeImageView: UIImageView!
//    @IBOutlet var titleLabel: UILabel!
//    @IBOutlet var projectNameLabel: UILabel!
//    @IBOutlet var descLabel: UILabel!
    
//    var landDomain:LandDomain = LandDomain(){
//        willSet{
//            self.titleLabel.text = newValue.title!
//            self.projectNameLabel.text = newValue.description1!
//            self.descLabel.text = newValue.description2!
//        }
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func resetParame(landDomain: LandDomain) {
        
    }
    
}
