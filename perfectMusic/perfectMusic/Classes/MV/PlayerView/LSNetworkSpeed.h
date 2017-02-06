
//
//  LSNetworkSpeed.h
//  LSPlayer
//
//  Created by ls on 16/3/18.
//  Copyright © 2016年 song. All rights reserved.
//

#import <Foundation/Foundation.h>

// 88kB/s
extern NSString *const LSDownloadNetworkSpeedNotificationKey;

// 2MB/s
extern NSString *const LSUploadNetworkSpeedNotificationKey;

@interface LSNetworkSpeed : NSObject

@property (nonatomic, copy, readonly) NSString * downloadNetworkSpeed;
@property (nonatomic, copy, readonly) NSString * uploadNetworkSpeed;

+ (instancetype)shareNetworkSpeed;

- (void)start;
- (void)stop;

@end




