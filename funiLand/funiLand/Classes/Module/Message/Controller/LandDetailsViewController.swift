//
//  LandDetailsViewController.swift
//  funiLand
//
//  Created by You on 15/12/1.
//  Copyright © 2015年 funi. All rights reserved.
//

import UIKit

class LandDetailsViewController: BaseViewController, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    @IBOutlet var myTableView: UITableView!
    @IBOutlet var tabelViewHeadView: UIView!
    
    @IBOutlet var rimBtn: UIButton!
    //需要加高的cell记录
    var customCellVOArray: Array<LandDetailsCellVO>?
    //是否显示周边按钮 从地图列表数据釞土地详情不续约显示周边按钮
    var isShowRim: Bool = false
    var landDomain: LandDomain!
    var landInfoObj: LandInfoDomain!
  
    
    //重写父类加载数据
    override func queryData() {
        self.myTableView.header.beginRefreshing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initSteup()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //基础设置
    func initSteup(){
        
        //设置展示表格的数据源和代理
        myTableView.dataSource = self
        myTableView.delegate = self
        myTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        //空值代理和数据源
        myTableView.emptyDataSetDelegate = self
        myTableView.emptyDataSetSource = self
        
        //集成下拉刷新
        setupDownRefresh()
        self.myTableView.header.beginRefreshing()
    }
    
    //下拉刷新
    func setupDownRefresh(){
        self.myTableView.addLegendHeaderWithRefreshingBlock { () -> Void in
            self.requestData()
        }
    }
    
    // 返回Cell需要的height
    func getTableViewCellHeight(indexPath: NSIndexPath) ->CGFloat {
        
        if self.customCellVOArray != nil {
            
            for vo: LandDetailsCellVO in self.customCellVOArray! {
                if vo.section == indexPath.section && vo.row == indexPath.row {
                    return vo.height!
                }
            }
        }
        return 25
    }
    
    //显示周边按钮
    func showRimBtn() {
        if self.isShowRim == true {
            FuniCommon.asynExecuteCode(0.2, code: { () -> Void in
                self.rimBtn.alpha = 1.0
            })
        }
    }
    
    //基数title需要的高度
    func calLandInfoTitleHeight() -> CGFloat {
        var height: CGFloat = 71
        if self.landInfoObj != nil {
            let emojilabel = MLEmojiLabel(frame: CGRectZero)
            let labelWidth = CGRectGetWidth(self.view.frame) - 40
            let size: CGSize = emojilabel.boundingRectWithSize(self.landInfoObj.title!, w: labelWidth, font: 18)
            if size.height > 18 {
                height += size.height - 18
            }
        }
        return height
    }
    
    // 画虚线
    func drawDottedLine(imageView: UIImageView) {
        UIGraphicsBeginImageContext(imageView.size)
        imageView.image?.drawInRect(CGRectMake(0, 0, imageView.width, imageView.height))
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), CGLineCap.Round)
        let lengths:[CGFloat] = [10,5]
        let line = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(line, UIColor.redColor().CGColor);
        
        CGContextSetLineDash(line, 0, lengths, 2);  //画虚线
        CGContextMoveToPoint(line, 0.0, 20.0);    //开始画线
        CGContextAddLineToPoint(line, 310.0, 20.0);
        CGContextStrokePath(line);
        imageView.image = UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func drawInContext(view: UIView) {
        let context: CGContextRef = UIGraphicsGetCurrentContext()!
        
        let lengths: [CGFloat] = [CGFloat(APPWIDTH-20)]
        CGContextSetLineDash(context, 0, lengths, 2)
        
        CGContextMoveToPoint(context, view.x, view.y)
        CGContextAddLineToPoint(context, CGRectGetMaxX(view.frame), CGRectGetMaxY(view.frame))
    }

}

