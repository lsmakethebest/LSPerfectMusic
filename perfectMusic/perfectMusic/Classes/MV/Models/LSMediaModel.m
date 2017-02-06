

//
//  LSMediaModel.m
//  LSPlayer
//
//  Created by ls on 16/3/8.
//  Copyright © 2016年 song. All rights reserved.
//

#import "LSMediaModel.h"

@implementation LSMediaModel
-(instancetype)initWithDictionary:(NSDictionary *)dict
{
    LSMediaModel *model=[[LSMediaModel alloc]init];
    [model setValuesForKeysWithDictionary:dict];
    return model;
}
-(void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"description"]) {
        [self setValue:value forKey:@"myDescription"];
    }
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
}
@end
