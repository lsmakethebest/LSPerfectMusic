//
//  SliderViewController.m
//  侧滑
//
//  Created by Mac on 14-9-20.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "SliderViewController.h"

typedef NS_ENUM(NSInteger, HSideViewController) {
    HSideViewControllerLeft = 0,
    HSideViewControllerRight
};

@interface SliderViewController ()
{
    BOOL showingLeft;
    BOOL showingRight;
    
    UIView *leftView;
    UIView *rightView;
    UIView *mainView;
    
    UITapGestureRecognizer *tapGesture;
    UIPanGestureRecognizer *panGesture;
    
    ////根据放大缩小比例，算出停止的偏移量
    float leftContentOffset;
    float rightContentOffset;
    
    //原视图与完全缩小后视图的差
    float mml;
    float mmr;
}
@end

@implementation SliderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _leftCloseDuration = .4;
        _rightCloseDuration = .4;
        _leftOpenDuration = .5;
        _rightOpenDuration = .5;
        _leftContentScale = .7;
        _rightContentScale = .7;
        _canShowLeft = YES;
        _canShowRight = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initSubviews];
    
    [self initControllers];
    
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [mainView addGestureRecognizer:tapGesture];
    tapGesture.enabled = NO;
    
    panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    [mainView addGestureRecognizer:panGesture];
    
    [tapGesture requireGestureRecognizerToFail:panGesture];
    
    //初始化一些全局变量
    [self resetSubviewsTransform];
}

-(void)initSubviews{
    leftView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:leftView];
    
    rightView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:rightView];
    
    mainView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:mainView];
    

}

-(void)initControllers{
    if (_canShowLeft && _leftVC != nil) {
        [self addChildViewController:_leftVC];
        _leftVC.view.frame = _leftVC.view.bounds;
        [leftView addSubview:_leftVC.view];
    }
    
    if (_canShowRight && _rightVC != nil) {
        [self addChildViewController:_leftVC];
        _rightVC.view.frame = _rightVC.view.bounds;
        [rightView addSubview:_rightVC.view];
    }
    
    if (_mainVC == nil) {
        _mainVC = [[NSClassFromString(@"MianViewController") alloc] init];
    }
    [mainView addSubview:_mainVC.view];
}


-(void)resetSubviewsTransform{
    //视图宽度
    float width = self.view.frame.size.width;
    
    //原视图与完全缩小后视图的差
    mml = width - width * _leftContentScale;
    mmr = width - width * _rightContentScale;
    
    
    //完全缩小后视图的一半
    float mm = (width * _leftContentScale)/2;
    //不缩小左视图的偏移量
    float mmm = width - (mm + mml);
    
    //完全缩小后视图的一半
    float mm1 = (width * _rightContentScale)/2;
    //不缩小右视图的偏移量
    float mmm1 = width - (mm1 + mml);
    
    leftView.transform = CGAffineTransformMakeTranslation(-mmm, 0);
    rightView.transform = CGAffineTransformMakeTranslation(mmm1, 0);
    
    //根据放大缩小比例，算出停止的偏移量
    leftContentOffset = width - (width * _leftContentScale / 2);
    rightContentOffset = (width * _rightContentScale / 2) - width;
    
    
}

#pragma mark - Action
-(void)tapAction:(UITapGestureRecognizer *)tapGest{ //关闭侧视图
    
    [UIView animateWithDuration:showingLeft ? _leftCloseDuration:_rightCloseDuration
                     animations:^{
                         mainView.transform = CGAffineTransformIdentity;
                     } completion:^(BOOL finished) {
                         tapGesture.enabled = NO;
                         showingLeft = NO;
                         showingRight = NO;
                     }];
}

