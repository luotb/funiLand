//
//  LandDetailsViewController.swift
//  funiLand
//
//  Created by You on 15/12/1.
//  Copyright © 2015年 funi. All rights reserved.
//

import UIKit

class LandDetailsViewController: BaseViewController{
    
    @IBOutlet var myTableView: UITableView!
    @IBOutlet var tabelViewHeadView: UIView!
    
    @IBOutlet var rimBtn: UIButton!
    //需要加高的cell记录
    var customCellVOArray: Array<LandDetailsCellVO>?
    //是否显示周边按钮 从地图列表数据釞土地详情不续约显示周边按钮
    var isShowRim: Bool = false
    var landInfoObj: LandInfoDomain!
    var landId:String!
    
    //重写父类加载数据
    override func queryData() {
        self.myTableView.header.beginRefreshing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initSteup()
        self.landId = self.landInfoObj.id
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //基础设置
    func initSteup(){
        
        //设置展示表格的数据源和代理
        self.myTableView.dataSource = self
        self.myTableView.delegate = self
        self.myTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        //空值代理和数据源
        self.myTableView.emptyDataSetDelegate = self
        self.myTableView.emptyDataSetSource = self
        
        //集成下拉刷新
        setupDownRefresh()
        
        // 初始化的引导空白页
//        EmptyViewFactory.emptyMainView(self.myTableView) { () -> Void in
//            self.queryData()
//        }
        
        self.queryData()
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
        if self.isShowRim == true && self.landInfoObj.lat > 0 && self.landInfoObj.lng > 0 {
            FuniCommon.animationExecute(0.5, code: { () -> Void in
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

}

// MARK: - Table view data source and delegate
extension LandDetailsViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        let count = self.landInfoObj.fieldList?.count
        if count > 0 {
            return count! + 1
        }
        return 0
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
        if self.landInfoObj.lat > 0 && self.landInfoObj.lng > 0 {
            let mapVC = Helper.getViewControllerFromStoryboard("Map", storyboardID: "MapViewController") as! MapViewController
            
            let rimInfoReqDomain   = RimInfoReqDomain()
            rimInfoReqDomain.lat   = self.landInfoObj.lat!
            rimInfoReqDomain.lng   = self.landInfoObj.lng!
            mapVC.showRimLandType  = 1
            mapVC.rimInfoReqDomain = rimInfoReqDomain
            mapVC.isShowRim        = true
            self.navigationController?.pushViewController(mapVC, animated: true)
        }
    }
}

// MARK: Service Request And Data Package
extension LandDetailsViewController {
    
    //加载数据
    func requestData(){
        
        HttpService.sharedInstance.getLandInfo(landId, success: { (landInfo: LandInfoDomain?) -> Void in
            
            self.landInfoObj = landInfo!
            self.showRimBtn()
            self.packageDataSource()
            self.myTableView.reloadData()
            self.myTableView.header.endRefreshing()
            
            }) { (error: String) -> Void in
                FuniHUD.sharedHud().show(self.view, onlyMsg: error)
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
                            cellVO.section = i + 1
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

extension LandDetailsViewController : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named:"noData");
    }
    
    func buttonTitleForEmptyDataSet(scrollView: UIScrollView!, forState state: UIControlState) -> NSAttributedString! {
        let attributes = [NSFontAttributeName: UIFont.boldSystemFontOfSize(14.0),NSForegroundColorAttributeName:UIColor.lightGrayColor()]
        return NSAttributedString(string: "点击重新刷新", attributes: attributes)
    }
    
    func emptyDataSetDidTapButton(scrollView: UIScrollView!) {
        self.myTableView.header.beginRefreshing()
    }
    
    func emptyDataSetDidTapView(scrollView: UIScrollView!) {
        self.myTableView.header.beginRefreshing()
    }
}
