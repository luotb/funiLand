//
//  MapAnnotationDetailsViewController.swift
//  funiLand
//
//  Created by You on 15/12/7.
//  Copyright © 2015年 funi. All rights reserved.
//

import UIKit

//周边按钮点击闭包
typealias  SendRimBtnClickedClosure = (rimLandInfoDomain:RimLandInfoDomain) -> Void
//查看土地详情按钮点击闭包
typealias  SendRimLandInfoBtnClickedClosure = (rimLandInfoDomain: RimLandInfoDomain) -> Void

class MapAnnotationDetailsViewController: BaseViewController {

    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var areaLabel: UILabel!
    @IBOutlet var ratioLabel: UILabel!
    @IBOutlet var sellDateLabel: UILabel!
    @IBOutlet var landTypeLabel: UILabel!
    @IBOutlet var rimBtn: UIButton!
    
    var rimBtnClickedClosure: SendRimBtnClickedClosure?
    var sendRimLandInfoBtnClickedClosure:SendRimLandInfoBtnClickedClosure?
    
    // 是否是查看周边
    var isShowRim: Bool = Bool() {
        willSet{
            // 如果本身是查看周边数据 则需要隐藏本view的周边按钮  避免循环切换页面
            self.rimBtn.hidden = newValue
        }
    }
    
    var rimLandInfoDomain:RimLandInfoDomain = RimLandInfoDomain(){
        willSet{
            self.titleLabel.text    = String.excludeEmpty(newValue.title)
            self.areaLabel.text     = String.excludeEmpty(newValue.netAreaMu)
            self.ratioLabel.text    = String.excludeEmpty(newValue.cubagerateMax)
            self.sellDateLabel.text = String.excludeEmpty(newValue.transferDate)
            self.landTypeLabel.text = String.excludeEmpty(newValue.fieldusageName)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.7)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

// MARK: View EventHandler
extension MapAnnotationDetailsViewController {
    
    // 周边按钮点击
    @IBAction func rimBtnClicked(sender: UIButton) {
        if self.rimBtnClickedClosure != nil {
            self.rimBtnClickedClosure!(rimLandInfoDomain: self.rimLandInfoDomain)
        }
    }
    
    @IBAction func showLandInfoBtnClicked(sender: UIButton) {
        if self.sendRimLandInfoBtnClickedClosure != nil {
            self.sendRimLandInfoBtnClickedClosure!(rimLandInfoDomain: self.rimLandInfoDomain)
        }
    }
    
}