-(void)panAction:(UIPanGestureRecognizer *)panGest{
    //视图宽度
    float width = self.view.frame.size.width;
    
    static BOOL isLeftShowing;  //是否显示左视图
    static BOOL isBack;  //是否往回滑
    
    static CGFloat currentTranslateX;
    if (panGest.state == UIGestureRecognizerStateBegan)//手势开始
    {
        currentTranslateX = mainView.transform.tx; //主视图的形变偏移量
    }
    
    if (panGest.state == UIGestureRecognizerStateChanged) {
        
        float mtransX = [panGest translationInView:mainView].x + currentTranslateX; //主视图偏移量
        float mscal = 0;  //主视图大小比例
        float scal = 0; //侧视图大小比例
        
        if (mainView.frame.origin.x > 0) {// 向右滑动
            isLeftShowing = YES;
            [self.view sendSubviewToBack:rightView];
            
            if (mainView.frame.origin.x < leftContentOffset-.001) {//没滑到指定位置
                mscal = 1 - (mainView.frame.origin.x/leftContentOffset)*(1 - _leftContentScale);
                scal = 1 - mscal + _leftContentScale;
                
            }else{//滑到指定位置
                
                if ([panGest translationInView:mainView].x < 0) { //往回滑
                    isBack = YES;
                    mscal = 1 - (mainView.frame.origin.x/leftContentOffset)*(1 - _leftContentScale);
                    scal = 1 - mscal + _leftContentScale;
                    
                }else{
                    isBack = NO;
                    mscal = _leftContentScale;
                    scal = 1;
                    mtransX = leftContentOffset - mml/2;
                }
                
            }
        }else{ //向左滑动
            isLeftShowing = NO;
            [self.view sendSubviewToBack:leftView];
            if (mainView.frame.origin.x > - (self.view.frame.size.width*_rightContentScale)/2) {//没滑到指定位置
                mscal = 1 - ((width-mainView.frame.origin.x-mainView.frame.size.width)/(-rightContentOffset))*(1 - _rightContentScale);
                scal = 1 - mscal + _rightContentScale;
                
            }else{//滑到指定位置
                if ([panGest translationInView:mainView].x > 0) { //往回滑
                    isBack = YES;
                    mscal = 1 - ((width-mainView.frame.origin.x-mainView.frame.size.width)/(-rightContentOffset))*(1 - _rightContentScale);
                    scal = 1 - mscal + _rightContentScale;
                    
                }else{
                    isBack = NO;
                    mscal = _rightContentScale;
                    scal = 1;
                    
                    mtransX = rightContentOffset + mmr/2;
                }
                
            }
        }
        
        UIViewController *vc = isLeftShowing ? _leftVC:_rightVC;
        CGAffineTransform scale = CGAffineTransformMakeScale(scal, scal);
        vc.view.transform = scale;
        
        CGAffineTransform mscale = CGAffineTransformMakeScale(mscal, mscal);
        CGAffineTransform mtranslation = CGAffineTransformMakeTranslation(mtransX, 0);
        CGAffineTransform mconcat = CGAffineTransformConcat(mscale, mtranslation);
        mainView.transform = mconcat;
        
    }
    
    else if (panGest.state == UIGestureRecognizerStateEnded) {
        
        //分界速度，小于分界速度则返回原状态
        float velo = ABS([panGest velocityInView:mainView].x);
        float duration801 = (isLeftShowing?leftContentOffset:rightContentOffset) / velo;
        float duration799 = isLeftShowing?_leftCloseDuration:_rightCloseDuration;
        
        if (isBack) {  // 是往回滑
            if (velo < 800) {
                if (mainView.frame.origin.x > width/2 && isLeftShowing) {
                    [self showSideWithController:HSideViewControllerLeft withDuration:duration799];
                }else if((mainView.frame.origin.x+mainView.frame.size.width) < width/2 && !isLeftShowing){
                    [self showSideWithController:HSideViewControllerRight withDuration:duration799];
                }else{ //显示主视图
                    [self resetSubviewsTransform];
                    [self showMainControllerFromSideController:isLeftShowing ? HSideViewControllerLeft : HSideViewControllerRight withDuration:duration799];
                }
            }else{ //显示主视图  >800
                [self resetSubviewsTransform];
                [self showMainControllerFromSideController:isLeftShowing ? HSideViewControllerLeft : HSideViewControllerRight withDuration:duration801];
            }
        }else{  //不是往回滑
            if(velo > 800){  //显示侧视图
                [self showSideWithController:isLeftShowing ? HSideViewControllerLeft : HSideViewControllerRight withDuration:duration801];
            }else{
                if (mainView.frame.origin.x > width/2 && isLeftShowing) {
                    [self showSideWithController:HSideViewControllerLeft withDuration:duration799];
                }else if((mainView.frame.origin.x+mainView.frame.size.width) < width/2 && !isLeftShowing){
                    [self showSideWithController:HSideViewControllerRight withDuration:duration799];
                }else{
                    [self resetSubviewsTransform];
                    [self showMainControllerFromSideController:isLeftShowing ? HSideViewControllerLeft : HSideViewControllerRight withDuration:duration799];
                }
            }
        }
        isLeftShowing = NO;
        isBack = NO;
    }
}

//显示主视图
-(void)showMainControllerFromSideController:(HSideViewController)sideViewController withDuration:(float)duration
{
    [UIView animateWithDuration:duration animations:^{
        
        CGAffineTransform mscale = CGAffineTransformMakeScale(1, 1);
        CGAffineTransform mtranslation = CGAffineTransformMakeTranslation(0, 0);
        CGAffineTransform mconcat = CGAffineTransformConcat(mscale, mtranslation);
        mainView.transform = mconcat;
        
    } completion:^(BOOL finished) {
        tapGesture.enabled = NO;
    }];
}

//显示侧视图
-(void)showSideWithController:(HSideViewController)sideViewController withDuration:(float)duration
{
    UIViewController *vc = (sideViewController == HSideViewControllerLeft) ? _leftVC : _rightVC;
    float vcScale = (sideViewController == HSideViewControllerLeft) ? _leftContentScale : _rightContentScale;
    float mtransX = (sideViewController == HSideViewControllerLeft) ? (leftContentOffset - mml/2) : (rightContentOffset + mmr/2);
    
    [UIView animateWithDuration:duration animations:^{
        
        CGAffineTransform mscale = CGAffineTransformMakeScale(vcScale, vcScale);
        CGAffineTransform mtranslation = CGAffineTransformMakeTranslation(mtransX, 0);
        CGAffineTransform mconcat = CGAffineTransformConcat(mscale, mtranslation);
        mainView.transform = mconcat;
        
        CGAffineTransform scale = CGAffineTransformMakeScale(1, 1);
        vc.view.transform = scale;
    } completion:^(BOOL finished) {
        tapGesture.enabled = YES;
        showingLeft = (sideViewController == HSideViewControllerLeft);
        showingRight = !(sideViewController == HSideViewControllerLeft);
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end



