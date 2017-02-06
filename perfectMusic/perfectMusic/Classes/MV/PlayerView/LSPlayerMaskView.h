//
//  LSPlayerMaskView.h
//  LSPlayer
//
//  Created by ls on 16/3/8.
//  Copyright © 2016年 song. All rights reserved.
//

#import <UIKit/UIKit.h>

// 图片路径
#define LSPlayerViewSrcName(file) [@"playerView.bundle" stringByAppendingPathComponent:file]

@interface LSPlayerMaskView : UIView

@property (weak, nonatomic) IBOutlet UISlider *slider;

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;

@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@property (weak, nonatomic) IBOutlet UIButton *fullButton;


@property (weak, nonatomic) IBOutlet UILabel *speedLabel;

+(instancetype)playerMaskView;

@end
