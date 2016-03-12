

//
//  LSUserTool.m
//  至美微博
//
//  Created by song on 15/10/9.
//  Copyright © 2015年 ls. All rights reserved.
//

#import "LSUserTool.h"
#import "LSHttpTool.h"
#import "LSUserParam.h"
#import "LSAccountTool.h"
#import "LSAccount.h"
#import "MJExtension.h"
#define LSUserUrl @"http://api.douban.com/people/lamakethebest"
@implementation LSUserTool
+(void)userInfoWithSuccess:(void (^)(LSUser *))success failure:(void (^)(NSError *))failure
{

    LSUserParam *param=[LSUserParam param];
    param.uid=[LSAccountTool account].uid;
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    params[@"access_token"]=[LSAccountTool account].access_token;
    params[@"uid"]=[LSAccountTool account].uid;
    [LSHttpTool GET:LSUserUrl parameters:params success:^(id responseObject) {
        if (success) {
            NSLog(@"%@",responseObject);
    
            LSUser *user=[LSUser objectWithKeyValues:responseObject];
            success(user);
        }
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
    }];
}
@end
