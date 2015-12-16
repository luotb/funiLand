//
//  FuniPointAnnotation.swift
//  funiLand
//
//  Created by You on 15/12/4.
//  Copyright © 2015年 funi. All rights reserved.
//

import UIKit
import MapKit

class FuniPointAnnotation: MKPointAnnotation {

    var rimLandInfoDomain:RimLandInfoDomain?
    //是否是定位点
    var isUserLocation: Bool = false
    //标注点图片
    var imageView: UIImageView?
}
