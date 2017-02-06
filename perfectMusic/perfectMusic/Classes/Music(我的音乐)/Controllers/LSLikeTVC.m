





//
//  LSLikeTVC.m
//  perfectMusic
//
//  Created by song on 15/10/23.
//  Copyright © 2015年 song. All rights reserved.
//

#import "LSLikeTVC.h"
#import "LSMusicList.h"
#import "LSMusicModel.h"
#import "LSMyMusicCell.h"
#import "LSPlayQueue.h"
@interface LSLikeTVC ()
@property (nonatomic, strong) LSMusicList *tool;

@end

@implementation LSLikeTVC
-(LSMusicList *)tool
{
    if (_tool==nil) {
        _tool=[LSMusicList musicList];
    }
    return _tool;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"我喜欢";
    self.datas =[self.tool getAllLikeMusic];
}

-(void)remove
{
    LSMusicModel *model=self.selectModel;
    model.like=NO;
    [[LSMusicList musicList] updateMusic:model];
    self.datas =[[self.tool getAllLikeMusic] mutableCopy];
    [self.tableView reloadData];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    LSMusicModel *model=self.datas[self.tableView.indexPathForSelectedRow.row];
    [[LSPlayQueue sharedPlayQueue] setPlayQueue:LSAllLikeList currentIndex:model orIndex:indexPath.row];
}
@end
