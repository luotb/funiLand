//
//  MapViewController.swift
//  funiLand
//
//  Created by You on 15/11/23.
//  Copyright © 2015年 funi. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: BaseViewController {
    
    
    @IBOutlet var myMapView: MKMapView!
    var locationManager:CLLocationManager!
    var centerCoordinate:CLLocationCoordinate2D!
    //搜索框
    var searchBar: UISearchBar!
    // 定位按钮
    @IBOutlet var userLocationBtn: UIButton!
    // 是否定位成功
    var isUserLocationSuccess: Bool = false
    // 搜索条件View
    @IBOutlet var searchConditionView: UIView!
    //rightBarItem
    var rightBarItemBtn: UIButton!
    //搜索条件按钮
    @IBOutlet var searchBtn: UIButton!
    // 搜索条件内容View
    var searchConditionContentView: MapSearchConditionTableViewController!
    // 搜索条件封装VO
    var rimInfoReqDomain: RimInfoReqDomain!
    // 搜索按钮动画是否执行
    var timerRunning: Bool = false
    // 土地详情view动画是否执行
    var landInfoRunning: Bool = false
    // 周边数据源
    var rimLandArray: Array<RimLandInfoDomain>!
    //所有标注
    var pointAnnotationArray = Array<FuniPointAnnotation>()
    //地图搜索
    var localSearch:MKLocalSearch?
    
    //土地详情View
    @IBOutlet var landInfoView: UIView!
    // 标注点的土地详情
    var annoatationDetailsView:MapAnnotationDetailsViewController!
    // 土地分类View
    @IBOutlet var landTypeView: UIView!
    // 土地类型按钮
    @IBOutlet var landType_LandBtn: UIButton!
    // 项目类型按钮
    @IBOutlet var landType_ProBtn: UIButton!
    // 查看周边数据类型  1=土地, 2=项目
    var showRimLandType: Int = 1
    // 是否是关键词搜索
    var isKeyword: Bool = false
    // 是否是查看周边
    var isShowRim: Bool = false
    // 是否是首页进入
    var isHomeRim: Bool = false
    //土地数据类型过滤
    var rimLandTypeVO: RimLandTypeVO?
    //最后一次点击的标注
    var lastAnnotation: MKAnnotationView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadSearchBar()
        self.initSteup()
        self.loadAnnoatationLandDetailsView()

        if self.isShowRim == true {
            // 查看周边
            self.userLocationBtn.hidden = true
            self.queryData()
        } else {
            // 搜地
            self.rimInfoReqDomain = RimInfoReqDomain()
            startLocation()
        }
        //默认选中土地按钮
        self.landType_LandBtn.selected = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillAppear(animated)
        if self.locationManager != nil {
            self.locationManager.stopUpdatingLocation()
        }
    }
    
    //状态栏按钮设置
    func navBarItemSetting() {
        if self.rimLandArray != nil {
            if rightBarItemBtn == nil {
                self.rightBarItemBtn = UIButton(frame: CGRectMake(0, 0, 30, 30))
                self.rightBarItemBtn.setImage("List_icon", selImg: "List_icon")
                self.rightBarItemBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
                self.rightBarItemBtn.addTarget(self, action: "showListBtnClicked:", forControlEvents: UIControlEvents.TouchUpInside)
                let rightItem = UIBarButtonItem(customView: self.rightBarItemBtn)
                self.navigationItem.rightBarButtonItem = rightItem
            }
            self.rightBarItemBtn.hidden = false
        } else if self.rightBarItemBtn != nil {
            self.rightBarItemBtn.hidden = true
        }
        
        self.searchBarWidthSetting()
    }
    
    //搜索框宽度缩小
    func searchBarWidthSetting() {
        
        if APPWIDTH == APPWIDTH_4 && (self.isShowRim == true || self.isHomeRim == true) {
            //4寸设备
            self.searchBar.width = self.rightBarItemBtn.hidden == true ? 250 : 220
            self.searchBar.x = self.rightBarItemBtn.hidden == true ? 0 : 10
        }
    }
    
    //基础设置
    func initSteup(){
        
        self.myMapView.delegate = self
        self.myMapView.mapType = MKMapType.Standard
        self.myMapView.showsUserLocation = true
        
        self.searchConditionView.setBorderWithWidth(0, color: UIColor.whiteColor(), radian: 5)
        self.searchConditionContentView = self.storyboard?.instantiateViewControllerWithIdentifier("MapSearchConditionTableViewController") as! MapSearchConditionTableViewController
        self.searchConditionContentView.view.frame = CGRectMake(0, 0, 300, 300)
        self.searchConditionView.addSubview(self.searchConditionContentView.view)
        
        self.searchConditionContentView.mapTypeClosure = {
            (mapType: MKMapType) -> Void in
            self.myMapView.mapType = mapType
        }
        
        self.searchConditionContentView.mapDataFilterClosure = {
            (rimLandTypeVO: RimLandTypeVO) -> Void in
            self.rimLandTypeVO = rimLandTypeVO
            self.packagePointAnnatotion()
            self.myMapView.addAnnotations(self.pointAnnotationArray)
        }
    }
    
    // 加载标注土地详情VC
    func loadAnnoatationLandDetailsView() {
        self.annoatationDetailsView = self.storyboard?.instantiateViewControllerWithIdentifier("MapAnnotationDetailsViewController") as! MapAnnotationDetailsViewController
        self.annoatationDetailsView.view.frame = CGRectMake(0, 0, self.landInfoView.width, self.landInfoView.height)
        self.annoatationDetailsView.isShowRim = self.isShowRim
        self.landInfoView.addSubview(self.annoatationDetailsView.view)
        
        self.annoatationDetailsView.rimBtnClickedClosure = {
            (rimLandInfo: RimLandInfoDomain) -> Void in
            
            let mapVC = Helper.getViewControllerFromStoryboard("Map", storyboardID: "MapViewController") as! MapViewController
            
            let tempRimInfoReqDomain = RimInfoReqDomain()
            tempRimInfoReqDomain.lat = rimLandInfo.lat
            tempRimInfoReqDomain.lng = rimLandInfo.lng
            mapVC.rimInfoReqDomain = tempRimInfoReqDomain
            mapVC.isShowRim = true
            self.navigationController?.pushViewController(mapVC, animated: true)
        }
    }
    
    // 加载搜索输入框
    func loadSearchBar() {
        //导航条的搜索条
        self.searchBar = UISearchBar(frame: CGRectMake(0, 6, 250, 30))
        self.searchBar.backgroundColor = UIColor.clearColor()
        self.searchBar.placeholder = "输入土地位置关键字"
        self.searchBar.delegate = self
        self.searchBar.searchBarStyle = UISearchBarStyle.Minimal
        self.searchBar.tintColor = UIColor.whiteColor()
        
        // Get the instance of the UITextField of the search bar
        let searchField: UITextField = self.searchBar.valueForKey("_searchField") as! UITextField
        // Change search bar text color
        searchField.textColor = UIColor.whiteColor()
        
        // Change the search bar placeholder text color
        searchField.setValue(UIColor.colorFromHexString("#AAD2FD"), forKeyPath: "_placeholderLabel.textColor")
        
        let searchView = UIView(frame: CGRectMake(50, 0, 250, 44))
        searchView.backgroundColor = UIColor.clearColor()
        searchView.addSubview(self.searchBar)
        
        self.navigationItem.titleView = searchView
    }
    
    // 关键词搜索 第一条数据居中
    func keywordSearchDefFirstDataCenter() {
        
        if self.pointAnnotationArray.count > 0 {
            
            let pointAnnatotion: FuniPointAnnotation = self.pointAnnotationArray[0]
            
            let time: NSTimeInterval = 2.0
            let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(time * Double(NSEC_PER_SEC)))
            
            dispatch_after(delay, dispatch_get_main_queue()) {
                
                self.myMapView.setCenterCoordinate(pointAnnatotion.coordinate, zoomLevel: 13, animated: true)
            }
        }
    }
    
    // 开始定位
    func startLocation() {
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.startUpdatingLocation()
    }
    
    
    //默认定位到成都
    func defLoadCDMap() {
        
        HttpService.setAppNetworkActivity(true)
        
        let searchRequest = MKLocalSearchRequest()
        searchRequest.naturalLanguageQuery = "成都"
        
        if self.localSearch == nil {
            self.localSearch = MKLocalSearch(request: searchRequest)
        }
        
        self.localSearch?.startWithCompletionHandler({ (response:MKLocalSearchResponse?, error:NSError?) -> Void in
            HttpService.setAppNetworkActivity(false)
            
            if error != nil {
                
            } else {
                let pointAnnotation = FuniPointAnnotation()
                pointAnnotation.coordinate = response!.boundingRegion.center
                self.pointAnnotationArray.append(pointAnnotation)
                
                self.myMapView.setCenterCoordinate(response!.boundingRegion.center, animated: true)
            }
        })
    }
    
    //关闭条件弹窗后的处理
    func closeSearchConditionViewHandler() {
        
        if self.searchConditionContentView.currentDistance != self.rimInfoReqDomain.distance {
            self.rimInfoReqDomain.distance = self.searchConditionContentView.currentDistance
            self.queryData()
        }
        
    }
    
    
    //添加手势
    func addTapGesture() {
        let singleTapGesture = UITapGestureRecognizer(target: self, action: "singleTap")
        singleTapGesture.delegate = self;
        singleTapGesture.numberOfTapsRequired = 1;
        singleTapGesture.cancelsTouchesInView = false;
        self.view.addGestureRecognizer(singleTapGesture)
    }
    
    //show landInfoDetail
    func showLandInfo() {
        
        let animation = _POPSpringAnimation(tension: 100, friction: 10, mass: 1)
        animation.property = _POPAnimatableProperty(name: kPOPLayerPosition)
        
        let landInfoViewY: CGFloat = CGRectGetHeight(self.view.frame) - CGRectGetMaxY(self.landInfoView.frame)
        
        if landInfoViewY < 49 {
            animation.toValue =  NSValue(CGPoint: CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetMaxY(self.view.frame) - CGRectGetHeight(self.landInfoView.frame) + 21))
            self.landInfoRunning = true
        }
        else {
            animation.toValue = NSValue(CGPoint:CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetMaxY(self.view.frame) + 20))
            self.landInfoRunning =  false
        }
        animation.springBounciness = 10.0;
        animation.springSpeed = 10.0;
        _POPAnimation.addAnimation(animation, key: animation.property.name, obj: self.landInfoView.layer)
        
        UIView.transitionWithView(self.userLocationBtn, duration: 0.3, options: UIViewAnimationOptions.LayoutSubviews, animations: { () -> Void in
            
            self.userLocationBtn.alpha = self.landInfoRunning == true ? 0 : 1
            
            }, completion: nil)
    }
    
    //重置标注图标
    func resetAnnotationImg(view: MKAnnotationView, isSelected: Bool) {
        
        if let annotation = view.annotation {
            let pointAnnatotion = annotation as! FuniPointAnnotation
            let imageView = view.viewWithTag(10) as! UIImageView
            
            var imgName = isSelected == true ? "other_click" : "other_normal"
            
            if pointAnnatotion.rimLandInfoDomain?.dataType == 1 {
                //土地
                imgName = isSelected == true ? "Local_click" : "Local_normal"
            }
            imageView.image = UIImage(named: imgName)
        }
    }
}

