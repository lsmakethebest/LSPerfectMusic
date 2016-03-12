
//
//  LSDownloadMangerTVC.m
//  perfectMusic
//
//  Created by song on 15/10/20.
//  Copyright © 2015年 song. All rights reserved.
//

#import "LSDownloadMangerTVC.h"
#import "LSDownloadList.h"
#import "LSDownloadMangerCell.h"
#import "LSDownloadMusic.h"
@interface LSDownloadMangerTVC ()


@end

@implementation LSDownloadMangerTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"下载管理";
 
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    LSDownloadList *downloadList=[LSDownloadList sharedDownloadList];
    return [downloadList getDownloadList].count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSDownloadMangerCell *cell=[LSDownloadMangerCell downloadMangerCell:tableView];
    LSDownloadMusic *downloader=[[LSDownloadList  sharedDownloadList] getDownloadList][indexPath.row];
    cell.downloader=downloader;
    return  cell;
}


@end
