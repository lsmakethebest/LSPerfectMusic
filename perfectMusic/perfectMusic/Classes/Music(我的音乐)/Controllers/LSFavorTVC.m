





//
//  LSFavorTVC.m
//  perfectMusic
//
//  Created by song on 15/10/23.
//  Copyright © 2015年 song. All rights reserved.
//

#import "LSFavorTVC.h"
#import "LSMusicList.h"
#import "KVNProgress.h"
#import "LSFavorListMusic.h"
@interface LSFavorTVC ()
@property (nonatomic, strong) NSArray *datas;
@property (nonatomic, strong) LSMusicList *tool;
@property(nonatomic,assign,getter=isFlag) BOOL flag;
@end

@implementation LSFavorTVC
-(LSMusicList *)tool
{
    if (_tool==nil) {
        _tool=[LSMusicList musicList];
    }
    return _tool;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //加载导航栏
    [self setupNavBar];
    self.datas=[self.tool getAllFavorListName];
}

-(void)setupNavBar
{
    self.title=@"我的歌单";
    UIBarButtonItem *item1=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addClick)];
    UIBarButtonItem *item2=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(delClick)];
    self.navigationItem.rightBarButtonItems=@[item1,item2];
}

-(void)addClick
{
    self.tableView.editing=NO;
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
                [KVNProgress showSuccessWithStatus:@"添加成功"];
                self.datas=[self.tool getAllFavorListName];
                [self.tableView reloadData];
            }else
            {
                [KVNProgress showErrorWithStatus:@"添加失败"];
            }
        }
        else
        {
            [KVNProgress showErrorWithStatus:@"请输入收藏列表名"];
        }
    }]];
    [ac addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:ac animated:YES completion:nil];
    
    
}
-(void)delClick
{
    self.flag=self.tableView.editing=!self.tableView.editing;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseID=@"favorCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:reuseID];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    cell.textLabel.text=self.datas[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        if(![self.tool delFavorWithListName:self.datas[indexPath.row]]){
            [KVNProgress showErrorWithStatus:@"删除失败"];
        }
        self.datas=[self.tool getAllFavorListName];
        [self.tableView reloadData];
        
        self.tableView.editing=self.tableView.isEditing;
    }
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return NO;
    }else{
        return YES;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self performSegueWithIdentifier:@"favorList" sender:indexPath];
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"favorList"]) {
        NSIndexPath *indexPath=sender;
        LSFavorListMusic *vc=segue.destinationViewController;
        vc.listName=self.datas[indexPath.row];
    }
}
@end