// MARK: UIGestureRecognizerDelegate
extension MapViewController : UIGestureRecognizerDelegate {
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        
        if touch.view is MKAnnotationView ||
           touch.view is UIButton ||
           touch.view!.isKindOfClass(MapSearchConditionTableViewController) {
            return false
        }
        return true;
    }
}

// MARK: CLLocationManagerDelegate
extension MapViewController : CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        switch (status) {
        case CLAuthorizationStatus.NotDetermined :
            if self.locationManager.respondsToSelector("requestAlwaysAuthorization") {
                if #available(iOS 8.0, *) {
                    self.locationManager.requestWhenInUseAuthorization()
                    self.locationManager.requestAlwaysAuthorization()
                } else {
                    // Fallback on earlier versions
                    if #available(iOS 9.0, *) {
                        self.locationManager.requestLocation()
                    } else {
                        // Fallback on earlier versions
                    }
                }
            }
            break;
            
        case CLAuthorizationStatus.Denied :
            UIAlertView().alertViewWithTitle("请在设置-隐私-定位服务中开启定位功能!")
            self.defLoadCDMap()
            break
            
        case CLAuthorizationStatus.Restricted :
            UIAlertView().alertViewWithTitle("定位服务无法使用!")
            self.defLoadCDMap()
            break
        default:
            self.locationManager.startUpdatingLocation()
            break;
        }
    }

}

