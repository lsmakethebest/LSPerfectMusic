//
//  LSAccountTool.h
//  perfectMusic
//
//  Created by song on 15/10/15.
//  Copyright © 2015年 song. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LSAccount;
#import "Singleton.h"
@interface LSAccountTool : NSObject
@property (nonatomic, strong) LSAccount *account;
singalton_h(AccountTool);
+(void)saveAccount:(LSAccount*)account;
+(LSAccount*)account;
@end
