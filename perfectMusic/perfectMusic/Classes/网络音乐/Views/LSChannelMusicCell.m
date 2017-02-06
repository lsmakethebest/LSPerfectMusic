//
//  LSChannelMusic.m
//  perfectMusic
//
//  Created by song on 15/10/16.
//  Copyright © 2015年 song. All rights reserved.
//

#import "LSChannelMusicCell.h"
#import "LSChannelMusic.h"
#import "UIImageView+WebCache.h"
#import "LSDownloadMusic.h"
#import "LSMusicModel.h"
@interface LSChannelMusicCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *musicName;
@property (weak, nonatomic) IBOutlet UILabel *sigerName;
- (IBAction)download:(UIButton *)sender;

@end
@implementation LSChannelMusicCell
+(instancetype)chanMusicCellWithTableView:(UITableView *)tableView
{
    LSChannelMusicCell *cell=[tableView dequeueReusableCellWithIdentifier:@"channelMusic"];
        cell.backgroundColor=[UIColor clearColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
+(CGFloat)cellHeight
{
    return 60;
}
-(void)setMusicModel:(LSMusicModel *)musicModel
{
    _musicModel=musicModel;
    self.musicName.text=musicModel.name;
    self.sigerName.text=musicModel.singer;
    [self.iconImageView setImageWithURL:[NSURL URLWithString:musicModel.albumPic] placeholderImage:[UIImage imageNamed:@"radarIcon2"]];
}

- (IBAction)download:(UIButton *)sender {
    
   LSDownloadMusic *task =[LSDownloadMusic downloadWithMusicModel:self.musicModel];
    task.state=LSDownloadMusicStateDownload;
    
    
}
@end