// MARK: MKMapViewDelegate
extension MapViewController : MKMapViewDelegate {
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        
        //定位成功记录位置
        self.centerCoordinate = userLocation.location!.coordinate
                
        //让地图显示用户的位置（iOS8一打开地图会默认转到用户所在位置的地图），该方法不能设置地图精度
        //    [mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
        
        //这个方法可以设置地图精度以及显示用户所在位置的地图
        let span = MKCoordinateSpanMake(0.1, 0.1);
        let region = MKCoordinateRegionMake(userLocation.location!.coordinate, span);
        mapView.setRegion(region, animated: true)
        
        if self.isUserLocationSuccess == false {
            self.queryData()
        }
        
        self.isUserLocationSuccess = true
    }
    
    //定位失败
    func mapView(mapView: MKMapView, didFailToLocateUserWithError error: NSError) {
        self.defLoadCDMap()
    }
    
    //可以打印经纬度的跨度，用来测试当前视图下地经纬度跨度是多少，然后用于上面的MKCoordinateSpanMake方法中
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
//        print("\(mapView.region.span.latitudeDelta, mapView.region.span.longitudeDelta)")
    }
    
    //地图标注
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
//        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
//            pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = false
            pinView!.animatesDrop = false
            pinView!.pinColor = .Purple
        }
        else {
            pinView!.annotation = annotation
        }
        
        let pointAnnatotion = annotation as! FuniPointAnnotation
        
        if pointAnnatotion.rimLandInfoDomain != nil {
            
            var imgName = "other_normal"
            
            if pointAnnatotion.rimLandInfoDomain?.dataType == 1 {
                //土地
                imgName = "Local_normal"
            }
            
            let imageView = UIImageView(image: UIImage(named: imgName))
            imageView.center = (pinView?.centerOffset)!
            imageView.y = imageView.y + 32
//            imageView.x = imageView.x + 30
            imageView.tag = 10
            pinView?.addSubview(imageView)
        }
        
        return pinView
    }
    
    // 地图标注点击
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        
        if let annotation = view.annotation {
            let pointAnnatotion = annotation as! FuniPointAnnotation
            self.annoatationDetailsView.rimLandInfoDomain = pointAnnatotion.rimLandInfoDomain!
            if self.landInfoRunning == false {
                self.showLandInfo()
            }
            
            let imageView = view.viewWithTag(10) as! UIImageView
            
            var imgName = "other_click"
            
            if pointAnnatotion.rimLandInfoDomain?.dataType == 1 {
                //土地
                imgName = "Local_click"
            }
            imageView.image = UIImage(named: imgName)
//            if self.lastAnnotation != nil {
//                self.resetAnnotationImg(self.lastAnnotation, isSelected: false)
//            }
//            self.resetAnnotationImg(view, isSelected: true)
            self.lastAnnotation = view
        }
    }
    
    // 在通过双指捏拢、放大、缩小地图的时候回调
    func mapView(mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        if self.timerRunning {
            self.searchConditionBtnClicked(self.searchBtn)
        }
        
        if self.landInfoRunning {
            self.showLandInfo()
        }
    }
}

