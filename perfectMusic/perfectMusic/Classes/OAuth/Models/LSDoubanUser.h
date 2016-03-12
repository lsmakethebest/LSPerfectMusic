//
//  LSDoubanUser.h
//  perfectMusic
//
//  Created by song on 15/10/16.
//  Copyright © 2015年 song. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSDoubanUser : NSObject
/*
alt = "http://www.douban.com/people/itbighome/";
avatar = "http://img3.douban.com/icon/user_normal.jpg";
created = "2015-10-12 23:37:24";
desc = "";
id = 135953029;
"is_banned" = 0;
"is_suicide" = 0;
"large_avatar" = "http://img3.douban.com/icon/user_large.jpg";
name = lsmakethebest;
signature = "";
type = user;
uid = itbighome;
 */

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *large_avatar;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *alt;
@property (nonatomic, copy) NSString *created;
@end
