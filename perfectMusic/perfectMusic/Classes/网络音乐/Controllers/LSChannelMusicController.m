

//
//  LSChannelMusicController.m
//  perfectMusic
//
//  Created by song on 15/10/17.
//  Copyright © 2015年 song. All rights reserved.
//

#import "LSChannelMusicController.h"
#import "LSChannel.h"
#import "LSChannelTool.h"
#import "LSChannelMusicCell.h"
#import "MJRefresh.h"
#import "LSMusicModel.h"
@interface LSChannelMusicController ()
@property (nonatomic, strong) NSMutableArray *tmpMusic;
@property (nonatomic, strong) NSMutableArray *musics;
@end

@implementation LSChannelMusicController
-(NSMutableArray *)musics
{
    if (_musics==nil) {
        _musics=[NSMutableArray array];
    }
    return _musics;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView addHeaderWithTarget:self action:@selector(refresh)];
    [self setupNavigationBar];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.musics.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSChannelMusicCell *cell=[LSChannelMusicCell chanMusicCellWithTableView:tableView];
    cell.musicModel=self.musics[indexPath.row];
    return cell;
}
-(void)setupNavigationBar
{
    self.navigationController.navigationBar.hidden=NO;
    self.title=@"电台歌曲";
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
}
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)refresh
{
    self.tmpMusic=[NSMutableArray array];
    [self getMusics];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [LSChannelMusicCell cellHeight];
}
-(void)getMusics
{
    
    [LSChannelTool getCHannelMusicWithChannelID:self.channel.channel_id Success:^(NSArray *array) {
        for (LSMusicModel *music1 in array) {
            BOOL v=YES;
            for (LSMusicModel *music2 in self.tmpMusic)
            {
                if ([music1.singer isEqual:music2.singer ]&&[music1.name isEqual:music2.name])
                {
                    v=NO;
                }
            }
            if (v) {
                [self.tmpMusic addObject:music1];
            }
            if (self.tmpMusic.count==10) {
                self.musics=self.tmpMusic;
                [self.tableView headerEndRefreshing];
                [self.tableView reloadData];
            }
   
        }
         [self getMusics];
        
    } failure:^(NSError *error) {
         NSLog(@"%@",error.localizedDescription);
        [self.tableView headerEndRefreshing];
    }];
   
    
}
@end