// MARK: UISearchBarDelegate
extension MapViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        UIApplication.sharedApplication().sendAction("resignFirstResponder", to: nil, from: nil, forEvent: nil)
        self.isKeyword = true
        self.rimInfoReqDomain.keyword = searchBar.text
        self.rimInfoReqDomain.keyword = "东城"
        self.queryData()
    }
    
}

// MARK: View EventHandler
extension MapViewController {
    
    // 定位按钮点击
    @IBAction func userLocationBtnClicked(sender: AnyObject) {
        if self.centerCoordinate == nil {
            self.startLocation()
        } else {
            //用户位置为地图中心点
            self.myMapView.setCenterCoordinate(self.centerCoordinate, animated: true)
        }
    }
    
    // 查询条件按钮点击
    @IBAction func searchConditionBtnClicked(sender: UIButton) {
        sender.selected = !self.timerRunning
        
        self.searchConditionView.alpha = 1.0
        let animation = _POPSpringAnimation(tension: 100, friction: 10, mass: 1)
        animation.property = _POPAnimatableProperty(name: kPOPLayerSize)
        
        if self.searchConditionView.width <= 5 {
            animation.toValue =  NSValue(CGSize: CGSizeMake(300, 340))
            self.timerRunning = true
        }
        else {
            animation.toValue = NSValue(CGSize:CGSizeMake(5, 5))
            self.timerRunning = false
        }
        animation.springBounciness = 10.0;
        animation.springSpeed = 10.0;
        
        let animation2 = _POPSpringAnimation(tension: 100, friction: 10, mass: 1)
        animation2.property = _POPAnimatableProperty(name: kPOPLayerPosition)
        
        if self.searchConditionView.width <= 5 {
            animation2.toValue =  NSValue(CGPoint: CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetMaxY(self.searchBtn.frame) + 180))
        }
        else {
            animation2.toValue = NSValue(CGSize:CGSizeMake(CGRectGetMidX(self.searchBtn.frame), CGRectGetMidY(self.searchBtn.frame)))
        }
        animation2.springBounciness = 10.0;
        animation2.springSpeed = 10.0;
        
