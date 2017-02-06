//
//  NetworkReachabilityManager.m
//  LSPlayer
//
//  Created by ls on 16/3/18.
//  Copyright © 2016年 song. All rights reserved.
//
#import "NetworkReachabilityManager.h"
#import "AFNetworkReachabilityManager.h"
 NSString *const LSNetworkChangeNotification=@"LSNetworkChangeNotification";
@interface NetworkReachabilityManager()

@end

static id instance;
@implementation NetworkReachabilityManager

+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       instance=[[self alloc]init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
  
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        instance = [super allocWithZone:zone];
    });
    
    return instance;
}

#pragma mark - 监听网络变化
- (void)startMonitoring{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
                _netType=NotReachable;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                _netType=WiFi;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                _netType=WWAN;
                break;
            default:
                break;
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:LSNetworkChangeNotification object:@(_netType)];
    }];
}
@end
