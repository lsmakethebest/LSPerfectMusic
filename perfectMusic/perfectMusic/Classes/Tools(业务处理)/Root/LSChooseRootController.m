//
//  LSChooseRootController.m
//  至美微博
//
//  Created by ls on 15/10/4.
//  Copyright © 2015年 ls. All rights reserved.
//

#import "LSChooseRootController.h"
#import "LSNewFeatureController.h"

#import <UIKit/UIKit.h>
#import "LSMainViewController.h"
#import "LSRightViewController.h"
#define LSVersionKey @"CFBundleVersion"
#import "SliderViewController.h"
@implementation LSChooseRootController
+(void)chooseRootController:(UIWindow *)window
{
    
    
    NSString *currentVersion=[NSBundle mainBundle].infoDictionary[LSVersionKey];
    NSString *oldVersion=[[NSUserDefaults standardUserDefaults] objectForKey:LSVersionKey];
    if ([currentVersion isEqualToString:oldVersion]) {
        
        //        UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"MainPage" bundle:nil];
        //
        //        UINavigationController *mainVc=[storyBoard instantiateInitialViewController];
        //        mainVc.view.backgroundColor=[UIColor redColor];
        //        UIViewController *leftVC=[[UIViewController alloc]init];
        //        leftVC.view.backgroundColor=[UIColor clearColor];
        //        LSRightViewController *rightVC=[[LSRightViewController alloc]init];
        //        rightVC.view.backgroundColor=[UIColor blackColor];
        //        SliderViewController *sliderVC=[[SliderViewController alloc]init];
        //        sliderVC.leftVC=leftVC;
        //        sliderVC.rightVC=rightVC;
        //        sliderVC.mainVC=mainVc;
        //        sliderVC.leftContentScale = .6;
        //        sliderVC.rightContentScale = .6;
        //        window.rootViewController=sliderVC;
        
        UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"MainPage" bundle:nil];
        UINavigationController *mainVc=[storyBoard instantiateInitialViewController];
        window.rootViewController=mainVc;
        
        
    }
    else
    {
        //打开新特性界面
        LSNewFeatureController *newfeature=[[LSNewFeatureController alloc]init];
        window.rootViewController=newfeature;
        [[NSUserDefaults standardUserDefaults ] setObject:currentVersion forKey:LSVersionKey];
        
    }
    
    
}
@end