// MARK: - Table view data source and delegate
extension LandDetailsViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let obj = self.landInfoObj {
            return (obj.fieldList?.count)! + 1
        }
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section > 0 {
            return self.landInfoObj.fieldList![section-1].groupFields!.count
        }
        return 1;
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 40
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return self.calLandInfoTitleHeight()
        } else {
            return self.getTableViewCellHeight(indexPath)
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if self.landInfoObj.fieldList?.count > 0 && section > 0 {
            
            let view = UIView(frame: CGRectMake(0, 0, APPWIDTH, 30))
            view.backgroundColor = UIColor.whiteColor()
            
            let dashedLineView = DashedLineView(frame: CGRectMake(10, 0, APPWIDTH-20, 1))
            view.addSubview(dashedLineView)
            
            let label = UILabel(frame: CGRectMake(20, 13, APPWIDTH-40, 16))
            label.textColor = UIColor.textColor3()
            label.text = self.landInfoObj.fieldList![section-1].group
            view.addSubview(label)
            
            return view
        }
        return nil
    }
    
    
    func tableView(tableView:UITableView,cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell{
            if indexPath.section > 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier("LandInfoTableViewCell", forIndexPath: indexPath) as! LandInfoTableViewCell
                let groupDomain: FieldGroupDomain = self.landInfoObj.fieldList![indexPath.section-1]
                let fieldDomain: FieldDomain = groupDomain.groupFields![indexPath.row]
                fieldDomain.height = self.getTableViewCellHeight(indexPath)
                cell.fieldDomain = fieldDomain
                
                return cell;
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier("LandDetailsTitleTableViewCell", forIndexPath: indexPath) as! LandDetailsTitleTableViewCell
                if self.landInfoObj != nil {
                    cell.landInfoObj = self.landInfoObj
                }
                return cell;
            }
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView?{
        
        let view = UIView()
        view.backgroundColor = UIColor.clearColor()
        return view;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
}

// MARK: View EventHandler
extension LandDetailsViewController {
    
    // 周边按钮点击
    @IBAction func rimBtnClicked(sender: UIButton) {
        var params: Dictionary<NSObject, AnyObject> = Dictionary<NSObject, AnyObject>()
        var params2: Dictionary<String, String> = Dictionary<String, String>()
        params2["objId"] = "4040"
        params2["title"] = "测试推送的通知标题"
        
        params["param"] = params2
        
        ((UIApplication.sharedApplication().delegate) as! AppDelegate).handleNotification(params)
        
//        if self.landInfoObj.lat > 0 && self.landInfoObj.lng > 0 {
//            let mapVC = Helper.getViewControllerFromStoryboard("Map", storyboardID: "MapViewController") as! MapViewController
//            
//            let rimInfoReqDomain   = RimInfoReqDomain()
//            rimInfoReqDomain.lat   = self.landInfoObj.lat!
//            rimInfoReqDomain.lng   = self.landInfoObj.lng!
//            mapVC.showRimLandType  = 1
//            mapVC.rimInfoReqDomain = rimInfoReqDomain
//            mapVC.isShowRim        = true
//            self.navigationController?.pushViewController(mapVC, animated: true)
//        }
    }
}

// MARK: Service Request And Data Package
extension LandDetailsViewController {
    
    //加载数据
    func requestData(){
        
        HttpService.sharedInstance.getLandInfo(landDomain.id!, success: { (landInfo: LandInfoDomain?) -> Void in
            if landInfo != nil {
                self.landInfoObj = landInfo!
                self.showRimBtn()
            } else {
                self.landInfoObj = LandInfoDomain()
            }
            
            self.packageDataSource()
            self.myTableView.reloadData()
            self.myTableView.header.endRefreshing()
            
            }) { (error: String) -> Void in
                FuniHUD.sharedHud().show(self.myTableView, onlyMsg: error)
                self.myTableView.header.endRefreshing()
        }
    }
    
    //数据组装
    func packageDataSource() {
        
        if let fieldList = self.landInfoObj.fieldList {
            let emojilabel = MLEmojiLabel(frame: CGRectZero)
            let labelWidth = CGRectGetWidth(self.view.frame) - 140
            
            for var i=0; i<fieldList.count; i++ {
                
                let group: FieldGroupDomain = fieldList[i]
                
                if let fieldGroupList = group.groupFields {
                    
                    for var j=0; j<fieldGroupList.count; j++ {
                        
                        let field: FieldDomain = fieldGroupList[j]
                        
                        let size: CGSize = emojilabel.boundingRectWithSize(field.value!, w: labelWidth, font: 14)
                        
                        if size.height > 25 {
                            let cellVO = LandDetailsCellVO()
                            cellVO.section = i
                            cellVO.row = j
                            cellVO.height = size.height
                            
                            if self.customCellVOArray == nil {
                                self.customCellVOArray = Array<LandDetailsCellVO>()
                            }
                            
                            self.customCellVOArray?.append(cellVO)
                        }
                    }
                }
            }
            
        }
    }
}
