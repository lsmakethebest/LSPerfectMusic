//
//  LSNewFeatureCell.h
//  至美微博
//
//  Created by song on 15/10/13.
//  Copyright © 2015年 ls. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSNewFeatureCell : UICollectionViewCell
@property (nonatomic, strong) UIImage *image;
- (void)setIndexPath:(NSIndexPath *)indexPath count:(int)count;
@end
