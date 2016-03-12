


//
//  LSDoubanAccountTool.m
//  JJFJ
//
//  Created by song on 15/10/8.
//  Copyright © 2015年 song. All rights reserved.
//

#import "LSDoubanAccountTool.h"
#import "LSDounbanAccount.h"
static LSDoubanAccount *account;
#define LSAccountFileName [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"account.data"]
@implementation LSDoubanAccountTool
//+(void)saveAccount:(LSDoubanAccount *)account
//{
//    
//    [NSKeyedArchiver archiveRootObject:account toFile:LSAccountFileName];
//    account=[NSKeyedUnarchiver unarchiveObjectWithFile:LSAccountFileName];
//
//    //    NSLog(@"%@",account.expires_in);
//}
//+(LSDoubanAccount*)account
//{
//    if(!account)
//    {
//        account=[NSKeyedUnarchiver unarchiveObjectWithFile:LSAccountFileName];
//        
//    }
//    if ([account.expires_date compare:[NSDate date]]!=NSOrderedDescending) {
//        return nil;
//    }
//    return account;
//}
@end
