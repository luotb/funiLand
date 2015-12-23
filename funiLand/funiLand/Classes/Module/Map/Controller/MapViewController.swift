//
//  MapViewController.swift
//  funiLand
//
//  Created by You on 15/11/23.
//  Copyright © 2015年 funi. All rights reserved.
//

import UIKit
import MapKit

let MAPZOOMLEVEL: UInt = 13

class MapViewController: BaseViewController {
    
    
    @IBOutlet var myMapView: MKMapView!
    var locationManager:CLLocationManager!
    var centerCoordinate:CLLocationCoordinate2D!
    //中心点   1.定位：当前位置； 2.关键词搜索：结果第一条数据； 3.周边：查询参数的经纬度
    var mapCenterCoordinate:CLLocationCoordinate2D!
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
    // 过滤后的周边数据源
    var filterRimLandArray: Array<RimLandInfoDomain>!
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
    var showRimLandType: Int = 0
    // 是否是关键词搜索
    var isKeyword: Bool = false
    // 是否是查看周边
    var isShowRim: Bool = false
    // 是否是首页进入
    var isHomeRim: Bool = false
    //土地数据类型过滤
    var rimLandTypeVO: RimLandTypeVO?
    //最后一次点击的标注
    var lastPointAnnotation: FuniPointAnnotation!
    
    
    //重写父类加载数据
    override func queryData() {
        self.requestData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadSearchBar()
        self.initSteup()
        self.loadAnnoatationLandDetailsView()

        if self.isShowRim == true {
            self.showRimLandModel()
        } else {
            self.showSearchLandModel()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillAppear(animated)
        if self.locationManager != nil {
            self.locationManager.stopUpdatingLocation()
        }
//        self.myMapView.showsUserLocation = false
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
            self.searchConditionBtnClicked(self.searchBtn)
            self.packagePointAnnatotion()
            self.appendUserLocation()
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
            if rimLandInfo.lat > 0 && rimLandInfo.lng > 0 {
                tempRimInfoReqDomain.lat = rimLandInfo.lat! + Number_Lat
                tempRimInfoReqDomain.lng = rimLandInfo.lng! + Number_Lng
            }
            mapVC.showRimLandType = rimLandInfo.dataType!
            mapVC.rimInfoReqDomain = tempRimInfoReqDomain
            mapVC.isShowRim = true
            self.navigationController?.pushViewController(mapVC, animated: true)
        }
        
        self.annoatationDetailsView.sendRimLandInfoBtnClickedClosure = {
            (rimLandInfo: RimLandInfoDomain) -> Void in
            let landDetailVC = Helper.getViewControllerFromStoryboard("Message", storyboardID: "LandDetailsViewController") as! LandDetailsViewController
            let landDomain = LandDomain()
            landDomain.id = rimLandInfo.id
            landDetailVC.landDomain = landDomain
            landDetailVC.isShowRim  = !self.isShowRim
            self.navigationController?.pushViewController(landDetailVC, animated: true)
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
        searchField.setValue(UIColor.inputTextColor(), forKeyPath: "_placeholderLabel.textColor")
        
        let searchView = UIView(frame: CGRectMake(50, 0, 250, 44))
        searchView.backgroundColor = UIColor.clearColor()
        searchView.addSubview(self.searchBar)
        
        self.navigationItem.titleView = searchView
    }
    
    // 关键词搜索 第一条数据居中
    func keywordSearchDefFirstDataCenter() {
        
        if self.pointAnnotationArray.count > 0 {
            
            if self.isKeyword == true {
                //关键词搜索 结果第一条数据为中心点
                let pointAnnatotion: FuniPointAnnotation = self.pointAnnotationArray[0]
                self.mapCenterCoordinate = pointAnnatotion.coordinate
            } else if self.isShowRim == true {
                //周边为中心点
                self.mapCenterCoordinate = CLLocationCoordinate2D(latitude: self.rimInfoReqDomain.lat! - Number_Lat, longitude: self.rimInfoReqDomain.lng! - Number_Lng)
            } else if self.isUserLocationSuccess == true {
                //定位为中心点
                self.mapCenterCoordinate = self.centerCoordinate
            }
            
            FuniCommon.asynExecuteCode(0.5, code: { () -> Void in
                if self.isUserLocationSuccess == false {
                    self.myMapView.setCenterCoordinate(self.mapCenterCoordinate, zoomLevel: MAPZOOMLEVEL, animated: true)
                }
            })
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
        let pointAnnotation = FuniPointAnnotation()
        pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: CD_Lat - Number_Lat, longitude: CD_Lng - Number_Lng)
        self.pointAnnotationArray.append(pointAnnotation)
        self.myMapView.addAnnotations(self.pointAnnotationArray)
        self.myMapView.setCenterCoordinate(pointAnnotation.coordinate, zoomLevel: 10, animated: true)
    }
    
    //关闭条件弹窗后的处理
    func closeSearchConditionViewHandler() {
        
        if self.searchConditionContentView.currentDistance != self.rimInfoReqDomain.distance {
            self.rimInfoReqDomain.distance = self.searchConditionContentView.currentDistance
            self.queryData()
        }
        
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
    func resetAnnotationImg(pointAnnotation: FuniPointAnnotation, isSelected: Bool) {
        
        if let annotationImageView = pointAnnotation.imageView {
            var imgName = isSelected == true ? "xuanzhong" : "other_normal"
            
            if pointAnnotation.rimLandInfoDomain?.dataType == 1 {
                //土地
                imgName = isSelected == true ? "xuanzhong" : "Local_normal"
            }
            annotationImageView.image = UIImage(named: imgName)
        }
    }
    
    //定位设置查询条件的经纬度为当前位置
    func setUserLocationToReqParam() {
        self.rimInfoReqDomain.lat = self.centerCoordinate.latitude + Number_Lat
        self.rimInfoReqDomain.lng = self.centerCoordinate.longitude + Number_Lng
        self.queryData()
    }
    
    //查看周边
    func showRimLandModel() {
        // 查看周边
        self.userLocationBtn.hidden = true
        self.setLandDataTypeBtnSelectedStatus()
        self.queryData()
    }
    
    //搜地模式
    func showSearchLandModel() {
        // 搜地
        self.rimInfoReqDomain = RimInfoReqDomain()
        if self.isHomeRim == true {
            self.setLandDataTypeBtnSelectedStatus()
        }
        self.myMapView.showsUserLocation = true
        startLocation()
    }
    
    //设置数据类型按钮选中状态
    func setLandDataTypeBtnSelectedStatus() {
        if self.showRimLandType == 1 {
            self.landType_LandBtn.selected = true
        } else {
            self.landType_ProBtn.selected = true
        }
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
        userLocation.title = ""
        
        if self.isUserLocationSuccess == false {
            self.setUserLocationToReqParam()
            self.locationManager = nil
//            self.myMapView.showsUserLocation = false
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
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = false
            pinView!.animatesDrop = false
            pinView!.pinColor = .Purple
        }
        else {
            pinView!.annotation = annotation
        }
        
        let pointAnnatotion = annotation as! FuniPointAnnotation
        var imgName = "other_normal"
        if pointAnnatotion.rimLandInfoDomain != nil {
            if pointAnnatotion.rimLandInfoDomain?.dataType == 1 {
                //土地
                imgName = "Local_normal"
            }
        } else if pointAnnatotion.isUserLocation == true {
            imgName = "Fixed"
        } else {
            imgName = "Local_normal"
        }
        
        let imageView = UIImageView(image: UIImage(named: imgName))
        imageView.center = (pinView?.centerOffset)!
        imageView.y = imageView.y + 32
//            imageView.x = imageView.x + 30
        imageView.tag = 10
        
        pinView?.addSubview(imageView)
        pointAnnatotion.imageView = imageView
        
        return pinView
    }
    
    // 地图标注点击
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        
        if let annotation = view.annotation {
            if annotation is FuniPointAnnotation {
                let pointAnnatotion = annotation as! FuniPointAnnotation
                if pointAnnatotion.isUserLocation == false {
                    self.annoatationDetailsView.rimLandInfoDomain = pointAnnatotion.rimLandInfoDomain!
                    
                    let landInfoViewY: CGFloat = CGRectGetHeight(self.view.frame) - CGRectGetMaxY(self.landInfoView.frame)
                    
                    if landInfoViewY < 49 {
                        self.showLandInfo()
                    }
                    
                    if self.lastPointAnnotation != nil {
                        self.resetAnnotationImg(self.lastPointAnnotation, isSelected: false)
                    }
                    self.resetAnnotationImg(pointAnnatotion, isSelected: true)
                    self.lastPointAnnotation = pointAnnatotion
                }
            }
        }
    }
    
    // 在通过双指捏拢、放大、缩小地图的时候回调
    func mapView(mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        if self.timerRunning {
            self.searchConditionBtnClicked(self.searchBtn)
        }
        
        let landInfoViewY: CGFloat = CGRectGetHeight(self.view.frame) - CGRectGetMaxY(self.landInfoView.frame)
        
        if landInfoViewY >= 49 {
            self.showLandInfo()
        }
    }
}

// MARK: UISearchBarDelegate
extension MapViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        UIApplication.sharedApplication().sendAction("resignFirstResponder", to: nil, from: nil, forEvent: nil)
        if let searchKeyword = searchBar.text {
            self.isKeyword = true
            self.rimInfoReqDomain.keyword = searchKeyword
            self.queryData()
        } else {
            FuniHUD.sharedHud().show(self.view, onlyMsg: "请输入关键词!")
        }
        
    }
    
}

