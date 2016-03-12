


//
//  LSNavgitionController.m
//  perfectMusic
//
//  Created by song on 15/10/14.
//  Copyright © 2015年 song. All rights reserved.
//

#import "LSNavgitionController.h"
#import "LSStack.h"
#define LSMinScale 0.5
@interface LSNavgitionController ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) LSStack *stack;
@property (nonatomic, weak) UIImageView *iv;
@end

@implementation LSNavgitionController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc]init];
    [pan addTarget:self action:@selector(handlePanGesture:)];
    pan.delegate=self;
    [self.view addGestureRecognizer:pan];
    self.stack=[LSStack stack];
    
    self.interactivePopGestureRecognizer.enabled=NO;
    
    
}
-(void)handlePanGesture:(UIPanGestureRecognizer*)recognizer
{
    if (self.topViewController==self.viewControllers[0]) return;
    CGFloat x=[recognizer translationInView:self.view].x;
    if (x<0) return;
    self.topViewController.view.userInteractionEnabled=NO;
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            UIImageView *imageView=[[UIImageView alloc]init];
            imageView.image=[self.stack getTop];
            imageView.frame=self.view.window.bounds;
            [self.view.window insertSubview:imageView belowSubview:self.view];
            imageView.transform=CGAffineTransformMakeScale(LSMinScale, LSMinScale);
            self.iv=imageView;
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            CGFloat scale=x/self.view.bounds.size.width/2+LSMinScale;
            NSLog(@"x===%lf   scale==%lf",x,scale);
            self.iv.transform=CGAffineTransformMakeScale(scale, scale);
            self.view.transform=CGAffineTransformMakeTranslation(x, 0);
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
        {
            //打开用户交互
            if (recognizer.state==UIGestureRecognizerStateEnded) {
                
                self.topViewController.view.userInteractionEnabled=YES;
            }
            if (x>=self.view.frame.size.width/2) {
                [UIView animateWithDuration:0.2 animations:^{
                    self.iv.transform=CGAffineTransformIdentity;
                    self.view.transform=CGAffineTransformMakeTranslation(LSScreenWidth, 0);
                } completion:^(BOOL finished) {
                    [self.iv removeFromSuperview];
                    self.view.transform=CGAffineTransformIdentity;
                    [self popViewControllerAnimated:NO];
                    
                }];
            }else{
                [UIView animateWithDuration:0.2 animations:^{
                    self.view.transform=CGAffineTransformIdentity;
                }];
                self.iv.transform=CGAffineTransformMakeScale(LSMinScale, LSMinScale);
                
            }
        }
            break;
        default:
            break;
    }
}
+(void)initialize
{
    UINavigationBar * navBar=  [UINavigationBar appearance];
    [navBar setBackgroundImage:[UIImage  imageNamed:@"NavBar64"] forBarMetrics:UIBarMetricsDefault];
    NSDictionary * dict = @{NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName:[UIColor whiteColor]};
    [navBar setTitleTextAttributes:dict];
    [[UIBarButtonItem appearance] setTitleTextAttributes:dict forState:UIControlStateNormal];
    [navBar setTintColor:[UIColor whiteColor]];

}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self.stack push:[self captureView]];
    [super pushViewController:viewController animated:animated];
    
}

-(UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    [self.stack pop];
    return [super popViewControllerAnimated:animated];
    
}
-(NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    int count=self.viewControllers.count;
//     A B D C
    for (int i=count-1; i>0 ; i--) {
        if (self.viewControllers[i]!=viewController) {
            [self.stack pop];
        }else {
            break;
        }
    }
    return [super popToViewController:viewController animated:animated];
}
-(NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated
{
    int count=self.viewControllers.count;
    for (int i=0; i<count-1 ; i++) {
        [self.stack pop];
    }
    return  [super popToRootViewControllerAnimated:animated];
}
-(UIImage *)captureView
{
    UIGraphicsBeginImageContext(self.view.frame.size);
    CGContextRef context=UIGraphicsGetCurrentContext();
    [self.view.layer renderInContext:context];
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}


@end
