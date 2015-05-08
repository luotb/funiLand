//
//  MKMapView+ZoomLevel.h
//  funiLand
//
//  Created by You on 15/5/8.
//  Copyright © 2015年 funi. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MKMapView (ZoomLevel)

- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel
                   animated:(BOOL)animated;

@end