        _POPAnimation.addAnimation(animation, key: animation.property.name, obj: self.searchConditionView.layer)
        _POPAnimation.addAnimation(animation2, key: animation2.property.name, obj: self.searchConditionView.layer)
        
        let time: NSTimeInterval = 0.5
        let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(time * Double(NSEC_PER_SEC)))
        
        dispatch_after(delay, dispatch_get_main_queue()) {
            
            if self.timerRunning == false {
                self.closeSearchConditionViewHandler()
            }
        }
    }
    
    // 列表显示数据
    @IBAction func showListBtnClicked(sender: AnyObject) {
        
        let rimLandListVC = self.storyboard?.instantiateViewControllerWithIdentifier("RimLandListViewController") as! RimLandListViewController
        rimLandListVC.rimInfoReqDomain = self.rimInfoReqDomain
        rimLandListVC.rimLandInfoArray = self.rimLandArray
        self.navigationController?.pushViewController(rimLandListVC, animated: true)
        
    }
    
    //单击响应
    func singleTap() {
        print("090909")
    }
    
    // 土地类型按钮点击
    @IBAction func landTypeBtnClicked(sender: UIButton) {
        
        self.showRimLandType = sender.tag
        self.packagePointAnnatotion()
        self.myMapView.addAnnotations(self.pointAnnotationArray)
        self.keywordSearchDefFirstDataCenter()
        
        if self.showRimLandType == 1 {
            self.landType_LandBtn.selected = true
            self.landType_ProBtn.selected = false
        } else {
            self.landType_LandBtn.selected = false
            self.landType_ProBtn.selected = true
        }
    }
    
}

// MARK: Service Request And Data Package
extension MapViewController {
    