// MARK: View EventHandler
extension MapViewController {
    
    // 定位按钮点击
    @IBAction func userLocationBtnClicked(sender: AnyObject) {
        self.isKeyword = false
        if self.centerCoordinate == nil {
            self.isUserLocationSuccess = false
            self.startLocation()
            self.myMapView.showsUserLocation = true
        } else {
            //用户位置为地图中心点
            self.myMapView.setCenterCoordinate(self.centerCoordinate, zoomLevel: MAPZOOMLEVEL, animated: true)
            self.setUserLocationToReqParam()
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
            self.searchConditionContentView.view.size = CGSizeMake(300, 300)
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
        
        FuniCommon.asynExecuteCode(0.5) { () -> Void in
            if self.timerRunning == false {
                self.closeSearchConditionViewHandler()
            }
        }
    }
    
    // 列表显示数据
    @IBAction func showListBtnClicked(sender: AnyObject) {
        let rimLandListVC = self.storyboard?.instantiateViewControllerWithIdentifier("RimLandListViewController") as! RimLandListViewController
        rimLandListVC.rimInfoReqDomain = self.rimInfoReqDomain
        rimLandListVC.rimLandInfoArray = self.filterRimLandArray
        rimLandListVC.isShowRim        = !self.isShowRim
        self.navigationController?.pushViewController(rimLandListVC, animated: true)
    }
    
    // 土地类型按钮点击
    @IBAction func landTypeBtnClicked(sender: UIButton) {
        
        self.showRimLandType = sender.tag
        
        if self.showRimLandType == 1 {
            self.landType_LandBtn.selected = true
            self.landType_ProBtn.selected = false
        } else {
            self.landType_LandBtn.selected = false
            self.landType_ProBtn.selected = true
        }
        self.packagePointAnnatotion()
        self.appendUserLocation()
        self.myMapView.addAnnotations(self.pointAnnotationArray)
        self.keywordSearchDefFirstDataCenter()
    }
    
}

// MARK: Service Request And Data Package
extension MapViewController {
    
