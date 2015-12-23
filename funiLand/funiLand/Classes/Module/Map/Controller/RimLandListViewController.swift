//
//  RimLandListViewController.swift
//  funiLand
//
//  Created by yangyangxun on 15/12/6.
//  Copyright © 2015年 funi. All rights reserved.
//

import UIKit

class RimLandListViewController: BaseViewController,  DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {

    @IBOutlet var myTableView: UITableView!
    
    // 周边请求数据
    var rimInfoReqDomain: RimInfoReqDomain!
    // 数据源
    var rimLandInfoArray:Array<RimLandInfoDomain>!
    // 是否显示周边按钮
    var isShowRim:Bool = false
    
    //加载数据
    override func queryData(){
        self.requestDate()
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
        self.myTableView.dataSource     = self
        self.myTableView.delegate       = self
        self.myTableView.separatorInset = UIEdgeInsetsZero
        
        //空值代理和数据源
        self.myTableView.emptyDataSetDelegate = self
        self.myTableView.emptyDataSetSource   = self
        
        //集成下拉刷新
        setupDownRefresh()
    }
    
    //下拉刷新
    func setupDownRefresh(){
        self.myTableView.addLegendHeaderWithRefreshingBlock { () -> Void in
            self.queryData()
        }
    }
    
}

// MARK: - Table view data source and delegate
extension RimLandListViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rimLandInfoArray.count;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 139
    }
    
    func tableView(tableView:UITableView,cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell{
            
            let cell = tableView.dequeueReusableCellWithIdentifier("RimLandListTableViewCell", forIndexPath: indexPath) as! RimLandListTableViewCell
            if self.rimLandInfoArray.count > 0 {
                cell.rimLandDomain = self.rimLandInfoArray[indexPath.row]
            }
            return cell;
            
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView?{
        
        let view = UIView()
        view.backgroundColor = UIColor.clearColor()
        return view;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if self.rimLandInfoArray.count > 0 {
            let landDetailVC = Helper.getViewControllerFromStoryboard("Message", storyboardID: "LandDetailsViewController") as! LandDetailsViewController
            let rimLandDomain = self.rimLandInfoArray[indexPath.row]
            let landDomain    = LandDomain()
            landDomain.id     = rimLandDomain.id
            landDetailVC.landDomain = landDomain
            landDetailVC.isShowRim  = self.isShowRim
            self.navigationController?.pushViewController(landDetailVC, animated: true)
        }
    }
    
}


// MARK: Service Request And Data Package
extension RimLandListViewController {
    
    func requestDate() {
        HttpService.sharedInstance.getRimInfoList(self.rimInfoReqDomain, success: { (rimInfoArray: Array<RimLandInfoDomain>) -> Void in
            
            self.rimLandInfoArray = rimInfoArray
            self.myTableView.reloadData()
            self.myTableView.header.endRefreshing()
            super.noDataHandler(self.rimLandInfoArray)
            
            }) { (error:String) -> Void in
                FuniHUD.sharedHud().show(self.view, onlyMsg: error)
                self.myTableView.header.endRefreshing()
                super.noDataHandler(self.rimLandInfoArray)
        }
    }
}
