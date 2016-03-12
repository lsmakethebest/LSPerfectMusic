//
//  LSDoubanAccountTool.h
//  至美微博
//
//  Created by song on 15/10/8.
//  Copyright © 2015年 song. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LSDoubanAccount;
@interface LSDoubanAccountTool : NSObject
+(void)saveAccount:(LSDoubanAccount*)account;
+(LSDoubanAccount*)account;
@end
