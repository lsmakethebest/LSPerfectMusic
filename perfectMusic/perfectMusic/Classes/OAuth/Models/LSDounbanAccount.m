







//
//  LSAccount.m
//
//  Created by song on 15/10/8.
//  Copyright © 2015年 song. All rights reserved.
//

#import "LSDounbanAccount.h"
#define LSAccountTokenKey @"access_token"
#define LSUidKey @"douban_user_id"
#define LSExpires_inKey @"expires_in"
#define LSExpires_dateKey @"expires_date"
#define LSNameKey @"douban_user_name"
#define LSRefreshTokenKey @"refresh_token"

@implementation LSDoubanAccount
+(instancetype)accountWithDict:(NSDictionary *)dict
{
    LSDoubanAccount *account=[[self alloc]init];
    [account setValuesForKeysWithDictionary:dict];
    return account;
}
-(void)setExpires_in:(NSString *)expires_in
{
    _expires_in=expires_in;
    _expires_date=[NSDate dateWithTimeIntervalSinceNow:[_expires_in longLongValue]];
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super init]) {
        _access_token=[aDecoder decodeObjectForKey:LSAccountTokenKey];
        _douban_user_id=[aDecoder decodeObjectForKey:LSUidKey];
        _expires_in=[aDecoder decodeObjectForKey:LSExpires_inKey];
        _douban_user_name=[aDecoder decodeObjectForKey: LSNameKey];
        _expires_date=[aDecoder decodeObjectForKey:LSExpires_dateKey];
        _refresh_token=[aDecoder decodeObjectForKey:LSRefreshTokenKey];
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_access_token forKey:LSAccountTokenKey];
    [aCoder encodeObject:_douban_user_id  forKey:LSUidKey];
    [aCoder encodeObject:_expires_in forKey:LSExpires_inKey];
    [aCoder encodeObject:_douban_user_name forKey:LSNameKey];
    [aCoder encodeObject:_expires_date forKey:LSExpires_dateKey];
    [aCoder encodeObject:_refresh_token forKey:LSRefreshTokenKey];
    
}

@end
