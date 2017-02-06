



//
//  LSBaseListTVC.m
//  perfectMusic
//
//  Created by song on 15/10/23.
//  Copyright © 2015年 song. All rights reserved.
//

#import "LSBaseListTVC.h"
#import "MJExtension.h"
#import "LSMusicModel.h"
#import "LSMusicList.h"
#import "LSMyMusicCell.h"
#import "LSMusicPlayerTool.h"
#import "LSCover.h"
#import "LSPlayQueue.h"
@interface LSBaseListTVC ()<LSCoverDelegate>
@property (nonatomic, weak) LSCover *cover;

@end

@implementation LSBaseListTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSMutableArray *)datas
{
    if (_datas==nil) {
        _datas=[NSMutableArray array];
    }
    return _datas;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.navigationController.navigationBar.hidden=NO;
    });
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.datas.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSMyMusicCell *cell=[LSMyMusicCell myMusicCellWithTableView:tableView];
    LSMusicModel *model=self.datas[indexPath.row];
    cell.musicModel=model;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [LSMyMusicCell cellHeight];
}


#pragma mark - LSMyMusicCellDelegate
-(void)myMusicCellFavorClick:(LSMyMusicCell *)cell
{
    NSLog(@"sjdfklsk");
    LSCover *cover=  [LSCover show];
    cover.delegate=self;
    self.cover=cover;
    self.selectModel=cell.musicModel;
}
#pragma mark - LSCoverDelegate
-(void)coverAddMmusic:(LSCover *)cover listName:(NSString *)listName
{



    if([[LSMusicList musicList] addMusic:self.selectModel listName:listName]){
        [MBProgressHUD showSuccess:@"添加成功"];
    }else{
        [MBProgressHUD showError:@"添加失败"];
    }
    
}
-(void)coverNewFavorListClick:(LSCover *)cover
{
    

    //创建UIAlertController
    UIAlertController *ac=[UIAlertController alertControllerWithTitle:@"添加收藏列表" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [ac addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder=@"新收藏列表名";
    }];
    [ac addAction:[UIAlertAction actionWithTitle:@"添加" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *name=ac.textFields[0].text;
        if (name.length)
        {
            if([[LSMusicList musicList] addFavorWithListName:name])
            {
                
                if([[LSMusicList musicList] addMusic:self.selectModel listName:ac.textFields[0].text]){
                    [MBProgressHUD showSuccess:@"添加成功"];
                }else{
                [MBProgressHUD showError:@"添加失败"];
                }
            }else
            {
                [MBProgressHUD showError:@"添加失败"];
            }
        }
        else
        {
            [MBProgressHUD showError:@"请输入收藏列表名"];
        }
    }]];
    [ac addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:ac animated:YES completion:nil];
}

-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
     self.selectModel=self.datas[indexPath.row];
    UITableViewRowAction *action=[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"删除");
        [self  remove];
        self.tableView.editing=NO;
    }];
    UITableViewRowAction *action2=[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"收藏" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [self favor];
        NSLog(@"收藏");
        self.tableView.editing=NO;
        
        
    }];
    action.backgroundColor=[UIColor lightGrayColor];
    NSArray *arr=@[action,action2];
    return arr;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSMusicModel *model=self.datas[indexPath.row];
    [[LSMusicPlayerTool  sharedMusicPlayerTool] playWithModel:model];

}
-(void)remove
{
    
}
-(void)favor
{
    LSCover *cover=  [LSCover show];
    cover.delegate=self;
    self.cover=cover;
};
@end
