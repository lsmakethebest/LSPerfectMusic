//
//  LSLoginController.m
//  perfectMusic
//
//  Created by song on 15/10/15.
//  Copyright © 2015年 song. All rights reserved.
//

#import "LSLoginController.h"
#import "LSHttpTool.h"
#import "LSAccount.h"
#import "KVNProgress.h"
#import "LSAccountTool.h"
@interface LSLoginController ()
- (IBAction)loginClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *loginName;
@property (weak, nonatomic) IBOutlet UITextField *loginPassword;

@end

@implementation LSLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
       [self setupNavigationBar];
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setupNavigationBar
{
    self.title=@"登陆界面";

    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
}
-(void)back
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)loginClick:(UIButton *)sender {
    
    
    NSMutableDictionary *param=[NSMutableDictionary dictionary];
    param[@"loginName"]=self.loginName.text;
    param[@"loginPassword"]=self.loginPassword.text;
    [LSHttpTool POST:@"http://127.0.0.1/server/login.php" parameters:param success:^(id responseObject) {
        NSDictionary *dict=responseObject;
        NSLog(@"resonseObject=%@",responseObject);
        if ([dict[@"status"] isEqualToString:@"0" ]) {
            [KVNProgress showSuccessWithStatus:@"登陆成功"];
            LSAccount *account=[[LSAccount alloc]init];
            account.iconURL=dict[@"iconURL"];
            account.nickName=dict[@"nickName"];
            account.loginName=dict[@"loginName"];
            account.doubanID=@"doubanID";
            [LSAccountTool sharedAccountTool].account=account;
            [LSAccountTool saveAccount:account];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else {
        [KVNProgress showSuccessWithStatus:@"用户名或密码错误"];
        }
    } failure:^(NSError *error) {

        NSLog(@"%@",error.localizedDescription);
    }];
    
    
    
    
}
@end
