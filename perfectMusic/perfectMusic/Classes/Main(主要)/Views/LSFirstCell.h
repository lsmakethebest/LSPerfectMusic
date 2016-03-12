//
//  LSFirstCell.h
//  perfectMusic
//
//  Created by song on 15/10/13.
//  Copyright © 2015年 song. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSFirstCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *contentDict;
+(instancetype)firstCell:(UITableView*)tableView;
+(CGFloat)cellHeight;
@end
