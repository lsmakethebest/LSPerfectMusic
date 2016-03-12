
//
//  LSNewFeatureCell.m
//  至美微博
//
//  Created by ls on 15/10/4.
//  Copyright © 2015年 ls. All rights reserved.
//

#import "LSNewFeatureCell.h"
#import "LSChooseRootController.h"
@interface LSNewFeatureCell ()

@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UIButton *startButton;
@end
@implementation LSNewFeatureCell

- (UIImageView *)imageView
{
    if (_imageView == nil) {
        
        UIImageView *imageV = [[UIImageView alloc] init];
        
        _imageView = imageV;
        
        // 注意:一定要加载contentView
        [self.contentView addSubview:imageV];
        
    }
    return _imageView;
}



- (UIButton *)startButton
{
    if (_startButton == nil) {
        UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [startBtn setImage:[UIImage imageNamed:@"introduction_enter_nomal"] forState:UIControlStateNormal];
        [startBtn setImage:[UIImage imageNamed:@"introduction_enter_press"] forState:UIControlStateNormal];
        [startBtn sizeToFit];
        [startBtn addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:startBtn];
        _startButton = startBtn;
        
    }
    return _startButton;
}
-(void)setImage:(UIImage *)image
{
    _image=image;
    self.imageView.image=image;
    
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.backgroundColor=[UIColor redColor];
    
    self.imageView.frame=self.bounds;
    // 分享按钮

    
    
    // 开始按钮
    self.startButton.center = CGPointMake(self.width * 0.5, self.height * 0.85);
}
// 判断当前cell是否是最后一页
- (void)setIndexPath:(NSIndexPath *)indexPath count:(int)count
{
    if (indexPath.item == count - 1) { // 最后一页,显示分享和开始按钮

        self.startButton.hidden = NO;
        
        
    }else{ // 非最后一页，隐藏分享和开始按钮

        self.startButton.hidden = YES;
    }
}
-(void)start
{
    //进入tabbarcontroller

    [LSChooseRootController chooseRootController:LSKeyWindow];
    
}

@end
