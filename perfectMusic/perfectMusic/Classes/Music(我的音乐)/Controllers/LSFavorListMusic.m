






//
//  LSFavorListMusic.m
//  perfectMusic
//
//  Created by song on 15/10/26.
//  Copyright © 2015年 song. All rights reserved.
//

#import "LSFavorListMusic.h"
#import "LSMusicList.h"
#import "LSPlayQueue.h"
#import "LSMyMusicCell.h"
#import "LSMusicModel.h"
@interface LSFavorListMusic ()
@property (nonatomic, strong) LSMusicList *tool;
@end

@implementation LSFavorListMusic
-(LSMusicList *)tool
{
    if (_tool==nil) {
        _tool=[LSMusicList musicList];
    }
    return _tool;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=self.listName;
    self.datas=[[self.tool getFavorListMusic:self.listName] mutableCopy];
    
    
}
-(void)remove
{
    
    
    LSMusicModel *model=self.selectModel;
    [self.tool delMusic:model listName:self.listName];
    self.datas=[[self.tool getFavorListMusic:self.listName] mutableCopy];
    [self.tableView reloadData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    LSMusicModel *model=self.datas[self.tableView.indexPathForSelectedRow.row];
    [[LSPlayQueue sharedPlayQueue] setPlayQueue:self.listName currentIndex:model orIndex:indexPath.row];
}
@end
