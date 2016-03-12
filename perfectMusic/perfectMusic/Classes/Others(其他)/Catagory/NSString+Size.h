//
//  NSString+LSExt.h
//
//  Created by song on 15/8/25.
//  Copyright © 2015年 song. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (Size)
-(CGSize)sizeOfTextWithMaxSize:(CGSize)maxSize font:(UIFont*)font;
+(CGSize)sizeWithText:(NSString*)text maxSize:(CGSize)maxSize font:(UIFont*)font;
@end
