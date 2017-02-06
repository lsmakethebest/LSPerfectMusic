

//
//  LSMVController.m
//  perfectMusic
//
//  Created by ls on 16/3/29.
//  Copyright © 2016年 song. All rights reserved.
//

#import "AFNetworking.h"
#import "LSHttpTool.h"
#import "LSMVController.h"
#import "LSMediaModel.h"
#import "LSTableViewCell.h"
#import "LSPlayBottomView.h"
#import "LSPlayerView.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
@interface LSMVController ()
@property (nonatomic, assign) int page;
@property (nonatomic, strong) NSMutableArray* videos;
@end

@implementation LSMVController

- (NSMutableArray*)videos
{
    if (_videos == nil) {
        _videos = [NSMutableArray array];
    }
    return _videos;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playCompleted:) name:LSPlayerViewPlayCompletedNotification object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:AVAudioSessionInterruptionNotification object:[AVAudioSession sharedInstance] userInfo:@{AVAudioSessionInterruptionTypeKey:@(AVAudioSessionInterruptionTypeBegan)}];
    [UIView animateWithDuration:0.3 animations:^{
        [LSPlayBottomView sharedPlayBottomView].transform=CGAffineTransformMakeTranslation(0,[LSPlayBottomView sharedPlayBottomView].frame.size.height );
    }];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 200;
    self.page = 0;
    [self getMVListWithOffset:0 Success:^(NSArray* array) {

        [self.videos addObjectsFromArray:array];
        [self.tableView reloadData];
    }
        failure:^(NSError* error){

        }];
}

- (void)getMVListWithOffset:(NSInteger)offset Success:(void (^)(NSArray* array))success failure:(void (^)(NSError* error))failure
{
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    param[@"offset"] = @(offset);
    param[@"size"] = @20;
    param[@"area"] = @"POP_ALL";
    param[@"D-A"] = @0;
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:@"aVBob25lIE9TXzkuMF8xMjQyKjIyMDhfMTAwMDAxMDAwX2lQaG9uZTcsMQ==" forHTTPHeaderField:@"Device-V"];
    [manager.requestSerializer setValue:@"054d37aad938c791e83ed1c984344598" forHTTPHeaderField:@"Device-Id"];
    [manager.requestSerializer setValue:@"10101024" forHTTPHeaderField:@"App-Id"];

    [manager GET:@"http://mapi.yinyuetai.com/video/list.json" parameters:param success:^(AFHTTPRequestOperation* operation, id responseObject) {
        NSArray* videos = responseObject[@"videos"];
        NSMutableArray* array = [NSMutableArray array];
        if (success) {
            for (int i = 0; i < videos.count; i++) {
                NSDictionary* dict = videos[i];
                LSMediaModel* model = [[LSMediaModel alloc] init];
                model.mp4_url=dict[@"url"];
                model.myDescription=dict[@"title"];
                model.cover = dict[@"albumImg"];
                model.source=dict[@"videoSourceTypeName"];
                model.replyCount = [dict[@"totalComments"] integerValue];
                model.length = [dict[@"duration"] integerValue];
                [array addObject:model];
            }
            success(array);
        }
    }
        failure:^(AFHTTPRequestOperation* operation, NSError* error) {

            if (failure) {
                failure(error);
            }
        }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return self.videos.count;
}
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    LSTableViewCell* cell = [LSTableViewCell cellWithTabelView:tableView];
    LSMediaModel* model = self.videos[indexPath.section];
    cell.model = model;
    cell.index = indexPath.section;
    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    
    if (section==self.videos.count-1) {
        return 10;
    }
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[LSPlayerView playerView] closeClick];

}
-(void)playCompleted:(NSNotification*)note
{
    int index=[note.object intValue]+1;
    if (index<=self.videos.count-1) {
       LSTableViewCell *cell =[self.tableView  cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]];
        [cell playClick:nil];
    }
    
}

@end
