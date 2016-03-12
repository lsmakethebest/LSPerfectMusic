


//
//  LSChannelController.m
//  perfectMusic
//
//  Created by song on 15/10/17.
//  Copyright © 2015年 song. All rights reserved.
//

#import "LSChannelController.h"
#import "LSChannelTool.h"
#import "LSChannelCell.h"
#import "LSChannel.h"
#import "LSChannelMusicController.h"
@interface LSChannelController ()
@property (nonatomic, strong) NSArray *channels;

@end

@implementation LSChannelController
- (void)viewDidLoad {
    [super viewDidLoad];
    

    self.tableView.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_1"]];
    [self setupNavigationBar];
    
[LSChannelTool getChannelInfoSuccess:^(NSArray *array) {
    
//    NSLog(@"%@",array);
    self.channels=array;
    [self.tableView reloadData];
} failure:^(NSError *error) {
     NSLog(@"%@",error.localizedDescription);
}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.channels.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSChannelCell *cell=[LSChannelCell channelCellWithTableView:tableView];
    LSChannel *channel=self.channels[indexPath.row];
    cell.channel=channel;
    return cell;
}

-(void)setupNavigationBar
{
    self.navigationController.navigationBar.hidden=NO;
    self.title=@"电台";
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
}
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

{
    LSChannel *channel=self.channels[indexPath.row];
    [self performSegueWithIdentifier:@"channelMusic" sender:channel];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"channelMusic"]) {
        LSChannelMusicController *vc=segue.destinationViewController;
//        LSChannel *channel=sender;
        vc.channel=sender;
    }
}
@end
