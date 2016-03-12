//
//  LSDownloadMangerCell.h
//  perfectMusic
//
//  Created by song on 15/10/20.
//  Copyright © 2015年 song. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LSDownloadMusic;
@interface LSDownloadMangerCell : UITableViewCell
@property (nonatomic, strong) LSDownloadMusic *downloader;
+(instancetype)downloadMangerCell:(UITableView*)tableView;
+(CGFloat)cellHeight;
@end
