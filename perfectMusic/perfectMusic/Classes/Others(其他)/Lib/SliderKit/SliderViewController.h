//
//  SliderViewController.h
//  侧滑
//
//  Created by Mac on 14-9-20.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SliderViewController : UIViewController

@property(nonatomic,strong)UIViewController *mainVC;
@property(nonatomic,strong)UIViewController *leftVC;
@property(nonatomic,strong)UIViewController *rightVC;

@property(nonatomic,assign) BOOL canShowLeft;
@property(nonatomic,assign) BOOL canShowRight;

@property(nonatomic,assign) float leftContentScale;
@property(nonatomic,assign) float rightContentScale;

@property(nonatomic,assign) float leftOpenDuration;
@property(nonatomic,assign) float rightOpenDuration;
@property(nonatomic,assign) float leftCloseDuration;
@property(nonatomic,assign) float rightCloseDuration;


@end
