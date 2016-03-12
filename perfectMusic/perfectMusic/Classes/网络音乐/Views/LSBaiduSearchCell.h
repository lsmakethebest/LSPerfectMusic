//
//  LSBaiduSearchCell.h
//  perfectMusic
//
//  Created by song on 15/10/19.
//  Copyright © 2015年 song. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSMusicModel.h"
@interface LSBaiduSearchCell : UITableViewCell
@property (nonatomic, strong) LSMusicModel *musicModel;
+(instancetype)baiduSearchCellWithTableView:(UITableView*)tableView;
+(CGFloat)cellHeight;
@end
