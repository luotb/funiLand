//
//  NSDate+Extension.h
//  funiLand
//
//  Created by You on 15/11/19.
//  Copyright © 2015年 funi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)

+ (NSString *)getTime;

//毫秒时间
+ (NSString *)millisecond;

//当前时间
+ (NSString *)presentTime;

/**
 * 计算指定时间是否大雨指定分钟数
 */
+(BOOL)isReload:(NSDate*)compareDate loadTime:(NSInteger)loadTime;

@end
