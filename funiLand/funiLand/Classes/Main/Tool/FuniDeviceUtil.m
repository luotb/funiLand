//
//  FuniDeviceUtil.m
//  funiiPhoneApp
//
//  Created by You on 14-9-26.
//  Copyright (c) 2014年 LQ. All rights reserved.
//

#import "FuniDeviceUtil.h"
#import <sys/utsname.h>
#include <sys/sysctl.h>

@implementation FuniDeviceUtil

+ (NSString*)machineName
{
    struct utsname systemInfo;
    uname(&systemInfo);
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
 }

+ (NSString *)platform
{
    size_t size;
    sysctlbyname("hw.machine",NULL, &size, NULL,0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size,NULL, 0);
    NSString*platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    return platform;
}

@end
