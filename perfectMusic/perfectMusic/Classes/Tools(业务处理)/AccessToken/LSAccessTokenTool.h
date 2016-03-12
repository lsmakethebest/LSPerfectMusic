//
//  LSAccessTokenTool.h
//  perfectMusic
//
//  Created by song on 15/10/16.
//  Copyright © 2015年 song. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
@class LSDoubanAccount,LSDoubanUser;
@interface LSAccessTokenTool : NSObject
singalton_h(AccessTokenTool);
+(NSString*)codeWithURLString:(NSString *)urlString isVaild:(BOOL*)vaild;
+(void)accessTokenWithCode:code success:(void(^)(LSDoubanAccount *account))success failure:(void(^)(NSError*error))failure;
+(void)getCurentUserInfoSuccess:(void(^)(LSDoubanUser *user))success failure:(void(^)(NSError*error))failure;
+(void)saveAccessToken:(LSDoubanAccount*)account;
+(LSDoubanAccount*)account;
@end