    //请求数据
    func requestData() {
        self.rimInfoReqDomain.keyword = self.searchBar.text
        FuniHUD.sharedHud().show(self.view)
        
        rimInfoReqDomain.lng = 104.078331
        rimInfoReqDomain.lat = 30.5464
        HttpService.sharedInstance.getRimInfoList(rimInfoReqDomain, success: { (rimInfoArray: Array<RimLandInfoDomain>) -> Void in
            
            self.rimLandArray = rimInfoArray
            self.packagePointAnnatotion()
            self.appendUserLocation()
            self.myMapView.addAnnotations(self.pointAnnotationArray)
            self.keywordSearchDefFirstDataCenter()
            self.navBarItemSetting()
            FuniHUD.sharedHud().hide(self.view)
            
            }) { (error:String) -> Void in
                self.appendUserLocation()
                FuniHUD.sharedHud().show(self.view, onlyMsg: error)
        }
    }
    
    //封装标注数据
    func packagePointAnnatotion() {
        
        self.myMapView.removeAnnotations(self.pointAnnotationArray)
        self.pointAnnotationArray.removeAll()
        
        if let rimArray = self.rimLandArray {
            
            var tempRimArray: Array<RimLandInfoDomain> = Array<RimLandInfoDomain>()
            
            tempRimArray.appendContentsOf(rimArray.filter({ (tempRimLandInfoDomain: RimLandInfoDomain) -> Bool in
                return tempRimLandInfoDomain.lng > 0 &&  tempRimLandInfoDomain.lng > 0
            }))
            
            self.rimLandInfoDataSecondFilter(tempRimArray)
        }
    }
    
    //数据釞第二次过滤
    func rimLandInfoDataSecondFilter(rimArray: Array<RimLandInfoDomain>) {
        var dataSource = rimArray
        if self.showRimLandType != 0 {
            dataSource = rimArray.filter({ (tempRimLandInfoDomain: RimLandInfoDomain) -> Bool in
                return tempRimLandInfoDomain.dataType == self.showRimLandType
            })
        }
        
        self.rimLandInfoDataThreeFilter(dataSource)
    }
    
    //数据三次过滤
    func rimLandInfoDataThreeFilter(rimArray: Array<RimLandInfoDomain>) {
        
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
        
        self.filterRimLandArray = tempRimArray
        
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
    
    //追加定位坐标
    func appendUserLocation() {
//        if (self.isHomeRim == true || self.isShowRim == false) && self.centerCoordinate != nil
//        {
//            let pointAnnatotion = FuniPointAnnotation()
//            pointAnnatotion.coordinate = CLLocationCoordinate2DMake(self.centerCoordinate.latitude - Number_Lat, self.centerCoordinate.longitude - Number_Lng)
//            pointAnnatotion.isUserLocation = true
//            self.pointAnnotationArray.append(pointAnnatotion)
//        }
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


