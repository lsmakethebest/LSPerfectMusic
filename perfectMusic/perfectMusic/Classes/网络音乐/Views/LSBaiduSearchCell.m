




//
//  LSBaiduSearchCell.m
//  perfectMusic
//
//  Created by song on 15/10/19.
//  Copyright © 2015年 song. All rights reserved.
//
#import "LSBaiduSearchCell.h"
#import "UIImageView+WebCache.h"
#import "LSDownloadMusic.h"
@interface LSBaiduSearchCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *singer;
- (IBAction)download:(id)sender;

@end

@implementation LSBaiduSearchCell
+(instancetype)baiduSearchCellWithTableView:(UITableView*)tableView;
{
    LSBaiduSearchCell *cell=[tableView dequeueReusableCellWithIdentifier:@"channelMusic"];
    if (cell==nil) {
        cell=[[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"channelMusic"];
        cell.backgroundColor=[UIColor clearColor];
    }
    return cell;
}
+(CGFloat)cellHeight
{
    return 60;
}

-(void)setMusicModel:(LSMusicModel *)musicModel
{
    _musicModel=musicModel;
    self.name.text=musicModel.name;
    self.singer.text=musicModel.singer;
    [self.iconImageView setImageWithURL:[NSURL URLWithString:musicModel.albumPic] placeholderImage:[UIImage imageNamed:@"radarIcon2"]];
}

- (IBAction)download:(UIButton *)sender {
    
    LSDownloadMusic *task =[LSDownloadMusic downloadWithMusicModel:self.musicModel];
    task.state=LSDownloadMusicStateDownload;
    
    
}

@end
