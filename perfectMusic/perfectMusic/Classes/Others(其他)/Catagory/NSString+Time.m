


//
//  NSString+Time.m
//  至美微博
//
//  Created by song on 15/10/12.
//  Copyright © 2015年 ls. All rights reserved.
//

#import "NSString+Time.h"
#import "NSDate+MJ.h"
@implementation NSString (Time)
+(NSString *)getTimeWithString:(NSString*)time
{
    return   [time getTime];
}
-(NSString *)getTime
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    formatter.dateFormat=@"EEE MMM d HH:mm:ss Z yyyy";
    [formatter setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"en_US" ] ];
    NSDate *  created_at=[formatter dateFromString:self];
    
    //是今年
    if ([created_at isThisYear]) {
        //是今天
        if ([created_at isToday]) {
            
            NSDateComponents *date=[created_at deltaWithNow];
            if (date.hour>=1) {
                return [NSString stringWithFormat:@"%ld小时前",(long)date.hour];
            }
            else if(date.minute>1){
                return [NSString stringWithFormat:@"%ld分钟前",(long)date.minute];
            }
            else{
                return @"刚刚";
            }
            
        }
        //是昨天
        else if ([created_at isYesterday]){
            
            formatter.dateFormat=@"昨天 HH:mm";
            return [formatter stringFromDate:created_at];
        }
        else {
            formatter.dateFormat=@"MM-dd HH:mm";
            return [formatter stringFromDate:created_at];
        }
    }
    //不是今年
    else
    {
        formatter.dateFormat=@"yyyy-MM-dd HH:mm";
        return [formatter stringFromDate:created_at];
    }
    return self;
    
}
-(NSString*)getDetailTime
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    formatter.dateFormat=@"EEE MMM d HH:mm:ss Z yyyy";
    [formatter setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"en_US" ] ];
    NSDate *  created_at=[formatter dateFromString:self];
    
    //是今年
    if ([created_at isThisYear]) {
        
        formatter.dateFormat=@"MM-dd HH:mm";
        return [formatter stringFromDate:created_at];
        }
    //不是今年
    else
    {
        formatter.dateFormat=@"yyyy-MM-dd HH:mm";
        return [formatter stringFromDate:created_at];
    }
    return self;

}
+(NSString*)getDetailTimeWithString:(NSString*)time
{
    return [time getDetailTime];
}
@end
