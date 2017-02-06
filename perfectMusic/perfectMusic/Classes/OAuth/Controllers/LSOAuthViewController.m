







//
//  LSOAuthViewController.m
//  JJFJ
//
//  Created by song on 15/10/8.
//  Copyright © 2015年 song. All rights reserved.
//

#import "LSOAuthViewController.h"
#import "LSDounbanAccount.h"
#import "AFNetworking.h"
#import "LSAccount.h"
#import "LSDoubanUser.h"
#import "LSChooseRootController.h"
#import "MBProgressHUD+Add.h"
#import "LSHttpTool.h"
#import "LSRegisterController.h"
#import "LSAccessTokenTool.h"
#define LSBaseUrl @"https://www.douban.com/service/auth2/auth"
#define LSClient_id @"0105595a51ceb79203100c0ef56c26b6"
#define LSRedirect_uri @"http://www.douban.com/people/itbighome/"
#define LSClient_Secret @"90e4a35ba5cbc14f"
#define LSAcceessTokenUrl @"https://www.douban.com/service/auth2/token"
@interface LSOAuthViewController ()<UIWebViewDelegate>
@property (nonatomic, weak) IBOutlet UIWebView *webView;
@property (nonatomic, assign) int *number;
@end

@implementation LSOAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationBar];
    self.webView.delegate=self;
    // 拼接URL字符串
    NSString *urlStr = [NSString stringWithFormat:@"%@?client_id=%@&redirect_uri=%@&response_type=code",LSBaseUrl,LSClient_id,LSRedirect_uri];
//NSString *urlStr= @"https://www.douban.com/service/auth2/auth?client_id=0105595a51ceb79203100c0ef56c26b6&redirect_uri=http://www.douban.com/people/itbighome/&response_type=code";
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [self.webView loadRequest:request];
    
}
#pragma mark - UIWebViewDelegate'
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [MBProgressHUD showMessage:@"正在加载中"];
    
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideHUD];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    NSString *urlstring=[request.URL absoluteString];
    //    NSLog(@"%@",urlstring);
    BOOL v;
    NSString *code= [LSAccessTokenTool codeWithURLString:urlstring isVaild:&v];
    if (v) {
        
        if (code==nil) {
            [MBProgressHUD showError:@"拒绝授权"];
            
            
        }else{
            
            [LSAccessTokenTool accessTokenWithCode:code success:^(LSDoubanAccount *account) {
                [MBProgressHUD showSuccess:@"授权成功"];
                
                
                [self isFirstWithDoubanAccount:account];
                
            } failure:^(NSError *error) {
                [MBProgressHUD showError:error.localizedDescription];
                
            }];
        }
        return NO;
    }
    else{//重定向到URL
        
        return YES;
    }
    //    return YES;
    
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
    [MBProgressHUD hideHUD];
}


-(void)setupNavigationBar
{
    self.navigationItem.title = @"用户注册";
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
}
-(void)back
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)isFirstWithDoubanAccount:(LSDoubanAccount*)account
{
    
    NSMutableDictionary *dict=[NSMutableDictionary dictionary];
    dict[@"doubanID"]=account.douban_user_id;
    
    [LSHttpTool POST:@"http://127.0.0.1/server/login_douban.php" parameters:dict success:^(id responseObject) {
        
        NSDictionary  *result=responseObject;
        if ([result[@"status"] isEqualToString:@"0"]) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            
            [LSAccessTokenTool getCurentUserInfoSuccess:^(LSDoubanUser *user) {
                LSAccount *newAccount=[[LSAccount alloc]init];
                newAccount.nickName=user.name;
                newAccount.iconURL=user.avatar;
                newAccount.doubanID=user.id;
                NSLog(@"%@",user.avatar);
                [self performSegueWithIdentifier:@"oauthRegister" sender:newAccount];
                
                
            } failure:^(NSError *error) {
                NSLog(@"%@",error);
            }];
            
            
            
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"oauthRegister"]) {
        LSAccount *account=sender;
        LSRegisterController *vc=segue.destinationViewController;
        vc.account=account;
    }
}
@end
