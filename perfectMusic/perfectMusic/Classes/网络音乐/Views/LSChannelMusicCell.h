//
//  LSChannelMusic.h
//  perfectMusic
//
//  Created by song on 15/10/16.
//  Copyright © 2015年 song. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LSMusicModel;
@interface LSChannelMusicCell : UITableViewCell
@property (nonatomic, strong) LSMusicModel *musicModel;
+(instancetype)chanMusicCellWithTableView:(UITableView*)tableView;
+(CGFloat)cellHeight;
@end
