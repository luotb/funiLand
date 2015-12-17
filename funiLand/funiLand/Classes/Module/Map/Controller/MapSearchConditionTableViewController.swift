//
//  MapSearchConditionTableView.swift
//  funiLand
//
//  Created by You on 15/12/2.
//  Copyright © 2015年 funi. All rights reserved.
//

import UIKit

//地图显示类型闭包
typealias  SendMapTypeClosure = (mapType: MKMapType) -> Void
//地图数据过滤闭包
typealias  SendMapDataFilterClosure = (rimLandTypeVO: RimLandTypeVO) -> Void

class MapSearchConditionTableViewController: UITableViewController {
    
    @IBOutlet var mapTypeMoonBtn: UIButton!
    @IBOutlet var mapType2DBtn: UIButton!
    @IBOutlet var switch1: UISwitch!
    @IBOutlet var switch2: UISwitch!
    @IBOutlet var switch3: UISwitch!
    @IBOutlet var distanceSegment: UISegmentedControl!
    //当前公里数
    var currentDistance: Int = 2
    
    //声明一个地图显示类型闭包
    var mapTypeClosure: SendMapTypeClosure?
    //声明一个地图数据过滤闭包
    var mapDataFilterClosure: SendMapDataFilterClosure?
    var rimLandTypeVO: RimLandTypeVO = RimLandTypeVO()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initSteup()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //基础设置
    func initSteup(){
        
        //禁用自动调整位置
        self.automaticallyAdjustsScrollViewInsets = false
        self.mapTypeBtnClicked(mapType2DBtn)        
        self.distanceSegment.tintColor = UIColor.grayColor()
    }

    //地图类型闭包回调
    func mapTypeCallBack(mapType: MKMapType) {
        if self.mapTypeClosure != nil {
            self.mapTypeClosure!(mapType: mapType)
        }
    }
}

// MARK: View EventHandler
extension MapSearchConditionTableViewController {
    
    // 地图显示类型按钮点击
    @IBAction func mapTypeBtnClicked(sender: UIButton) {
        sender.selected = !sender.selected
        
        if sender.tag == 10 {
            // 卫星
            self.mapType2DBtn.selected = false
            self.mapTypeMoonBtn.setBorderWithWidth(2, color: UIColor.borderColor1(), radian: 5)
            self.mapType2DBtn.setBorderWithWidth(1, color: UIColor.borderColor2(), radian: 5)
            self.mapTypeCallBack(MKMapType.Satellite)
        } else {
            // 2D
            self.mapTypeMoonBtn.selected = false
            self.mapTypeMoonBtn.setBorderWithWidth(1, color: UIColor.borderColor2(), radian: 5)
            self.mapType2DBtn.setBorderWithWidth(2, color: UIColor.borderColor1(), radian: 5)
            self.mapTypeCallBack(MKMapType.Standard)
        }
        
    }
    
    // 开关改变事件
    @IBAction func switchChanged(sender: UISwitch) {
        
        if self.mapDataFilterClosure != nil {
            
            switch sender.tag {
            case 12:
                self.rimLandTypeVO.fieldType2 = sender.on
                break
            case 13:
                self.rimLandTypeVO.fieldType3 = sender.on
                break
            case 14:
                self.rimLandTypeVO.fieldType4 = sender.on
                break
            default:
                break
            }
            
            self.mapDataFilterClosure!(rimLandTypeVO: self.rimLandTypeVO)
        }
        
    }
    
    //公里数改变
    @IBAction func distanceSegmentChangeValue(sender: UISegmentedControl) {
        self.currentDistance = sender.selectedSegmentIndex + 1
    }
}
