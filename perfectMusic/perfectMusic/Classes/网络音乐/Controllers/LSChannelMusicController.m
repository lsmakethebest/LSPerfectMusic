

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
    [self.tableView headerBeginRefreshing];
    
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
    [self getMusics];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [LSChannelMusicCell cellHeight];
}
-(void)getMusics
{
    
    [LSChannelTool getCHannelMusicWithChannelID:self.channel.tag_id Success:^(NSArray *array) {
        
        [self.tableView headerEndRefreshing];
        self.musics=array;
        
        [self.tableView reloadData];
    } failure:^(NSError *error) {
         NSLog(@"%@",error.localizedDescription);
        [self.tableView headerEndRefreshing];
    }];
   
    
}
@end
