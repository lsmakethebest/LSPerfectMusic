
//
//  UIImage+Image.m
//  至美微博
//
//  Created by ls on 15/10/4.
//  Copyright © 2015年 ls. All rights reserved.
//

#import "UIImage+Image.h"

@implementation UIImage (Image)
+ (instancetype)imageWithOriginalName:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

+ (instancetype)imageWithStretchableName:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    return [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
}

@end
