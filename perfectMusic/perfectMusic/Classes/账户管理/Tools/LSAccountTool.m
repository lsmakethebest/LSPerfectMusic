

//
//  LSAccountModelTool.m
//  perfectMusic
//
//  Created by song on 15/10/15.
//  Copyright © 2015年 song. All rights reserved.
//

#import "LSAccountTool.h"
#define LSAccountPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"account.data"]
@implementation LSAccountTool
singalton_m(AccountTool);
+(void)saveAccount:(LSAccount *)account
{
    NSData *data=[NSKeyedArchiver archivedDataWithRootObject:account];
    [data writeToFile:LSAccountPath atomically:YES];
    
}
+(LSAccount*)account
{
    LSAccount *account=[NSKeyedUnarchiver unarchiveObjectWithFile:LSAccountPath];
    return account;
}
@end
