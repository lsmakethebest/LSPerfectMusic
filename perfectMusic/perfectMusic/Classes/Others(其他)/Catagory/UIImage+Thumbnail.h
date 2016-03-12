//
//  UIImage+Thumbnail.h
//  至美微博
//
//  Created by song on 15/10/10.
//  Copyright © 2015年 ls. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Thumbnail)
//自动缩放到指定大小

+ (UIImage *)thumbnailWithImage:(UIImage *)image size:(CGSize)asize;
//保持原来的长宽比，生成一个缩略图

+ (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize;
@end
