//
//  LSMyMusicCell.h
//  perfectMusic
//
//  Created by song on 15/10/20.
//  Copyright © 2015年 song. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LSMusicModel;
@interface LSMyMusicCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *myView;

+(instancetype)myMusicCellWithTableView:(UITableView*)tableView;
+(CGFloat)cellHeight;

@property (nonatomic, strong) LSMusicModel *musicModel;
@end
