//
//  NSString+Time.h
//  至美微博
//
//  Created by song on 15/10/12.
//  Copyright © 2015年 ls. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Time)

//获取距离离当前时间
+(NSString *)getTimeWithString:(NSString*)_created_at;
-(NSString *)getTime;

//获取具体时间
+(NSString*)getDetailTimeWithString:(NSString*)time;
-(NSString*)getDetailTime;

@end
