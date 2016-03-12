


//
//  LSBackgroundViewController.m
//  perfectMusic
//
//  Created by song on 15/10/14.
//  Copyright © 2015年 song. All rights reserved.
//

#import "LSBackgroundViewController.h"
#import "LSMainViewController.h"
#import "LSRightViewController.h"
#import "LSNavgitionController.h"
#import "LSPlayBottomView.h"
@interface LSBackgroundViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic, weak) UIView *navView;
@property (nonatomic, weak) LSRightViewController *right;
@property (nonatomic, weak) LSNavgitionController *main;
@property(nonatomic,assign,getter=isPan) BOOL pan;
@end

@implementation LSBackgroundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleDefault;
    [UIApplication sharedApplication].statusBarHidden=NO;
    //    UIImageView *imageView=[]
    self.view.backgroundColor=[UIColor redColor];
    LSRightViewController *rightVC=[[LSRightViewController alloc]init];
    self.right=rightVC;
    rightVC.view.frame=self.view.bounds;
    rightVC.view.backgroundColor=[UIColor grayColor];
    [self.view addSubview: rightVC.view];
    [self addChildViewController:rightVC];
    
    
    UIStoryboard *stotyBoard=[UIStoryboard storyboardWithName:@"MainPage" bundle:nil];
    LSNavgitionController *nav=[stotyBoard instantiateInitialViewController];
    nav.view.frame=self.view.bounds;
    nav.view.height=LSScreenHeight;
    [self addChildViewController:nav];
    nav.view.backgroundColor=[UIColor blueColor];
    [self.view addSubview:nav.view];
    self.navView=nav.view;
    self.main=nav;
    
    UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(mainViewPan:)];
    pan.delegate=self;
    [nav.viewControllers[0].view addGestureRecognizer:pan];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    tap.delegate=self;
//    [self.navView addGestureRecognizer:tap];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tapClick:(UITapGestureRecognizer*)tap
{
    if (!self.isPan&&self.navView.x<0) {
        [UIView animateWithDuration:0.2 animations:^{
            
            self.navView.transform=CGAffineTransformIdentity;
            self.navView.x=0;
        }];
    }
    
}
-(void)mainViewPan:(UIPanGestureRecognizer *)pan
{
    
    static CGFloat totalX;
    
    //比例
    static CGFloat scale=0.7;
     static CGFloat scaleX=0.7;
    static CGFloat scaleY=0.7;
    CGFloat x=[pan translationInView:self.view].x;
    //屏幕宽高计算
    CGFloat screenWidth=[UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight=[UIScreen mainScreen].bounds.size.height;
    CGFloat maxX=screenWidth*scale;
    CGFloat  maxY=screenHeight*scale;
    //判断何时能进入滑动状态(如果navView的x<0 而且x+translation.x<=0)
    if (pan.state==UIGestureRecognizerStateEnded) {//拖拽结束
        self.pan=NO;
        if (-(self.navView.x+x)>=maxX/2){//拖拽结束时滑动范围大于最大滑动距离一半
            totalX=maxX;
            [UIView animateWithDuration:0.2 animations:^{
                
                self.navView.transform=CGAffineTransformMakeScale(scaleX,scaleY);
//                NSLog(@"%lf",self.navView.x);
                //滑动最小化时的x
                self.navView.x=  screenWidth*(1-scale)-screenWidth*scaleX;
            }];
        }else{//拖拽结束时滑动范围小于最大滑动距离一半
              totalX=0.0;
            [UIView animateWithDuration:0.2 animations:^{
                self.navView.transform=CGAffineTransformIdentity;
                self.navView.x=0;
            }];
        }
        
    }else {//正在拖拽中
        self.pan=YES;
        if (self.navView.x<=0&&self.navView.x+x<=0)//什么情况可以进入滑动状态
        {
            totalX=totalX-x;
            //判断最大滑动多少
            //NSLog(@"00000000=====%lf",-(self.navView.x+x));
            if (totalX>=maxX) {//滑动范围大于最大滑动距离
                self.navView.transform=CGAffineTransformMakeScale( scaleX   ,scaleY);
                //滑动最小化时的x
                self.navView.x=  (screenWidth*(1-scale)-screenWidth*scaleX)/scaleX;
                //NSLog(@"1111111");
            }else{//滑动范围小于最大滑动距离
                CGFloat currentTransScale= totalX/maxX;
                CGFloat currentScaleX=1-(1-scaleX)*currentTransScale;
                CGFloat currentScaleY=1-(1-scaleY)*currentTransScale;
                NSLog(@"SCALE===%lf",currentScaleX);
               CGAffineTransform scaleForm=CGAffineTransformMakeScale( currentScaleX ,currentScaleY);
                CGAffineTransform translateForm=CGAffineTransformTranslate(self.navView.transform, -1/scaleX, 0);
                self.navView.transform=scaleForm;
//                NSLog(@"xxxxxx===%lf",self.navView.height);
                [pan setTranslation:CGPointZero inView:self.view];
                //NSLog(@"2222222");
            }
        }else  if(self.navView.x+x>0){//x+translation.x>0 清空transform和坐标设置
            self.navView.x=0;
            self.navView.transform=CGAffineTransformIdentity;
//            NSLog(@"3333333333");
        }else {
        
        
        }

        
        
    }
    //    NSLog(@"%@",NSStringFromCGRect(self.navView.frame));
    
}
//-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
//{
//    return YES;
//}
@end
