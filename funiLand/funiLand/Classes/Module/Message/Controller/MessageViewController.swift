//
//  MessageViewController.swift
//  funiLand
//
//  Created by You on 15/11/23.
//  Copyright © 2015年 funi. All rights reserved.
//

import UIKit

class MessageViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate,DZNEmptyDataSetDelegate, DZNEmptyDataSetSource, UIActionSheetDelegate, JTCalendarDelegate {

    @IBOutlet var dataTypeSegment: UISegmentedControl!
    @IBOutlet var myTableView: UITableView!
    var calendarManager: JTCalendarManager!
    
    @IBOutlet var calendarMenuView: JTCalendarMenuView!
    @IBOutlet var calendarContentView: JTHorizontalCalendarView!
    //当前日期
    var todayDate: NSDate?
    //日历控件最小日期
    var minDate: NSDate?
    //日历控件最大日期
    var maxDate: NSDate?
    //选中的日期
    var dateSelected: NSDate = NSDate()
    //服务器返回的土地数据集合
    var landResponArray: Array<LandArrayRespon>?
    //选中日期对应的土地数据集合
    var landArray: Array<LandDomain> = Array<LandDomain>()
    //请求类型 0=供应, 1=成交
    var reqType: Int = 0
    //初始化请求的月份
    var reqMonth: String = NSDate().getTime(DateFormat.format4)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.queryData()
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
        
        dataTypeSegment.addTarget(self, action:"segmentAction", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    //选择器回调
    func segmentAction(segment:UISegmentedControl) {
        print("ppp\(segment.selectedSegmentIndex)")
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
        
//        HttpService.sharedInstance.getSupplyOrBargainList(reqType, months: reqMonth, success: { (landArray: Array<LandArrayRespon>?) -> Void in
//                self.landResponArray = landArray
//                self.getSelectedDataLandArray()
//                self.calendarManager.reload()
//            }) { (error: String) -> Void in
//                FuniHUD.sharedHud().show(self.myTableView, onlyMsg: error)
//        }
    }
    
    // MARK: - Table view data source and delegate
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "777"
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return landArray.count;
    }
    
    func tableView(tableView:UITableView,cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell{
            
            let cell = tableView.dequeueReusableCellWithIdentifier("LandTableViewCell", forIndexPath: indexPath) as! LandTableViewCell
            cell.landDomain = landArray[indexPath.row]
            return cell;
            
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView?{
        
        let view = UIView()
        view.backgroundColor = UIColor.clearColor()
        return view;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("LandDetailsSegue", sender: self);
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
        else if calendarManager.dateHelper.date(calendarContentView.date, isTheSameMonthThan: tempDayView.date) == false {
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
        
        if landResponArray != nil && landResponArray?.isEmpty != false {
            if self.haveEventForDay(tempDayView.date) {
                tempDayView.dotView.hidden = false
            } else {
                tempDayView.dotView.hidden = true
            }
        }
    }
    
    func calendar(calendar: JTCalendarManager!, didTouchDayView dayView: UIView!) {
        
        let tempDayView = dayView as! JTCalendarDayView
        dateSelected = tempDayView.date;
        self.getSelectedDataLandArray()
        
        // Animation for the circleView
        tempDayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
        
        UIView.transitionWithView(tempDayView, duration: 0.3, options: UIViewAnimationOptions.LayoutSubviews, animations: { () -> Void in
            tempDayView.circleView.transform = CGAffineTransformIdentity
            self.calendarManager.reload()
            }, completion: nil)
        
        // Load the previous or next page if touch a day from another month
        
        if calendarManager.dateHelper.date(calendarContentView.date, isTheSameMonthThan: tempDayView.date) == false {
            if calendarContentView.date.compare(tempDayView.date) == NSComparisonResult.OrderedAscending {
                calendarContentView.loadNextPageWithAnimation()
            } else {
                calendarContentView.loadPreviousPageWithAnimation()
            }
        }
        
        myTableView.reloadData()
    }
    
    
    //pragma mark - CalendarManager delegate - Page mangement
    
    func calendar(calendar: JTCalendarManager!, canDisplayPageWithDate date: NSDate!) -> Bool {
        return calendarManager.dateHelper.date(date, isEqualOrAfter: minDate, andEqualOrBefore: maxDate)
    }
    
    
    //根据指定日期判断是否有数据
    func haveEventForDay(date: NSDate) -> Bool {
        var judge : Bool = false
        
        for landRespon : LandArrayRespon in landResponArray! {
            if calendarManager.dateHelper.date(landRespon.date, isTheSameDayThan: date) {
                judge = true
                break
            }
        }
        return judge
    }
    
    //获得选中日期的土地数据
    func getSelectedDataLandArray() {
        var judge : Bool = false
        for landRespon : LandArrayRespon in landResponArray! {
            if calendarManager.dateHelper.date(landRespon.date, isTheSameDayThan: dateSelected) {
                landArray = landRespon.dataList!
                judge = true
                break
            }
        }
        
        if judge == false {
            landArray = Array<LandDomain>()
        }
    }

}
