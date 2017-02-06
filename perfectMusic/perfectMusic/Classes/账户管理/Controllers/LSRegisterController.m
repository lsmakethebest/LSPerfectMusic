
//
//  LSRegisterController.m
//  perfectMusic
//
//  Created by song on 15/10/15.
//  Copyright © 2015年 song. All rights reserved.
//

#import "LSRegisterController.h"
#import "LSHttpTool.h"
#import "LSAccount.h"
#import "LSAccountTool.h"
#import "LSAccount.h"
@interface LSRegisterController ()
@property (weak, nonatomic) IBOutlet UITextField *accountName;
@property (weak, nonatomic) IBOutlet UITextField *accountPassword;
@property (weak, nonatomic) IBOutlet UITextField *accountConfirmPassword;
@property (weak, nonatomic) IBOutlet UITextField *accountNickName;
- (IBAction)register:(id)sender;

@end

@implementation LSRegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.accountNickName.text=self.account.nickName;
    NSLog(@"text%@",self.accountNickName.text);
    [self setupNavigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setupNavigationBar
{
    self.navigationItem.title = @"用户注册";
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
}
-(void)back
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)register:(id)sender {
    
    NSMutableDictionary *dict=[NSMutableDictionary dictionary];
    dict[@"loginName"]=self.accountName.text;
    dict[@"loginPassword"]=self.accountPassword.text;
    dict[@"nickName"]=self.accountNickName.text;
    if(self.account){
        dict[@"iconURL"]=self.account.iconURL;
        dict[@"doubanID"]= self.account.doubanID;
    }
    else{
        dict[@"iconURL"]=@"http://127.0.0.1/server/vip.png";
        dict[@"doubanID"]=@"doubanID";
        
    }
    for (NSString *str in dict) {
        NSLog(@"%@",str);
    }
    [LSHttpTool POST:@"http://127.0.0.1/server/register.php" parameters:dict success:^(id responseObject) {
        NSLog(@"responseObject===%@",responseObject);
        //        NSLog(@"%@",responseObject);
        NSLog(@"%@",responseObject);
//        NSMutableDictionary *dict2=responseObject;
//        NSString *res=dict2[@"res"];
        //        if( [res isEqualToString:@"1"]){
        
        [MBProgressHUD showSuccess:@"注册成功"];
        LSAccount *account=[[LSAccount alloc]init];
        account.loginName=dict[@"loginName"];
        account.nickName=dict[@"nickName"];
        account.iconURL=dict[@"iconURL"];
        account.doubanID=dict[@"doubanID"];
        [LSAccountTool sharedAccountTool].account=account;
        [LSAccountTool saveAccount:account];
        [self dismissViewControllerAnimated:YES completion:nil];
        //        }else {
        //        [KVNProgress showSuccessWithStatus:@"注册失败"];
        //        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
        [MBProgressHUD showSuccess:@"注册失败"];
    }];
    
    
}
@end
