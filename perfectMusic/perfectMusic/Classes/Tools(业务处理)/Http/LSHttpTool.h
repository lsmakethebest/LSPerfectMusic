//
//  LSHttpTool.h
//  至美微博
//
//  Created by song on 15/10/9.
//  Copyright © 2015年 ls. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSHttpTool : NSObject
+(void)GET:(NSString *)URLString parameters:(id)parameters success:(void (^)( id responseObject))success failure:(void (^)(NSError *error))failure;
+(void)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObject))success
    failure:(void (^)( NSError *error))failure;
@end
