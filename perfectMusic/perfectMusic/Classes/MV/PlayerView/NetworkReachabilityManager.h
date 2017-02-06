//
//  NetworkReachabilityManager.h
//  LSPlayer
//
//  Created by ls on 16/3/18.
//  Copyright © 2016年 song. All rights reserved.
//

#import <Foundation/Foundation.h>
extern  NSString * const LSNetworkChangeNotification;
typedef NS_ENUM(NSInteger,NET_TYPE) {
    NotReachable=0,
    WiFi,
    WWAN,
};
@interface NetworkReachabilityManager : NSObject
+ (instancetype)sharedInstance;
- (void)startMonitoring;
//获取当前网络类型
@property (nonatomic, readonly,assign)NET_TYPE netType;
@end
