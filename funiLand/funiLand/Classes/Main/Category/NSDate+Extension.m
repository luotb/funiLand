//
//  NSDate+Extension.m
//  funiLand
//
//  Created by You on 15/11/19.
//  Copyright © 2015年 funi. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)

+ (NSString *)getTime{
    // 获取系统当前时间
    NSDate * date = [NSDate date];
    NSTimeInterval sec = [date timeIntervalSinceNow];
    NSDate * currentDate = [[NSDate alloc] initWithTimeIntervalSinceNow:sec];
    
    //设置时间输出格式：
    NSDateFormatter * df = [[NSDateFormatter alloc] init ];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * na = [df stringFromDate:currentDate];
    
    return na;
}


//毫秒时间
+ (NSString *)millisecond
{
    NSTimeInterval time=[[NSDate date] timeIntervalSince1970]*1000;
    NSInteger i=time;      //NSTimeInterval返回的是double类型
    return [NSString stringWithFormat:@"%ld",(long)i];
}

//当前时间
+ (NSString *)presentTime
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"YYYYMMddhhmmss"];
    NSString *date =  [formatter stringFromDate:[NSDate date]];
    NSString *timeLocal = [[NSString alloc] initWithFormat:@"%@", date];
    return timeLocal;
}

/**
 * 计算指定时间是否大雨指定分钟数
 */
+(BOOL)isReload:(NSDate *)compareDate loadTime:(NSInteger)loadTime{
    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    BOOL  result = NO;
    if(timeInterval > loadTime*60){
        result = YES;
    }
    return  result;
}

@end
