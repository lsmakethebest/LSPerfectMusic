//
//  LSPlayBottomView.m
//  perfectMusic
//
//  Created by song on 15/10/26.
//  Copyright © 2015年 song. All rights reserved.
//

#import "LSPlayBottomView.h"
#import "LSQueueView.h"
#import "LSPlayQueue.h"
#import "LSMusicModel.h"
#import "LSMusicPlayerTool.h"
#import "LSMusicList.h"
@interface LSPlayBottomView ()<LSQueueViewDelegate>

- (IBAction)shadowClick;
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
@property (weak, nonatomic) IBOutlet UIImageView *albumImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *singerLabel;
@property (nonatomic, weak) LSQueueView *queueView;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property(nonatomic,assign,getter=isPress) BOOL press;
- (IBAction)playBtn:(UIButton *)sender;
- (IBAction)nextBtn:(UIButton *)sender;
- (IBAction)queueClick:(UIButton *)sender;
- (IBAction)valueChanged:(UISlider *)sender;

@end
static LSPlayBottomView *_view=nil;
@implementation LSPlayBottomView

+(instancetype)sharedPlayBottomView
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _view=[[[NSBundle mainBundle]loadNibNamed:@"LSPlayBottomView" owner:nil options:nil]lastObject];
    });
    return _view;
    
}
-(void)awakeFromNib
{
    self.progressSlider.value=0.f;
    [self.progressSlider setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateNormal];
    //自己监听播放下标改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(indexChange:) name:LSPlayQueueChangeIndexNotification object:nil];
    //自己监听进度改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(progressChange:) name:LSMusicPlayerToolProgressChangeNotification object:nil];
    //自己监听播放状态变化通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stateChange) name:LSMusicPlayerToolStateChangedNotification object:nil];
    //自己监听播放完通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nextBtn:) name:LSMusicPlayerToolMusicFinishNotificatin object:nil];
}
-(void)stateChange
{
    switch ([LSMusicPlayerTool sharedMusicPlayerTool].state) {
        case LSMusicPlayerToolPlayStatePause:
            self.playBtn.selected=NO;
            break;
        case LSMusicPlayerToolPlayStatePlaying:
            self.playBtn.selected=YES;
            break;
        case LSMusicPlayerToolPlayStateStop:
            self.playBtn.selected=NO;
            break;
            
        default:
            break;
    }
    
}
-(void)progressChange:(NSNotification*)note
{
    NSNumber *number=note.userInfo[LSMusicPlayerToolProgressChangeNotificationKey];
    CGFloat progress=number.doubleValue;
    self.progressSlider.value=(self.progressSlider.maximumValue-self.progressSlider.minimumValue)*progress;
}
-(void)indexChange:(NSNotification*)note
{
    NSNumber *number=note.userInfo[LSPlayQueueChangeIndexNotificationKey];
    LSMusicModel *model=[LSPlayQueue sharedPlayQueue].queue[number.intValue];
    self.nameLabel.text=model.name;
    self.singerLabel.text=model.singer;
}
//播放暂停按钮点击事件
- (IBAction)playBtn:(UIButton *)sender {
    
    switch ([LSMusicPlayerTool sharedMusicPlayerTool].state) {
        case LSMusicPlayerToolPlayStatePause:
            [[LSMusicPlayerTool sharedMusicPlayerTool] resume];
            break;
        case LSMusicPlayerToolPlayStatePlaying:
            [[LSMusicPlayerTool sharedMusicPlayerTool] pause];
            break;
        case LSMusicPlayerToolPlayStatePrepare:
        {
            NSInteger index=[LSPlayQueue sharedPlayQueue].currentIndex;
            LSMusicModel *model=[LSPlayQueue sharedPlayQueue].queue[index];
            [[LSMusicPlayerTool sharedMusicPlayerTool] playWithModel:model];
        }
        default:
            break;
    }
    
}

- (IBAction)nextBtn:(UIButton *)sender {
    LSMusicModel *model=[[LSPlayQueue sharedPlayQueue] getNextModel];
    [[LSMusicPlayerTool  sharedMusicPlayerTool] playWithModel:model];
    
}
//点击队列按钮
- (IBAction)queueClick:(UIButton *)sender {
    if (!self.isPress) {
        LSQueueView *queueView=[LSQueueView queueView];
        [queueView reloadTableView];
        queueView.delegate=self;
        queueView.width=LSScreenWidth;
        queueView.y=LSScreenHeight;
        queueView.height=LSScreenHeight-self.height;
        [[self viewController].view insertSubview:queueView belowSubview:self];
        queueView.backgroundColor=[UIColor clearColor];
        [UIView animateWithDuration:0.3 animations:^{
            
            queueView.transform=CGAffineTransformMakeTranslation(0, -queueView.height-self.height);
        } completion:^(BOOL finished) {
            queueView.backgroundColor=queueView.backgroundColor=[UIColor colorWithWhite:0.2 alpha:0.2];
        }];
        self.queueView=queueView;
        self.press=YES;
    }else{
        [self.queueView dismiss];
        self.press=NO;
    }
}
//滑块拖动改变事件
- (IBAction)valueChanged:(UISlider *)sender {
    [[LSMusicPlayerTool sharedMusicPlayerTool] playAtPosition:(sender.value/sender.maximumValue) ];
}
//queueview代理事件
-(void)queueViewClick:(LSQueueView *)queueView
{
    self.press=NO;
}

//底部视图点击
- (IBAction)shadowClick {
    
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
+(CGFloat)height
{
    return 70;
}
@end
