//
//  MapAnnotationDetailsViewController.swift
//  funiLand
//
//  Created by You on 15/12/7.
//  Copyright © 2015年 funi. All rights reserved.
//

import UIKit

class MapAnnotationDetailsViewController: BaseViewController {

    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var areaLabel: UILabel!
    @IBOutlet var ratioLabel: UILabel!
    @IBOutlet var sellDateLabel: UILabel!
    @IBOutlet var landTypeLabel: UILabel!
    
    var rimLandInfoDomain:RimLandInfoDomain = RimLandInfoDomain(){
        willSet{
            self.titleLabel.text = newValue.title!
            self.areaLabel.text  = newValue.netAreaMu!
            self.ratioLabel.text = String(newValue.cubagerateMax!)
            self.sellDateLabel.text = newValue.transferDate!
            self.landTypeLabel.text = newValue.fieldusageName!
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // 周边按钮点击
    @IBAction func rimBtnClicked(sender: UIButton) {
    }

}
