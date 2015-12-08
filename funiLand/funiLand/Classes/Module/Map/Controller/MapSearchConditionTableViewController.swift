//
//  MapSearchConditionTableView.swift
//  funiLand
//
//  Created by You on 15/12/2.
//  Copyright © 2015年 funi. All rights reserved.
//

import UIKit

typealias  SendValueClosure = (String) -> Int

class MapSearchConditionTableViewController: UITableViewController {
    
    
    @IBOutlet var mapTypeMoonBtn: UIButton!
    @IBOutlet var mapType2DBtn: UIButton!
    @IBOutlet var switch1: UISwitch!
    @IBOutlet var switch2: UISwitch!
    @IBOutlet var switch3: UISwitch!
    @IBOutlet var distanceSegment: UISegmentedControl!
    
    var sendValueClosure:SendValueClosure?
    
    var rimInfoReqDomain: RimInfoReqDomain!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initSteup()
//        let a = self.sendValueClosure!("aaaa")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //基础设置
    func initSteup(){
        
        //禁用自动调整位置
        self.automaticallyAdjustsScrollViewInsets = false
        self.mapTypeBtnClicked(mapType2DBtn)
        
        self.switch1.addTarget(self, action: "switchChanged:", forControlEvents: UIControlEvents.ValueChanged)
        self.switch2.addTarget(self, action: "switchChanged:", forControlEvents: UIControlEvents.ValueChanged)
        self.switch3.addTarget(self, action: "switchChanged:", forControlEvents: UIControlEvents.ValueChanged)
    }

    // 地图显示类型按钮点击
    @IBAction func mapTypeBtnClicked(sender: UIButton) {
        sender.selected = !sender.selected
        
        if sender.tag == 10 {
            // 卫星
            self.mapType2DBtn.selected = false
            self.mapTypeMoonBtn.setBorderWithWidth(2, color: UIColor.colorFromHexString("#00A2FF"), radian: 5)
            self.mapType2DBtn.setBorderWithWidth(1, color: UIColor.colorFromHexString("#858585"), radian: 5)
        } else {
            // 2D
            self.mapTypeMoonBtn.selected = false
            self.mapTypeMoonBtn.setBorderWithWidth(1, color: UIColor.colorFromHexString("#858585"), radian: 5)
            self.mapType2DBtn.setBorderWithWidth(2, color: UIColor.colorFromHexString("#00A2FF"), radian: 5)
        }
        
    }
    
    // 开关改变事件
    @IBAction func switchChanged(sender: UISwitch) {
//        switch sender.tag {
//        case 11 :
//            self.rimInfoReqDomain.check1 = sender.on
//            break
//        case 12 :
//            self.rimInfoReqDomain.check2 = sender.on
//            break
//        case 13 :
//            self.rimInfoReqDomain.check3 = sender.on
//            break
//        default:
//            break
//        }
    }
    
}
