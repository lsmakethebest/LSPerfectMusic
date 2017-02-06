//
//  LSPlayerView.h
//  LSPlayer
//
//  Created by ls on 16/3/8.
//  Copyright © 2016年 song. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LSPlayerViewLocationType) {
    LSPlayerViewLocationTypeMiddle = 0, //中间
    LSPlayerViewLocationTypeTop, //顶部
    LSPlayerViewLocationTypeBottom, //底部
    LSPlayerViewLocationTypeDragging

};

typedef NS_ENUM(NSInteger, LSPlayerStatus) {
    LSPlayerStatusPlaying = 0,
    LSPlayerStatusPause,
    LSPlayerStatusStop,
    LSPlayerStatusReady,
    LSPlayerStatusFaild

};
#define  LSPlayerViewPlayCompletedNotification @"LSPlayerViewPlayCompletedNotification"

@interface LSPlayerView : UIView

//视频URL
@property (nonatomic, copy) NSString* videoURL;

//返回按钮点击事件
@property (nonatomic, copy) void (^backBlock)();

//当前显示的frame
@property (nonatomic, assign) CGRect currentFrame;

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UITableView* tempSuperView;
//创建
+ (instancetype)playerView;

#pragma mark - 关闭按钮点击事件
- (void)closeClick;
@end
