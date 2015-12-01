//
//  MapViewController.swift
//  funiLand
//
//  Created by You on 15/11/23.
//  Copyright © 2015年 funi. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    
    @IBOutlet var myMapView: MKMapView!
    var locationManager:CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myMapView.delegate = self
        myMapView.mapType = MKMapType.Standard
        myMapView.showsUserLocation = true
        
        startLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK - CLLocationManagerDelegate
    
    func startLocation() {
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        self.locationManager.startUpdatingLocation()
    }
    
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
            
        case CLAuthorizationStatus.Denied : // kCLAuthorizationStatusDenied:
            UIAlertView().alertViewWithTitle("请在设置-隐私-定位服务中开启定位功能!")
            break
            
        case CLAuthorizationStatus.Restricted :  // kCLAuthorizationStatusRestricted:
            UIAlertView().alertViewWithTitle("定位服务无法使用!")
            break
        default:
             self.locationManager.startUpdatingLocation()
//            if #available(iOS 8.0, *) {
//                self.locationManager.requestWhenInUseAuthorization()
//                self.locationManager.requestAlwaysAuthorization()
//            } else {
//                // Fallback on earlier versions
//            }
            break;
        }
    }
    
    // MARK: mapView delegate
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        //点击大头针，会出现以下信息
        userLocation.title = "中国";
        userLocation.subtitle = "四大文明古国之一";
        
        //让地图显示用户的位置（iOS8一打开地图会默认转到用户所在位置的地图），该方法不能设置地图精度
        //    [mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
        
        //这个方法可以设置地图精度以及显示用户所在位置的地图
        let span = MKCoordinateSpanMake(0.1, 0.1);
        let region = MKCoordinateRegionMake(userLocation.location!.coordinate, span);
        mapView.setRegion(region, animated: true)
    }
    
    //可以打印经纬度的跨度，用来测试当前视图下地经纬度跨度是多少，然后用于上面的MKCoordinateSpanMake方法中
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print("\(mapView.region.span.latitudeDelta, mapView.region.span.longitudeDelta)")
    }

}
