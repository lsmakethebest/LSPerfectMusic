



//
//  LSPlayerMaskView.m
//  LSPlayer
//
//  Created by ls on 16/3/8.
//  Copyright © 2016年 song. All rights reserved.
//

#import "LSPlayerMaskView.h"

@interface LSPlayerMaskView ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progressCenterY;

@end

@implementation LSPlayerMaskView

+(instancetype)playerMaskView
{
    LSPlayerMaskView *playerMaskView=[[[NSBundle mainBundle]loadNibNamed:@"LSPlayerMaskView" owner:nil options:nil]lastObject];
    return playerMaskView;
}
-(void)awakeFromNib
{
    [self.closeButton setImage:[UIImage imageNamed:LSPlayerViewSrcName(@"close_btn_normal")] forState:UIControlStateNormal];
    // 设置slider
    
    [self.slider setThumbImage:[UIImage imageNamed:LSPlayerViewSrcName(@"slider")] forState:UIControlStateNormal];
    self.slider.minimumTrackTintColor = [UIColor whiteColor];
    self.slider.maximumTrackTintColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.6];
    self.progressView.progressTintColor = [UIColor colorWithRed:0.727 green:0.934 blue:0.871 alpha:0.517];
    self.progressView.trackTintColor = [UIColor clearColor];
    self.progressView.userInteractionEnabled=NO;
    self.progressCenterY.constant=-0.5;//调整偏差
    self.progressView.layer.cornerRadius=1.2;
    self.progressView.clipsToBounds=YES;

    
    [self.playButton setImage:[UIImage imageNamed:LSPlayerViewSrcName(@"Pause")] forState:UIControlStateHighlighted|UIControlStateSelected];
    
    [self.playButton setImage:[UIImage imageNamed:LSPlayerViewSrcName(@"Pause")] forState:UIControlStateSelected];
    [self.playButton setImage:[UIImage imageNamed:LSPlayerViewSrcName(@"playMiniNormal")] forState:UIControlStateNormal];
    
    [self.fullButton setImage:[UIImage imageNamed:LSPlayerViewSrcName(@"enterFullNormal")] forState:UIControlStateNormal];
    [self.fullButton setImage:[UIImage imageNamed:LSPlayerViewSrcName(@"enterFullNormal")] forState:UIControlStateHighlighted|UIControlStateNormal];
    [self.fullButton setImage:[UIImage imageNamed:LSPlayerViewSrcName(@"video-player-shrinkscreen")] forState:UIControlStateSelected];
     [self.fullButton setImage:[UIImage imageNamed:LSPlayerViewSrcName(@"video-player-shrinkscreen")] forState:UIControlStateHighlighted|UIControlStateSelected];
    
}
@end
