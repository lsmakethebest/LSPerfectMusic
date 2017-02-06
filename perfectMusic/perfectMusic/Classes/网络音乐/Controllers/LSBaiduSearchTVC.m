


//
//  LSBaiduSearchTVC.m
//  perfectMusic
//
//  Created by song on 15/10/19.
//  Copyright © 2015年 song. All rights reserved.
//

#import "LSBaiduSearchTVC.h"
#import "LSBaiduSearchCell.h"
#import "AFNetworking.h"
#import "LSDownloadMusic.h"
#import "LSMusicModel.h"
#import "LSFMDBTool.h"
@interface LSBaiduSearchTVC ()<UISearchBarDelegate>
@property (nonatomic, strong) NSMutableArray *musics;
@end

@implementation LSBaiduSearchTVC

-(NSMutableArray *)musics
{
    if (_musics==nil) {
        _musics=[NSMutableArray array];
        
    }
    return _musics;
}
- (void)viewDidLoad {

    [super viewDidLoad];
    self.title=@"歌曲搜索";
    UISearchBar *searchBar=[[UISearchBar alloc]init];
    searchBar.frame=CGRectMake(0, 0, 100, 40);
    searchBar.delegate=self;
    self.navigationItem.titleView=searchBar;
//    LSMusicModel *model=[[LSMusicModel alloc]init];
//    model.name=@"dsfsd";
//    model.singer=@"me";
//    [[[LSFMDBTool fmdbTool] getAllLocalMusics] enumerateObjectsUsingBlock:^(LSMusicModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        NSLog(@"%@",obj.name);
//    }] ;
    
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
    LSBaiduSearchCell *cell=[LSBaiduSearchCell  baiduSearchCellWithTableView:tableView];
    LSMusicModel *model=self.musics[indexPath.row];
    cell.musicModel=model;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [LSBaiduSearchCell cellHeight];
}
#pragma mark - UISearchBarDelegate
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
//    NSDictionary *dict=[NSDictionary dictionaryWithContentsOfFile:  [[NSBundle mainBundle]pathForResource:@"music.plist" ofType:nil]];
//
//    
//    NSArray * list = dict[@"data"][@"data"][@"list"];
//    NSMutableArray * musicArray = [NSMutableArray array];
//    for (NSDictionary *dict in list) {
//        LSMusicModel *model=[[LSMusicModel alloc]init];
//        model.name=dict[@"name"];
//        model.songUrl=dict[@"songUrl"];
//        model.singer=dict[@"singer"];
//        model.albumPic=dict[@"albumPic"];
//        [musicArray addObject:model];
//    }
//    self.musics=musicArray;
//    [self.tableView reloadData];
//    return;
        [searchBar resignFirstResponder];
    NSDictionary * par = @{
                           @"s":searchBar.text,
                           @"limit":@20,
                           @"p":@1
                           };

    AFHTTPRequestOperationManager *manger=[AFHTTPRequestOperationManager manager];
    [manger.requestSerializer setValue:@"9159559e9ddaabea9f64a01029a1cc2b" forHTTPHeaderField:@"apikey"];
    manger.responseSerializer.acceptableContentTypes=[NSSet  setWithArray:@[@"text/json",@"text/html",@"application/json"]];
    [manger GET:@"http://apis.baidu.com/geekery/music/query" parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * d1 = responseObject;
        NSArray * list = d1[@"data"][@"data"][@"list"];
        NSMutableArray * musicArray = [NSMutableArray array];
        for (NSDictionary *dict in list) {
            LSMusicModel *model=[[LSMusicModel alloc]init];
            model.name=dict[@"songName"];
            model.songUrl=dict[@"songUrl"];
            model.singer=dict[@"userName"];
            model.albumPic=dict[@"albumPic"];
            [musicArray addObject:model];
        }
        self.musics=musicArray;
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

@end