    //请求数据
    override func queryData() {
        FuniHUD.sharedHud().show(self.view)
        HttpService.sharedInstance.getRimInfoList(rimInfoReqDomain, success: { (rimInfoArray: Array<RimLandInfoDomain>) -> Void in
            
            self.rimLandArray = rimInfoArray
            
//            self.testDataSourceTypeCount(rimInfoArray)
            
            self.packagePointAnnatotion()
            self.myMapView.addAnnotations(self.pointAnnotationArray)
            self.keywordSearchDefFirstDataCenter()
            self.navBarItemSetting()
            FuniHUD.sharedHud().hide(self.view)
            
            }) { (error:String) -> Void in
                FuniHUD.sharedHud().show(self.view, onlyMsg: error)
        }
    }
    
    //封装标注数据
    func packagePointAnnatotion() {
        
        self.myMapView.removeAnnotations(self.pointAnnotationArray)
        self.pointAnnotationArray.removeAll()
        
        if let rimArray = self.rimLandArray {
            
            var tempRimArray: Array<RimLandInfoDomain> = Array<RimLandInfoDomain>()
            
            for rimInfoDomain: RimLandInfoDomain in rimArray {
                
                if rimInfoDomain.lat > 0 &&
                    rimInfoDomain.lng > 0 &&
                    rimInfoDomain.dataType == self.showRimLandType {
                        
                        tempRimArray.append(rimInfoDomain)
                }
            }
            
            self.rimLandInfoDataFilter(tempRimArray)
        }
    }
    
    //数据二次过滤
    func rimLandInfoDataFilter(rimArray: Array<RimLandInfoDomain>) {
        
        var tempRimArray: Array<RimLandInfoDomain> = Array<RimLandInfoDomain>()
        
        if self.rimLandTypeVO != nil {
            
            tempRimArray.appendContentsOf(self.filterArray((self.rimLandTypeVO?.fieldType2)!, fieldType: 2, dataSource: rimArray))
            tempRimArray.appendContentsOf(self.filterArray((self.rimLandTypeVO?.fieldType3)!, fieldType: 3, dataSource: rimArray))
            tempRimArray.appendContentsOf(self.filterArray((self.rimLandTypeVO?.fieldType4)!, fieldType: 4, dataSource: rimArray))
            
        } else {
            tempRimArray.appendContentsOf(rimArray)
        }
        
        if tempRimArray.count == 0 {
            tempRimArray.appendContentsOf(rimArray)
        }
        
        for rimInfoDomain: RimLandInfoDomain in tempRimArray {
            
            let pointAnnatotion = FuniPointAnnotation()
            pointAnnatotion.coordinate = CLLocationCoordinate2DMake(rimInfoDomain.lat! - Number_Lat, rimInfoDomain.lng! - Number_Lng)
            pointAnnatotion.rimLandInfoDomain = rimInfoDomain
            pointAnnatotion.title = rimInfoDomain.title!
            self.pointAnnotationArray.append(pointAnnatotion)
        }
    }
    
    
    // 过滤array
    func filterArray(on: Bool, fieldType: Int, dataSource: Array<RimLandInfoDomain>) -> Array<RimLandInfoDomain> {
        
        if on == true {
            return dataSource.filter({ (tempRimLandInfoDomain: RimLandInfoDomain) -> Bool in
                return tempRimLandInfoDomain.fieldType == fieldType
            })
        }
        
        return Array<RimLandInfoDomain>()
    }
    
    
    //test
    func testDataSourceTypeCount(rimArray: Array<RimLandInfoDomain>) {
        if self.rimLandTypeVO != nil {
            let dataSource2: Array<RimLandInfoDomain> = self.filterArray((self.rimLandTypeVO?.fieldType2)!, fieldType: 2, dataSource: rimArray)
            print("dataSource2=\(dataSource2.count)")
            
            let dataSource3: Array<RimLandInfoDomain> = self.filterArray((self.rimLandTypeVO?.fieldType3)!, fieldType: 3, dataSource: rimArray)
            print("dataSource3=\(dataSource3.count)")
            
            let dataSource4: Array<RimLandInfoDomain> = self.filterArray((self.rimLandTypeVO?.fieldType4)!, fieldType: 4, dataSource: rimArray)
            print("dataSource4=\(dataSource4.count)")
        }
    }
    
}


