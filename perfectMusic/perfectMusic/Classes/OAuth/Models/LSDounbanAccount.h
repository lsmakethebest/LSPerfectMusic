//
//  LSDoubanAccount.h
//  至美微博
//
//  Created by song on 15/10/8.
//  Copyright © 2015年 song. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSDoubanAccount : NSObject<NSCoding>

/*
"access_token" = c98401d324664c015c8c05796d32e403;
"douban_user_id" = 135953029;
"douban_user_name" = lsmakethebest;
"expires_in" = 604800;
"refresh_token" = 05d0f6f8db210db11172e4ea91632913;
*/

/**
 *  获取数据的访问命令牌
 */
@property (nonatomic, copy) NSString *access_token;
/**
 *  账号的有效期
 */
@property (nonatomic, copy) NSString *expires_in;
/**
 *  用户唯一标识符
 */
@property (nonatomic, copy) NSString *douban_user_id;

/**
 *   过期时间 = 当前保存时间+有效期
 */
@property (nonatomic, strong) NSDate *expires_date;

/**
 *  刷新令牌
 */
@property (nonatomic, copy) NSString *refresh_token;
/**
 *  用户的昵称
 */
@property (nonatomic, copy) NSString *douban_user_name;



+ (instancetype)accountWithDict:(NSDictionary *)dict;

@end
