//
//  MessageViewController.swift
//  funiLand
//
//  Created by You on 15/11/23.
//  Copyright © 2015年 funi. All rights reserved.
//

import UIKit

class MessageViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate,DZNEmptyDataSetDelegate, DZNEmptyDataSetSource, UIActionSheetDelegate, JTCalendarDelegate {

    @IBOutlet var myTableView: UITableView!
    var calendarManager: JTCalendarManager!
    var calendarContentView: JTHorizontalCalendarView!
    var dateSelected: NSDate?
    var landDataSource: Array<LandArrayRespon>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //基础设置
    func initSteup(){
        //禁用自动调整位置
        self.automaticallyAdjustsScrollViewInsets = false
        //设置展示表格的数据源和代理
        myTableView.dataSource = self
        myTableView.delegate = self
        //空值代理和数据源
        myTableView.emptyDataSetDelegate = self
        myTableView.emptyDataSetSource = self
        
        //集成下拉刷新
        setupDownRefresh()
        
        calendarManager = JTCalendarManager()
        calendarManager.delegate = self
        
    }
    
    //下拉刷新
    func setupDownRefresh(){
//        self.myTableView.addLegendHeaderWithRefreshingBlock { [unowned self]() -> Void in
//            self.queryData()
//        }
    }
    
    //加载数据
    func queryData(){
        
        HttpService.sharedInstance.login(param: nil,
            success: { (str) -> Void in
//                self.myTableView.header.endRefreshing()
                self.myTableView.reloadData()
            }) { (error) -> Void in
//                self.myTableView.header.endRefreshing()
        }
    }
    
    // MARK: - Table view data source and delegate
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 96
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2;
    }
    
    func tableView(tableView:UITableView,cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell{
            
            let Identifier = "myTableViewCell"
            
//            if(tableView == self.roomTableView){
//                if(!self.nibsRegistered){
//                    
//                    let nib = UINib(nibName: "RoomTableViewCell", bundle: nil);
//                    tableView.registerNib(nib, forCellReuseIdentifier: Identifier);
//                    self.nibsRegistered = true;
//                }
//            }else{
//                if(!self.nibsRegisteredForSearchTableView){
//                    
//                    let nib = UINib(nibName: "RoomTableViewCell", bundle: nil);
//                    tableView.registerNib(nib, forCellReuseIdentifier: Identifier);
//                    self.nibsRegisteredForSearchTableView = true;
//                }
//            }
//            
            let cell = tableView.dequeueReusableCellWithIdentifier(Identifier, forIndexPath: indexPath)
            
            return cell;
            
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView?{
        
        let view = UIView()
        view.backgroundColor = UIColor.clearColor()
        return view;
    }
    
    //    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
    //
    //        self.performSegueWithIdentifier("RoomDetailSegue", sender: self);
    //
    //    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("RoomDetailSegue", sender: self);
    }
    
    // MARK: - CalendarManager delegate
    
    func calendar(calendar: JTCalendarManager!, prepareDayView dayView: UIView!) {
        
        let tempDayView = dayView as? JTCalendarDayView
        
        // Today
        if calendarManager.dateHelper.date(NSDate(), isTheSameDayThan: tempDayView?.date) {
            tempDayView?.circleView.hidden = false
            tempDayView?.circleView.backgroundColor = UIColor.blueColor()
            tempDayView?.dotView.backgroundColor = UIColor.whiteColor()
            tempDayView?.textLabel.textColor = UIColor.whiteColor()
        }
        // Selected date
        else if calendarManager.dateHelper.date(dateSelected, isTheSameDayThan: tempDayView?.date) == true {
            
            tempDayView?.circleView.hidden = false
            tempDayView?.circleView.backgroundColor = UIColor.redColor()
            tempDayView?.dotView.backgroundColor = UIColor.whiteColor()
            tempDayView?.textLabel.textColor = UIColor.whiteColor()
        }
        // Other month
        else if calendarManager.dateHelper.date(calendarContentView.date, isTheSameMonthThan: tempDayView?.date) {
            
            tempDayView?.circleView.hidden = true
            tempDayView?.dotView.backgroundColor = UIColor.redColor()
            tempDayView?.textLabel.textColor = UIColor.lightGrayColor()
        }
        // Another day of the current month
        else {
            tempDayView?.circleView.hidden = true
            tempDayView?.dotView.backgroundColor = UIColor.redColor()
            tempDayView?.textLabel.textColor = UIColor.blackColor()
        }
    }
    
    func calendar(calendar: JTCalendarManager!, didTouchDayView dayView: UIView!) {
        
    }
    
    
    
    func haveEventForDay(data: NSDate) {
        
        for landRespon : LandArrayRespon in landDataSource {

        }
        
    }

}
