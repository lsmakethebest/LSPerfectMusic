//
//  UIImage+Image.h
//  至美微博
//
//  Created by ls on 15/10/4.
//  Copyright © 2015年 ls. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Image)
// 加载最原始的图片，没有渲染
+ (instancetype)imageWithOriginalName:(NSString *)imageName;
//图片拉伸
+ (instancetype)imageWithStretchableName:(NSString *)imageName;

@end
