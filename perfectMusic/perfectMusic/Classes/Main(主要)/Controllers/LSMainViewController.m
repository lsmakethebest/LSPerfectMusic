


//
//  LSMainViewController.m
//  perfectMusic
//
//  Created by song on 15/10/13.
//  Copyright © 2015年 song. All rights reserved.
//

#import "LSMainViewController.h"
#import "LSFirstCell.h"
#import "LSSecondCell.h"
#import "LSAccountTool.h"
#import "LSAccount.h"
#import "UIImageView+WebCache.h"
#import "LSAccessTokenTool.h"
#import "LSPlayBottomView.h"
#import "LSPlayQueue.h"
@interface LSMainViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSArray *firstArray;
@property (nonatomic, strong) NSMutableArray *secondArray;
@property (nonatomic, weak) IBOutlet UITableView *firstTableView;
@property (nonatomic, weak)IBOutlet UITableView *secondTableView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;


- (IBAction)login:(id)sender;
- (IBAction)register:(id)sender;


@end


@implementation LSMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.backgroundImageView.image=[UIImage imageNamed:@"leftViewBg"];
    //统一设置状态栏风格
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    [UIApplication sharedApplication].statusBarHidden=NO;
    //一级菜单滚到第一行
    [self.firstTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
    //    手动调用代理方法刷新二级菜单
    [self tableView:self.firstTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    self.view.height=LSScreenHeight-[LSPlayBottomView height];
    //添加LSPlayBottomView
    LSPlayBottomView *playView=[LSPlayBottomView sharedPlayBottomView];
    playView.height=[LSPlayBottomView height];
    playView.y=LSScreenHeight-playView.height;
    playView.width=LSScreenWidth;
    [self.navigationController.view addSubview:playView];

    NSString *listName=[[NSUserDefaults standardUserDefaults] objectForKey:LSSaveListNameKey];
    NSInteger index=[[NSUserDefaults standardUserDefaults] integerForKey:LSSavePlayIndexKey];
    [[LSPlayQueue sharedPlayQueue] setPlayQueue:listName currentIndex:nil orIndex:index];
    
    
    
}
//懒加载
-(NSArray *)firstArray
{
    if (!_firstArray) {
        NSURL *url=[[NSBundle mainBundle]URLForResource:@"mainFunctionList.plist" withExtension:nil];
        _firstArray=[NSArray arrayWithContentsOfURL:url];
    }
    return _firstArray;
}
-(NSMutableArray *)secondArray
{
    if (_secondArray==nil) {
        _secondArray=[NSMutableArray array];
    }
    return _secondArray;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden=YES;
    LSAccount *account=[LSAccountTool sharedAccountTool].account;
    [self.loginBtn setTitle:@"注销" forState:UIControlStateNormal];
    if (account.iconURL) {
        [self.iconImageView setImageWithURL:[NSURL  URLWithString:account.iconURL] placeholderImage:[UIImage imageNamed:@"userMessage_headBgImage"]];
        NSLog(@"iconURL===%@",account.iconURL);
    }
    else
    {
        account=[LSAccountTool account];
        if (account) {
            NSLog(@"iconURL===%@",account.iconURL);
            [self.iconImageView setImageWithURL:[NSURL  URLWithString:account.iconURL] placeholderImage:[UIImage imageNamed:@"userMessage_headBgImage"]];
        }
        else{
            [self.iconImageView setImage:[UIImage imageNamed:@"userMessage_headBgImage"]];
            [self.loginBtn setTitle:@"登陆" forState:UIControlStateNormal];
        }
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden=NO;
    [super viewWillDisappear:animated];
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==self.firstTableView) {
        return self.firstArray.count;
    }
    else if(tableView==self.secondTableView){
        
        return self.secondArray.count;
    }
    return 0;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView==self.firstTableView) {
        
        LSFirstCell *cell=[LSFirstCell firstCell:tableView];
        cell.contentDict=self.firstArray[indexPath.row];
        
        return cell;
        
    }
    else if(tableView==self.secondTableView){
        
        LSSecondCell *cell=[LSSecondCell secondCellWithTableView:tableView];
        cell.textLabel.text=self.secondArray[indexPath.row];
        return cell;
    }
    return nil;
}
#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (tableView==self.firstTableView) {
        
        NSDictionary *dict= self.firstArray[indexPath.row];
        NSURL *url=[[NSBundle mainBundle]URLForResource:dict[@"path"] withExtension:nil];
        [self.secondArray removeAllObjects];
        [self.secondArray addObjectsFromArray:[NSArray arrayWithContentsOfURL:url]];
        
        
        [self.secondTableView reloadData];
    }
    else if(tableView==self.secondTableView){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        });
        [self gotoSecondMenuWithText:[tableView cellForRowAtIndexPath:indexPath].textLabel.text];
    }
    
}
-(void)gotoSecondMenuWithText:(NSString*)text
{
    if ([text isEqualToString:@"本地音乐"]) {
        [self performSegueWithIdentifier:@"gotoMyMusic" sender:nil];

    }else if ([text isEqualToString:@"电台"]){
        
        [self performSegueWithIdentifier:@"channel" sender:nil];
    }else if ([text isEqual:@"歌曲搜索"]){
        [self performSegueWithIdentifier:@"page2baiduSearch" sender:nil];
    }else if ([text isEqualToString:@"下载管理"]){
        
        [self performSegueWithIdentifier:@"downloadManger" sender:nil];
    }else if ([text isEqualToString:@"我喜欢"]){
        
        [self performSegueWithIdentifier:@"page2Like" sender:nil];
    }else if ([text isEqualToString:@"我的歌单"]){
        [self performSegueWithIdentifier:@"page2Favor" sender:nil];
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView==self.firstTableView) {
        
        return [LSFirstCell cellHeight];
        
    }
    else if(tableView==self.secondTableView){
        
        return [LSSecondCell cellHeight];
    }
    return 44;
    
}

- (IBAction)login:(id)sender {
    UIButton *btn=sender;
    NSString *title=[btn titleForState:UIControlStateNormal];
    if ([title isEqualToString:@"注销"]) {
        [LSAccountTool saveAccount:nil];
        [LSAccountTool sharedAccountTool].account=nil;
        [btn setTitle:@"登陆" forState:UIControlStateNormal];
        [self.iconImageView setImage:[UIImage imageNamed:@"userMessage_headBgImage"]];
    }else if([title isEqualToString:@"登陆"])
    {
        
        [self performSegueWithIdentifier:@"login" sender:nil];
    }
}

- (IBAction)register:(id)sender {
    [self performSegueWithIdentifier:@"register" sender:nil];
    
    
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
   
}

@end
