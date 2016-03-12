//
//  LSChannelCell.h
//  perfectMusic
//
//  Created by song on 15/10/17.
//  Copyright © 2015年 song. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LSChannel;
@interface LSChannelCell : UITableViewCell
@property (nonatomic, strong) LSChannel *channel;
+(instancetype)channelCellWithTableView:(UITableView *)tableView;
@end
