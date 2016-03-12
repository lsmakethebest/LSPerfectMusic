//
//  LSUserTool.h
//  至美微博
//
//  Created by song on 15/10/9.
//  Copyright © 2015年 ls. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "LSUser.h"
@interface LSUserTool : NSObject
+(void)userInfoWithSuccess:(void (^)(LSUser *user))success failure:(void (^)(NSError *error)) failure;

@end
