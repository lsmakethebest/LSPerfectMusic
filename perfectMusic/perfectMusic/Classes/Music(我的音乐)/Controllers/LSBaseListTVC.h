//
//  LSBaseListTVC.h
//  perfectMusic
//
//  Created by song on 15/10/23.
//  Copyright © 2015年 song. All rights reserved.
//

#import "LSBaseTableViewController.h"
#import "LSMyMusicCell.h"
@interface LSBaseListTVC : LSBaseTableViewController
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) LSMusicModel *selectModel;
-(void)remove;
-(void)favor;
@end
