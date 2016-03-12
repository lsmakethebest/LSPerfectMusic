//
//  LSAccountModel.m
//  perfectMusic
//
//  Created by song on 15/10/15.
//  Copyright © 2015年 song. All rights reserved.
//

#import "LSAccount.h"
#define LSLoginName @"loginName"
#define LSNickName @"nickName"
#define LSIconURL @"iconURL"
#define LSDoubanID @"doubanID"
@implementation LSAccount
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{

    if (self=[super init]) {
        _loginName=[aDecoder decodeObjectForKey:LSLoginName];
        _nickName=[aDecoder decodeObjectForKey:LSNickName];
        _iconURL=[aDecoder decodeObjectForKey:LSIconURL];
        _doubanID=[aDecoder decodeObjectForKey: LSDoubanID];
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject: _loginName forKey:LSLoginName];
    [aCoder encodeObject:_nickName  forKey:LSNickName];
    [aCoder encodeObject:_iconURL forKey:LSIconURL];
    [aCoder encodeObject: _doubanID forKey:LSDoubanID];

    
}

@end
