

//
//  LSMyMusicController.m
//  perfectMusic
//
//  Created by song on 15/10/14.
//  Copyright © 2015年 song. All rights reserved.
//

#import "LSMyMusicController.h"
#import <AVFoundation/AVFoundation.h>
#import "MJExtension.h"
#import "LSMusicModel.h"
#import "LSMusicList.h"
#import "LSMyMusicCell.h"
#import "LSMusicPlayerTool.h"
#import "LSPlayQueue.h"
@interface LSMyMusicController ()

@end

@implementation LSMyMusicController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"本地音乐";
    self.datas=[[LSMusicList musicList]getAllMusic];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.navigationController.navigationBar.hidden=NO;
    });
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)remove
{
    LSMusicModel *model=self.selectModel;
    [[LSMusicList musicList] delLocalMusic:model];
    self.datas=self.datas=[[LSMusicList musicList]getAllMusic];
    [self.tableView reloadData];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    LSMusicModel *model=self.datas[self.tableView.indexPathForSelectedRow.row];
    [[LSPlayQueue sharedPlayQueue] setPlayQueue:LSAllLocalList currentIndex:model orIndex:0];
}
@end
