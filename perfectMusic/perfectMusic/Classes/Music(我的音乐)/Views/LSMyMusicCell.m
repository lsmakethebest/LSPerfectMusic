



//
//  LSMyMusicCell.m
//  perfectMusic
//
//  Created by song on 15/10/20.
//  Copyright © 2015年 song. All rights reserved.
//

#import "LSMyMusicCell.h"
#import "LSMusicModel.h"
#import "LSMusicList.h"
#import "LSMusicPlayerTool.h"
@interface LSMyMusicCell ()<UIGestureRecognizerDelegate>




- (IBAction)likeClick:(UIButton *)sender;
- (IBAction)infoClick:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UILabel *songSinger;
@property (weak, nonatomic) IBOutlet UILabel *songName;


@end
@implementation LSMyMusicCell

+(instancetype)myMusicCellWithTableView:(UITableView *)tableView
{
    LSMyMusicCell *cell=[tableView dequeueReusableCellWithIdentifier:@"myMusic"];
    if (cell==nil) {
        cell.backgroundColor=[UIColor clearColor];
        cell=[[[NSBundle mainBundle]loadNibNamed:@"MyMusic" owner:nil options:nil]lastObject];
//        UIView *view=[[UIView alloc]init];

//        view.backgroundColor=[UIColor colorWithWhite:0.8 alpha:0.5];
        cell.selectionStyle=UITableViewCellSelectionStyleDefault;
    }
    return cell;
}

- (IBAction)likeClick:(UIButton *)sender
{
    sender.selected=!sender.isSelected;
    self.musicModel.like=sender.isSelected;
    [[LSMusicList musicList] updateMusic:self.musicModel];
    
}
- (IBAction)infoClick:(UIButton *)sender {
}
+(CGFloat)cellHeight
{
    return 50;
}
-(void)setMusicModel:(LSMusicModel *)musicModel
{
    _musicModel=musicModel;
    self.likeBtn.selected=musicModel.like;
    self.songSinger.text=musicModel.singer;
    self.songName.text=musicModel.name;
}

@end
