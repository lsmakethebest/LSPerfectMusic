




//
//  LSAccessTokenTool.m
//  perfectMusic
//
//  Created by song on 15/10/16.
//  Copyright © 2015年 song. All rights reserved.
//

#import "LSAccessTokenTool.h"
#import "LSHttpTool.h"
#import "LSDounbanAccount.h"
#import "AFNetworking.h"
#import "LSDoubanUser.h"
#define LSBaseUrl @"https://www.douban.com/service/auth2/auth"
#define LSClient_id @"0105595a51ceb79203100c0ef56c26b6"
#define LSRedirect_uri @"http://www.douban.com/people/itbighome/"
#define LSClient_Secret @"90e4a35ba5cbc14f"
#define LSAcceessTokenUrl @"https://www.douban.com/service/auth2/token"
#import "MJExtension.h"


#define LSAccessTokenPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"doubanAccount.data"]
#import "LSChooseRootController.h"
@implementation LSAccessTokenTool
singalton_m(AccessTokenTool);
+(NSString*)codeWithURLString:(NSString *)urlString isVaild:(BOOL*)vaild
{
    
    NSRange range=NSMakeRange(0, LSRedirect_uri.length);
    if (![[urlString substringWithRange:range] isEqualToString:LSRedirect_uri]) {
        
        *vaild = NO;
        return nil;
        
    }
    *vaild = YES;
    
    range=[urlString rangeOfString:@"code="];
    if (range.length>0) {
        NSString *code=[urlString substringFromIndex:range.location+range.length];
        
        return code;
    }
    else{
        return nil;
    }
    
}
+(void)accessTokenWithCode:code success:(void(^)(LSDoubanAccount *account))success failure:(void(^)(NSError*error))failure;
{
    //根据code获取accessToken
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    params[@"client_id"]=LSClient_id;
    params[@"client_secret"]=LSClient_Secret;
    params[@"grant_type"]=@"authorization_code";
    params[@"code"]=code;
    params[@"redirect_uri"]=LSRedirect_uri;
    [LSHttpTool POST:LSAcceessTokenUrl parameters:params success:^(id responseObject) {
        
        NSDictionary *dict=(NSDictionary *)responseObject;
        NSLog(@"%@",dict);
        LSDoubanAccount *account=[LSDoubanAccount accountWithDict:dict];
        if (success) {
            success(account);
            //            NSLog(@"id=====%@",account.douban_user_id);
            
            //保存accessToken到本地
            [LSAccessTokenTool saveAccessToken:account];
            
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
        NSLog(@"%@",error);
    }];
}
+(void)saveAccessToken:(LSDoubanAccount*)account
{
    NSData *data =[NSKeyedArchiver archivedDataWithRootObject:account];
    [data writeToFile:LSAccessTokenPath atomically:YES];
}
+(LSDoubanAccount*)account
{
    LSDoubanAccount *account=[NSKeyedUnarchiver unarchiveObjectWithFile:LSAccessTokenPath];
    return account;
}

+(void)getCurentUserInfoSuccess:(void(^)(LSDoubanUser *user))success failure:(void(^)(NSError*error))failure
{
    //   https://api.douban.com/v2/user/~me" -H "Authorization: Bearer a14afef0f66fcffce3e0fcd2e34f6ff4"
    AFHTTPRequestOperationManager *manger=[AFHTTPRequestOperationManager manager];
    [manger.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",[self account].access_token] forHTTPHeaderField:@"Authorization"];
    [manger GET:@"https://api.douban.com/v2/user/~me" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        LSDoubanUser *user=[LSDoubanUser objectWithKeyValues:responseObject];
        if (success) {
            success(user);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
    
}
@end
