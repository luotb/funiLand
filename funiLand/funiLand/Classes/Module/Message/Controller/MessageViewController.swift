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
    
    @IBOutlet var calendarMenuView: JTCalendarMenuView!
    @IBOutlet var calendarContentView: JTHorizontalCalendarView!
    
    var todayDate: NSDate?
    var minDate: NSDate?
    var maxDate: NSDate?
    var dateSelected: NSDate?
    var landDataSource: Array<LandArrayRespon>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initSteup()
        self.loadCalendar()
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
    }
    
    //加载日历
    func loadCalendar () {
        calendarManager = JTCalendarManager()
        calendarManager.delegate = self
        todayDate = NSDate();
        
        // Min date will be 2 month before today
        minDate = calendarManager.dateHelper.addToDate(todayDate, months: -2)
        
        // Max date will be 2 month after today
        maxDate = calendarManager.dateHelper.addToDate(todayDate, months: 2)
        
        calendarManager.menuView = calendarMenuView
        calendarManager.contentView = calendarContentView
        calendarManager.setDate(todayDate)
    }
    
    //下拉刷新
    func setupDownRefresh(){
        self.myTableView.addLegendHeaderWithRefreshingBlock { () -> Void in
            self.queryData()
        }
    }
    
    //加载数据
    func queryData(){
        
        HttpService.sharedInstance.login(param: nil,
            success: { (str) -> Void in
                self.myTableView.header.endRefreshing()
                self.myTableView.reloadData()
            }) { (error) -> Void in
                self.myTableView.header.endRefreshing()
        }
    }
    
    // MARK: - Table view data source and delegate
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    
    func tableView(tableView:UITableView,cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell{
            
            let cell = tableView.dequeueReusableCellWithIdentifier("LandTableViewCell", forIndexPath: indexPath)
            
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
//        self.performSegueWithIdentifier("RoomDetailSegue", sender: self);
    }
    
    // MARK: - CalendarManager delegate
    
    func calendar(calendar: JTCalendarManager!, prepareDayView dayView: UIView!) {
        
        let tempDayView = dayView as! JTCalendarDayView
        
        // Today
        if calendarManager.dateHelper.date(NSDate(), isTheSameDayThan: tempDayView.date) {
            tempDayView.circleView.hidden = false
            tempDayView.circleView.backgroundColor = UIColor.blueColor()
            tempDayView.dotView.backgroundColor = UIColor.whiteColor()
            tempDayView.textLabel.textColor = UIColor.whiteColor()
        }
        // Selected date
        else if calendarManager.dateHelper.date(dateSelected, isTheSameDayThan: tempDayView.date) == true {
            
            tempDayView.circleView.hidden = false
            tempDayView.circleView.backgroundColor = UIColor.redColor()
            tempDayView.dotView.backgroundColor = UIColor.whiteColor()
            tempDayView.textLabel.textColor = UIColor.whiteColor()
        }
        // Other month
        else if calendarManager.dateHelper.date(calendarContentView.date, isTheSameMonthThan: tempDayView.date) {
            
            tempDayView.circleView.hidden = true
            tempDayView.dotView.backgroundColor = UIColor.redColor()
            tempDayView.textLabel.textColor = UIColor.lightGrayColor()
        }
        // Another day of the current month
        else {
            tempDayView.circleView.hidden = true
            tempDayView.dotView.backgroundColor = UIColor.redColor()
            tempDayView.textLabel.textColor = UIColor.blackColor()
        }
        
//        if self.haveEventForDay(tempDayView.date) {
//             tempDayView.dotView.hidden = false
//        } else {
//            tempDayView.dotView.hidden = true
//        }
    }
    
    func calendar(calendar: JTCalendarManager!, didTouchDayView dayView: UIView!) {
        
        let tempDayView = dayView as! JTCalendarDayView
        dateSelected = tempDayView.date;
        
        // Animation for the circleView
        tempDayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
        
        UIView.transitionWithView(tempDayView, duration: 0.3, options: UIViewAnimationOptions.AllowAnimatedContent, animations: { () -> Void in
            tempDayView.circleView.transform = CGAffineTransformIdentity
            }, completion: nil)
        
        // Load the previous or next page if touch a day from another month
        
        if calendarManager.dateHelper.date(calendarContentView.date, isTheSameMonthThan: tempDayView.date) {
            if calendarContentView.date.compare(tempDayView.date) == NSComparisonResult.OrderedAscending {
                calendarContentView.loadNextPageWithAnimation()
            } else {
                calendarContentView.loadPreviousPageWithAnimation()
            }
        }
    }
    
    
    //pragma mark - CalendarManager delegate - Page mangement
    
    func calendar(calendar: JTCalendarManager!, canDisplayPageWithDate date: NSDate!) -> Bool {
        return calendarManager.dateHelper.date(date, isEqualOrAfter: nil, andEqualOrBefore: nil)
    }
    
    
    
    func haveEventForDay(date: NSDate) -> Bool {
        var judge : Bool = false
        
        for landRespon : LandArrayRespon in landDataSource {
            print(landRespon)
            
            if landRespon.date == date {
                judge = true
                break
            }
        }
        return judge
    }

}
