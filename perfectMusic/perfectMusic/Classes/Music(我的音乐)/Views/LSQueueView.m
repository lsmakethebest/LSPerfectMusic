


//
//  LSQueueView.m
//  perfectMusic
//
//  Created by song on 15/10/26.
//  Copyright © 2015年 song. All rights reserved.
//

#import "LSQueueView.h"
#import "LSPlayQueue.h"
#import "LSMusicPlayerTool.h"
#import "LSMusicModel.h"
#import "LSMusicList.h"
@interface LSQueueView ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *listView;
- (IBAction)sortClick:(UIButton*)sender;
@property (weak, nonatomic) IBOutlet UIButton *sortButton;

@end
@implementation LSQueueView
+(instancetype)queueView
{
    LSQueueView *queueView=[[[NSBundle mainBundle]loadNibNamed:@"LSQueueView" owner:nil options:nil]lastObject];

    return queueView;
}
-(void)awakeFromNib
{
    self.listView.dataSource=self;
    self.listView.delegate=self;
    [self addTarget:self action:@selector(myClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    //监听播放歌曲下标改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(indexChange:) name:LSPlayQueueChangeIndexNotification object:nil];
    
    //监听播放队列顺序改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queueModeChange:) name:LSPlayQueueChangeModeNotification object:nil];
    NSNotification *note=[NSNotification notificationWithName:LSPlayQueueChangeModeNotification object:nil userInfo:@{LSPlayQueueChangeModeNotificationKey:@([LSPlayQueue sharedPlayQueue].mode)}];
    [self  queueModeChange:note];
}
-(void)queueModeChange:(NSNotification*)note
{
    NSNumber *number=note.userInfo[LSPlayQueueChangeModeNotificationKey];
    LSPlayQueueMode mode=(LSPlayQueueMode)number.intValue;
    switch (mode) {
        case LSPlayQueueModeCycle:
            [self.sortButton setImage:[UIImage imageNamed:@"playmode_cycle"] forState:UIControlStateNormal];
            [self.sortButton setTitle:@"顺序播放" forState:UIControlStateNormal];
            break;
        case LSPlayQueueModeRandom:
            [self.sortButton setImage:[UIImage imageNamed:@"playmode_random"] forState:UIControlStateNormal];
            [self.sortButton setTitle:@"随机播放" forState:UIControlStateNormal];
            break;
        case LSPlayQueueModeSingleCycle:
            [self.sortButton setImage:[UIImage imageNamed:@"playmode_single cycle"] forState:UIControlStateNormal];
            [self.sortButton setTitle:@"单曲循环" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

-(void)indexChange:(NSNotification*)note
{
    NSNumber *number=note.userInfo[LSPlayQueueChangeIndexNotificationKey];
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:number.intValue inSection:0];
    [self.listView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle] ;
    
}
-(void)reloadTableView
{
    if ([LSPlayQueue sharedPlayQueue].queue!=nil&&[LSPlayQueue sharedPlayQueue].queue.count!=0) {
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:[LSPlayQueue sharedPlayQueue].currentIndex inSection:0];
        [self.listView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle] ;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return     [LSPlayQueue sharedPlayQueue].queue.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, LSScreenWidth, 100)];
        view.backgroundColor=[UIColor colorWithWhite:0.5 alpha:0.5];
        cell.selectedBackgroundView=view;
    }
    LSMusicModel *model=[LSPlayQueue sharedPlayQueue].queue[indexPath.row];
    cell.textLabel.text=model.name;
    cell.detailTextLabel.text=model.singer;
    ;
    
    return cell;
}
- (IBAction)sortClick:(id)sender {
    [[LSPlayQueue sharedPlayQueue] updatePlayMode];
}
-(void)myClick
{
    if ([self.delegate respondsToSelector:@selector(queueViewClick:)]) {
        [self.delegate queueViewClick:self];
    }
    [self dismiss];
}
-(void)dismiss
{
    
    self.backgroundColor=[UIColor clearColor];
    [UIView animateWithDuration:0.3 animations:^{
        self.transform=CGAffineTransformMakeTranslation(0, LSScreenHeight);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSMusicModel *model=[LSPlayQueue sharedPlayQueue].queue[indexPath.row];
    [[LSMusicPlayerTool sharedMusicPlayerTool] playWithModel:model];
    [[LSPlayQueue sharedPlayQueue] setPlayQueue:[LSPlayQueue sharedPlayQueue].listName currentIndex:model orIndex:indexPath.row];
}

@end
