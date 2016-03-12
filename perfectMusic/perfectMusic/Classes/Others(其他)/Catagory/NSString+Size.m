//
//  NSString+LSExt.m
//  QQ聊天界面
//
//  Created by song on 15/8/25.
//  Copyright © 2015年 song. All rights reserved.
//


@implementation NSString (Size)
-(CGSize)sizeOfTextWithMaxSize:(CGSize)maxSize font:(UIFont*)font
{
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
}
+(CGSize)sizeWithText:(NSString*)text maxSize:(CGSize)maxSize font:(UIFont*)font
{
    return [text sizeOfTextWithMaxSize:maxSize font:font];
}
@end
