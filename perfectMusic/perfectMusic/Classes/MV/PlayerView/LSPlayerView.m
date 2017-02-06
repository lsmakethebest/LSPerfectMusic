

//
//  LSPlayerView.m
//  LSPlayer
//
//  Created by ls on 16/3/8.
//  Copyright © 2016年 song. All rights reserved.
//

#import "AFNetworkReachabilityManager.h"
#import "LSNetworkSpeed.h"
#import "LSPlayerMaskView.h"
#import "LSPlayerView.h"
#import "LSTopWindow.h"
#import "NetworkReachabilityManager.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import <Accelerate/Accelerate.h>
#import <MediaPlayer/MediaPlayer.h>
#define kLSPlayerViewContentOffset @"contentOffset"

#define CellImageViewHeight 200

#ifdef DEBUG
#define LSLog(...) NSLog(__VA_ARGS__)
#else
#define LSLog(...)
#endif

@interface LSPlayerView () <UIGestureRecognizerDelegate, UIAlertViewDelegate, AVAssetResourceLoaderDelegate>

@property (nonatomic, strong) NSTimer* timer;

@property (nonatomic, strong) AVPlayer* player;

@property (nonatomic, strong) AVPlayerItem* playerItem;
@property (nonatomic, strong) AVURLAsset* urlAsset;

//所处位置
@property (nonatomic, assign) LSPlayerViewLocationType locationType;

//是否全屏
@property (nonatomic, assign, getter=isFullScreen) BOOL fullScreen;

//记录失去焦点时的p屏幕状态
@property (nonatomic, assign) UIDeviceOrientation lastDeviceOrientation;

//是否上锁
@property (nonatomic, assign) BOOL isLocked;

//@property (nonatomic, assign) BOOL isNewworkBad;
//@property (nonatomic, assign) BOOL isAlreadyPlayed; //判断在网络不好的情况下是否播放过还是就压根没有播放成功
//@property (nonatomic, assign) BOOL isSendConnect; //断网后会自动发起连接

//是否隐藏maskView
@property (nonatomic, assign, getter=isHideMaskView) BOOL hideMaskView;

//播放是否失败决定是否显示重试
@property (nonatomic, assign) BOOL isFailed;

//蒙板
@property (nonatomic, weak) LSPlayerMaskView* playerMaskView;

//重新重试按钮
@property (weak, nonatomic) IBOutlet UIButton* retryButton;

//重试按钮提示语
@property (weak, nonatomic) IBOutlet UILabel* retryTipLabel;

//是否隐藏maskView
@property (nonatomic, assign) BOOL isHideMaskView;

//当前设备方向
@property (nonatomic, assign) UIInterfaceOrientation currentOrientation;

//竖屏frame
@property (nonatomic, assign) CGRect portraitFrame;

//拖拽手势
@property (nonatomic, strong) UIPanGestureRecognizer* panGesture;

//标志是否监听过contentOffset
@property (nonatomic, assign, getter=isMonitoring) BOOL monitoring;

//捏合手势
@property (nonatomic, strong) UIPinchGestureRecognizer* pinchGesture;

//标记是否失去焦点
@property (nonatomic, assign, getter=isLoseActive) BOOL loseActive;

@property (nonatomic, assign) BOOL leftVertialMoved;

@property (nonatomic, strong) UISlider* volumeViewSlider;
@property (weak, nonatomic) IBOutlet UILabel* lightLabel;
@property (nonatomic, assign) BOOL allowWWAN;
@property (nonatomic, assign) BOOL startedAlertView;
@property (nonatomic, weak) IBOutlet UIImageView* backgroundImageView;

@property (nonatomic, assign) LSPlayerStatus playerStatus;
@end

@implementation LSPlayerView

static LSPlayerView* playerView = nil;
static LSTopWindow* window = nil;

- (LSTopWindow*)topWindow
{
    if (window == nil) {
        window = [[LSTopWindow alloc] init];
        window.backgroundColor = [UIColor clearColor];
        window.windowLevel = UIWindowLevelAlert;
    }
    return window;
}
+ (instancetype)playerView
{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        playerView = [[[NSBundle mainBundle] loadNibNamed:@"LSPlayerView" owner:nil options:nil] lastObject];
        
    });
    
    return playerView;
}
#pragma mark - 初始化playerView事件
- (void)initPlayerViewEvents
{
    
    self.lightLabel.hidden = YES;
    [self getVolume];
    //捏合手势
    UIPinchGestureRecognizer* pinGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    [self addGestureRecognizer:pinGesture];
    pinGesture.enabled = NO;
    self.pinchGesture = pinGesture;
    
    //拖拽手势
    UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [self addGestureRecognizer:panGesture];
    panGesture.delegate = self;
    self.panGesture = panGesture;
    
    //单击手势
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    [self addGestureRecognizer:tap];
    
    //重新尝试按钮
    [self.retryButton addTarget:self action:@selector(retryButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.locationType = LSPlayerViewLocationTypeMiddle; //需放在添加手势后面 因为手势禁用根据所处位置在set方法里
    
    //监听失去焦点通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
}
- (void)awakeFromNib
{
    
    [self.retryButton setImage:[UIImage imageNamed:LSPlayerViewSrcName(@"movieRetryButton")] forState:UIControlStateNormal];
    [self listeningRotating];
    [self initPlayerViewEvents];
    
    self.backgroundImageView.image = [self boxblurImageWithBlur:0.3];
    self.backgroundImageView.clipsToBounds = YES;
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.backgroundColor = [UIColor blackColor];
    
    //减小系统开销
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    CGPathRef path = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    [self.layer setShadowPath:path];
}
#pragma mark - 捏合手势

- (void)handlePinchGesture:(UIPinchGestureRecognizer*)gesture
{
    
    LSLog(@"捏合手势");
    if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled || gesture.state == UIGestureRecognizerStateFailed) {
        self.panGesture.enabled = YES;
        return;
    }
    self.panGesture.enabled = NO;
    //    self.transform=CGAffineTransformScale(self.transform, gesture.scale, gesture.scale);
    CGSize newSize = CGSizeMake([self topWindow].frame.size.width * gesture.scale, [self topWindow].frame.size.height * gesture.scale);
    CGSize size = [UIScreen mainScreen].bounds.size;
    if (newSize.width > size.width) {
        
        LSLog(@"捏合手势结束了啦啦啦啦");
        //        self.transform = CGAffineTransformIdentity;
        gesture.enabled = NO;
        self.panGesture.enabled = NO;
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:3 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            [self topWindow].frame = CGRectMake(0, [self topWindow].frame.origin.y, size.width, CellImageViewHeight);
        }
                         completion:^(BOOL finished) {
                             gesture.enabled = YES;
                             self.panGesture.enabled = YES;
                             
                         }];
    }
    else if (newSize.width < 200) {
    }
    else {
        CGRect frame = [self topWindow].frame;
        CGSize size = frame.size;
        CGFloat scale = gesture.scale;
        [self topWindow].frame = CGRectMake(frame.origin.x - (size.width * scale - size.width) / 2, frame.origin.y - (size.height * scale - size.height) / 2, size.width * scale, size.height * scale);
    }
    [gesture setScale:1];
}
#pragma mark - 拖拽手势处理
- (void)handlePanGesture:(UIPanGestureRecognizer*)gesture
{
    if (gesture.numberOfTouches > 1)
        return;
    
    //全屏状态下
    if (self.fullScreen) {
        static BOOL progress = YES;
        static CGFloat currentTime;
        static CGFloat totalTime;
        static int lastTime;
        CGPoint velocity = [gesture velocityInView:gesture.view];
        switch (gesture.state) {
            case UIGestureRecognizerStateBegan: {
                if (fabs(velocity.x) > fabs(velocity.y)) { //水平移动
                    
                    currentTime=self.playerItem.currentTime.value/self.playerItem.currentTime.timescale;
                    totalTime=self.playerItem.duration.value/self.playerItem.duration.timescale;
                    progress = YES;
                }
                else {
                    progress = NO;
                    if ([gesture locationInView:gesture.view].x < [UIScreen mainScreen].bounds.size.width / 2) { //左侧
                        self.leftVertialMoved = YES;
                    }
                    else { //右侧
                        self.leftVertialMoved = NO;
                    }
                }
                
                break;
            }
            case UIGestureRecognizerStateChanged:
                
                if (progress) {
                    
                    CGPoint point=[gesture translationInView:gesture.view];
                    CGFloat time=point.x/[UIScreen mainScreen].bounds.size.width*totalTime;
                    currentTime+=time;
                    [gesture setTranslation:CGPointZero inView:gesture.view];
                    self.lightLabel.hidden = NO;
                    lastTime=(int)currentTime;
                    if (lastTime<0) {
                        lastTime=0;
                    }else if (lastTime>totalTime)
                    {
                        lastTime=(int)totalTime;
                    }
                    self.lightLabel.text = [self durationStringWithTime:lastTime];
                }
                else {
                    if (self.leftVertialMoved) {
                        [UIScreen mainScreen].brightness -= velocity.y / 2000;
                        self.lightLabel.text = [NSString stringWithFormat:@"亮度:%.0lf", [UIScreen mainScreen].brightness * 100];
                        self.lightLabel.hidden = NO;
                    }
                    else {
                        self.volumeViewSlider.value -= velocity.y / 2000;
                    }
                }
                break;
            case UIGestureRecognizerStateEnded:
            case UIGestureRecognizerStateFailed:
            case UIGestureRecognizerStateCancelled:
                if (progress) {
                    
                    CMTime dragedCMTime = CMTimeMake(lastTime, 1);
                    //此方法比 seekToTime 精确
                    [self.player seekToTime:dragedCMTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
                }
                self.lightLabel.hidden = YES;
                break;
            default:
                break;
        }
        
        return;
    }
    //不在全屏状态下 是拖动
    if (self.locationType == LSPlayerViewLocationTypeTop) {
        //从上开始滑动
        [self handlePanTopGesture:gesture];
    }
    else {
        //从下开始滑动
        [self handlePanBottomGesture:gesture];
    }
}
//获取系统音量
- (void)getVolume
{
    MPVolumeView* volumeView = [[MPVolumeView alloc] init];
    _volumeViewSlider = nil;
    for (UIView* view in [volumeView subviews]) {
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]) {
            _volumeViewSlider = (UISlider*)view;
            break;
        }
    }
}
- (void)handlePanBottomGesture:(UIPanGestureRecognizer*)gesture
{
    CGPoint point = [gesture locationInView:[UIApplication sharedApplication].keyWindow];
    static CGPoint center;
    static CGPoint lastPoint;
    switch (gesture.state) {
            
        case UIGestureRecognizerStateBegan:
            lastPoint = point;
            center = window.center;
            
            break;
        case UIGestureRecognizerStateChanged: {
            LSLog(@"size==%@   拖拽位置   %@", NSStringFromCGPoint(self.center), NSStringFromCGPoint(point));
            CGPoint newCenter=CGPointMake(center.x + point.x - lastPoint.x, center.y + point.y - lastPoint.y);
            window.center =newCenter;
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        {
            CGSize size=[UIScreen mainScreen].bounds.size;
            CGPoint lastCenter=window.center;
            if (lastCenter.x<0) {
                lastCenter.x=0;
            }
            else if (lastCenter.x>size.width) {
                lastCenter.x=size.width;
            }
            
            //计算出tableView在window上的可视位置
            CGRect rect = CGRectIntersection([UIApplication sharedApplication].keyWindow.frame, self.tempSuperView.frame);
            if (lastCenter.y<0) {
                lastCenter.y=0;
            }
            else if (lastCenter.y>rect.size.height) {
                lastCenter.y=rect.size.height;
            }
            window.center=lastCenter;
        }
            break;
        default:
            break;
    }
}
- (void)handlePanTopGesture:(UIPanGestureRecognizer*)gesture
{
    CGPoint point = [gesture translationInView:gesture.view];
    switch (gesture.state) {
        case UIGestureRecognizerStatePossible:
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged:
            window.transform = CGAffineTransformTranslate(window.transform, 0, point.y);
            [gesture setTranslation:CGPointZero inView:gesture.view];
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
            //是从顶部拖动
            if (self.locationType == LSPlayerViewLocationTypeTop) {
                if (window.frame.origin.y + window.frame.size.height / 2 > [UIScreen mainScreen].bounds.size.height / 2) {
                    [UIView animateWithDuration:0.5 animations:^{
                        self.locationType = LSPlayerViewLocationTypeBottom;
                        window.transform = CGAffineTransformIdentity;
                        [self updataPlayerViewBottomFrame];
                        
                    }];
                }
                else {
                    [UIView animateWithDuration:0.5 animations:^{
                        window.transform = CGAffineTransformIdentity;
                    }];
                }
            }
            break;
    }
}
#pragma mark - playerView单击手势
- (void)tapClick
{
    
    if (self.isFullScreen) {
        [self topAndMiddleTapClick];
        return;
    }
    switch (self.locationType) {
        case LSPlayerViewLocationTypeMiddle: {
            [self topAndMiddleTapClick];
            break;
        }
        case LSPlayerViewLocationTypeTop: {
            [self topAndMiddleTapClick];
            break;
        }
        case LSPlayerViewLocationTypeBottom: {
            [self bottomTapClick];
            break;
        }
        case LSPlayerViewLocationTypeDragging: {
            
            break;
        }
    }
}
#pragma mark - BottomTapClick
- (void)bottomTapClick
{
    if (self.playerStatus==LSPlayerStatusPlaying||self.playerStatus==LSPlayerStatusPause) {
        [self playOrPause:self.playerMaskView.playButton];
    }
}

#pragma mark - TopAndMiddleTapClick
- (void)topAndMiddleTapClick
{
    if (self.isHideMaskView) {
        [self startShowMaskView];
    }
    else {
        [self nowHideMaskView];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        _allowWWAN = YES;
        if (_startedAlertView) {
            self.videoURL = _videoURL;
        }
        else {
            [self playOrPause:self.playerMaskView.playButton];
        }
    }
}
#pragma mark -  创建AVPlayer
- (void)setVideoURL:(NSString*)videoURL
{
    _videoURL = videoURL;
    NSLog(@"URLString======%@",videoURL);
    if (_allowWWAN == NO) {
        int type = [NetworkReachabilityManager sharedInstance].netType;
        if (type == 2) { //3G
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前网络为3G" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"继续", nil];
            _startedAlertView = YES;
            [alertView show];
            return;
        }
    }
    _allowWWAN = NO;
    self.backgroundImageView.hidden = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNetworkChange) name:LSNetworkChangeNotification object:nil];
    
    self.playerMaskView.speedLabel.text = @"0kB/s";
    [[LSNetworkSpeed shareNetworkSpeed] start];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(log) name:LSDownloadNetworkSpeedNotificationKey object:nil];
    self.playerMaskView.speedLabel.hidden = NO;
    
    playerView.hidden = NO;
    
    //一些值都清空还原
    self.playerMaskView.progressView.progress = 0;
    self.playerMaskView.slider.value = 0;
    self.playerMaskView.currentTimeLabel.text = @"00:00";
    self.playerMaskView.totalTimeLabel.text = @"/00:00";
    self.isFailed = NO;
    
    //恢复显示maskView及重置数值
    [self showMaskView];
    
    //每次都关闭定时器 只有readyPlay时才打开
    [self stopTimer];
    
    //每次都先移除监听
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
    
    if (self.playerItem) {
        [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
        [self.playerItem removeObserver:self forKeyPath:@"status"];
    }
    
    //第一次才添加
    if (self.superview == nil) {
        [self.tempSuperView addSubview:self];
    }
    if (self.locationType == LSPlayerViewLocationTypeMiddle) {
        if (!self.isMonitoring) {
            [self.tempSuperView addObserver:self forKeyPath:kLSPlayerViewContentOffset options:NSKeyValueObservingOptionNew context:nil];
            self.monitoring = YES;
        }
    }
    
    //第一次才创建
    if (self.playerMaskView == nil) {
        LSPlayerMaskView* playerMaskView = [LSPlayerMaskView playerMaskView];
        [self addSubview:playerMaskView];
        [self bringSubviewToFront:self.retryButton];
        self.playerMaskView = playerMaskView;
        
        //中间按钮点击事件
        [self.playerMaskView.playButton addTarget:self action:@selector(playOrPause:) forControlEvents:UIControlEventTouchUpInside];
        
        //全屏按钮点击事件
        [self.playerMaskView.fullButton addTarget:self action:@selector(clickFullScreen) forControlEvents:UIControlEventTouchUpInside];
        
        //关闭按钮点击事件
        [self.playerMaskView.closeButton addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
        
        //slider事件
        [self.playerMaskView.slider addTarget:self action:@selector(sliderTouchDown) forControlEvents:UIControlEventTouchDown];
        [self.playerMaskView.slider addTarget:self action:@selector(sliderTouchCancel:) forControlEvents:UIControlEventTouchCancel];
        [self.playerMaskView.slider addTarget:self action:@selector(sliderTouchCancel:) forControlEvents:UIControlEventTouchUpOutside];
        [self.playerMaskView.slider addTarget:self action:@selector(sliderTouchCancel:) forControlEvents:UIControlEventTouchUpInside];
        [self.playerMaskView.slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    
    self.playerItem = nil;
    
    //先暂停
    if (self.player) {
        [self.player pause];
        self.player = nil;
    }
    
    self.playerStatus = LSPlayerStatusReady;
    //创建   item  layer   player
    self.urlAsset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:videoURL] options:nil];
    [self.urlAsset.resourceLoader setDelegate:self queue:
     dispatch_get_main_queue()];
    
    self.playerItem = [AVPlayerItem playerItemWithAsset:_urlAsset];
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    
    //设置屏幕宽高
    if ([((AVPlayerLayer*)self.layer).videoGravity isEqualToString:AVLayerVideoGravityResizeAspect]) {
        ((AVPlayerLayer*)self.layer).videoGravity = AVLayerVideoGravityResizeAspect;
    }
    else {
        ((AVPlayerLayer*)self.layer).videoGravity = AVLayerVideoGravityResizeAspect;
    }
    
    //设置frame
    if (self.isFullScreen) {
        [self updatePlayerViewFrame];
//        if (self.locationType==LSPlayerViewLocationTypeMiddle) {
//            self.portraitFrame=self.currentFrame;
//        }
    }
    else {
        //只有在中间时才计算点击cell的位置
        if (self.locationType == LSPlayerViewLocationTypeMiddle) {
            self.frame = _currentFrame;
            [self handleScrollOffsetWithDict:nil]; //点击时处理位置
        }
    }
    
    //播放
    [self.player setRate:1];
    [self.player play];
    
    //开始加载动画
    [self startAnimation];
    
    // 监听缓冲进度
    [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    //监听播放状态
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
    //AVPlayer播放完成通知  item has played to its end time
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
    
    //AVPlayerItemPlaybackStalledNotification media did not arrive in time to continue playback
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stall) name:AVPlayerItemPlaybackStalledNotification object:self.playerItem];
    
    //        [self testAVPlayerNotification];
}
#pragma mark - slider开始触摸
- (void)sliderTouchDown
{
    [self stopTimer];
}
#pragma mark - slider值改变
- (void)sliderValueChanged:(UISlider*)slider
{
    int time = slider.value * _playerItem.duration.value / _playerItem.duration.timescale;
    self.playerMaskView.currentTimeLabel.text = [self durationStringWithTime:time];
}
#pragma mark - sliderr触摸取消
- (void)sliderTouchCancel:(UISlider*)slider
{
    
    //拖动改变视频播放进度
    if (self.player.status == AVPlayerStatusReadyToPlay) {
        //计算出拖动的当前秒数
        CGFloat total = (CGFloat)_playerItem.duration.value / _playerItem.duration.timescale;
        NSInteger dragedSeconds = floorf(total * slider.value);
        //转换成CMTime才能给player来控制播放进度
        CMTime dragedCMTime = CMTimeMake(dragedSeconds, 1);
        //此方法比 seekToTime 精确
        [self.player seekToTime:dragedCMTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
        [self createTimer];
    }
}

#pragma mark - 重试按钮点击事件
- (void)retryButtonClick:(UIButton*)sender
{
    //相当于重新点击播放按钮重新播放
    self.videoURL = self.videoURL;
}

#pragma mark - 长按手势 处理快进快退 亮度调节
- (void)handleLongGesture:(UILongPressGestureRecognizer*)gesture
{
    CGFloat x = [gesture locationInView:gesture.view].x;
    CGFloat duration = x / self.frame.size.width;
    LSLog(@"duration===%lf", duration);
}

#pragma mark -  蒙版中间按钮点击事件 播放 暂停
- (void)playOrPause:(UIButton*)sender
{
    
    if (self.playerStatus == LSPlayerStatusPlaying) {
        [self.player pause];
        [self stopTimer];
        self.playerStatus = LSPlayerStatusPause;
    }
    else if (self.playerStatus == LSPlayerStatusPause) {
        int type = [NetworkReachabilityManager sharedInstance].netType;
        if (type == 2 && !self.allowWWAN) { //3G
            [self showAlertView];
        }
        else {
            [self.player play];
            [self createTimer];
            self.playerStatus = LSPlayerStatusPlaying;
        }
    }
    else {
        self.videoURL = self.videoURL;
    }
    
    if (self.locationType == LSPlayerViewLocationTypeBottom) {
        sender.hidden = (self.playerStatus == LSPlayerStatusPlaying);
    }
    else {
        [self cancelPreviousPerformAndHideMaskView]; //因为触碰maskView了所以需要将延迟隐藏事件重置为7s
    }
}

- (void)setPlayerStatus:(LSPlayerStatus)playerStatus
{
    _playerStatus = playerStatus;
    self.playerMaskView.playButton.selected = (playerStatus == LSPlayerStatusPlaying);
}
#pragma mark - 关闭按钮点击事件
- (void)closeClick
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LSNetworkChangeNotification object:nil];
    _allowWWAN = NO;
    window.hidden = YES;
    LSLog(@"关闭了了了了了了了了%s", __func__);
    //关闭时一定要停止监听contentOffset
    
    //注意视频框加入在最上面时已经停止监听了 但是此时重新调用setVideoURL方法又会监听 然后点击关闭按钮 然后滚动tableView还会掉监听方法 移除也不好立刻停止而是毫秒级调用一次
    if (self.isMonitoring) {
        [self.tempSuperView removeObserver:self forKeyPath:kLSPlayerViewContentOffset];
    }
    self.monitoring = NO;
    //重新设置视频框位置为中间
    self.locationType = LSPlayerViewLocationTypeMiddle;
    self.transform = CGAffineTransformIdentity;
    self.playerMaskView.hidden = NO;
    self.playerMaskView.progressView.hidden = NO;
    self.playerMaskView.slider.hidden = NO;
    self.playerMaskView.currentTimeLabel.hidden = NO;
    self.playerMaskView.totalTimeLabel.hidden = NO;
    
    [self.player pause];
    
    if (self.superview != self.tempSuperView) {
        [self.tempSuperView addSubview:self];
    }
    
    playerView.hidden = YES;
    if (self.isFullScreen) {
        [self interfaceOrientation:UIInterfaceOrientationPortrait];
    }
    self.portraitFrame = CGRectZero;
    self.transform = CGAffineTransformIdentity;
}
#pragma mark -  创建定时器
- (void)createTimer
{
    if (self.timer == nil) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(startTime) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        //                [self.timer fire];
    }
}
#pragma mark - 停止计时器
- (void)stopTimer
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}
#pragma mark - 全屏按钮点击事件
- (void)clickFullScreen
{
    [self cancelPreviousPerformAndHideMaskView];
    if (self.isFullScreen) { //UIInterfaceOrientationPortrait
        [self interfaceOrientation:UIInterfaceOrientationPortrait];
    }
    else {
        [self interfaceOrientation:UIInterfaceOrientationLandscapeRight];
    }
}
- (void)setFullScreen:(BOOL)fullScreen
{
    
    if (fullScreen) { //由全屏进入后台 在进入前台 会显示全屏 但是一旋转frame跟全屏一样
        self.playerMaskView.playButton.hidden =(self.playerStatus==LSPlayerStatusFaild||self.playerStatus==LSPlayerStatusReady);
        self.pinchGesture.enabled = NO;
        self.panGesture.enabled = YES;
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        if (!(self.fullScreen )) {//上次不是全屏
            if (self.locationType == LSPlayerViewLocationTypeMiddle) {
                self.portraitFrame = self.frame;
            }
            else {
                self.portraitFrame = [self topWindow].bounds;
                [self topWindow].hidden = YES;
            }
        }
        [self handleTimeLabelAndSliderWithHidden:NO];
        [self updatePlayerViewFrame];
    }
    else {
        
        
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        if (self.locationType == LSPlayerViewLocationTypeBottom) {
            self.playerMaskView.playButton.hidden =(self.playerStatus==LSPlayerStatusFaild||self.playerStatus==LSPlayerStatusPlaying||self.playerStatus==LSPlayerStatusReady);
            window.hidden = NO;
            [self topWindow].contentView = self;
            self.playerMaskView.hidden = NO;
            [self handleTimeLabelAndSliderWithHidden:YES];
            self.panGesture.enabled = YES;
            self.pinchGesture.enabled = YES;
        }
        else if (self.locationType == LSPlayerViewLocationTypeMiddle) {
            self.playerMaskView.playButton.hidden =(self.playerStatus==LSPlayerStatusFaild||self.playerStatus==LSPlayerStatusReady);
            self.panGesture.enabled = NO;
            self.pinchGesture.enabled = NO;
            window.hidden = YES;
            [self removeFromSuperview];
            [self.tempSuperView addSubview:self];
            self.playerMaskView.closeButton.hidden = YES;
            
            //进入后台也会发出方向改变通知 但如果此前没有进入横屏过此时portraitFrame为 0
            if (!CGRectIsEmpty(self.portraitFrame)) {
                self.frame = self.portraitFrame;
            }
            [self handleScrollOffsetWithDict:nil];
            

        }
        else if (self.locationType == LSPlayerViewLocationTypeTop) {
            self.playerMaskView.playButton.hidden =(self.playerStatus==LSPlayerStatusFaild);
            [self topWindow].contentView = self;
            [self topWindow].hidden = NO;
            self.panGesture.enabled = YES;
            self.pinchGesture.enabled = NO;
        }
    }
    
    self.playerMaskView.fullButton.selected = fullScreen;
    _fullScreen = fullScreen;
}
#pragma mark - 立刻显示maskView不执行7s后自动隐藏
- (void)showMaskView
{
    self.playerMaskView.hidden = NO;
    self.hideMaskView = NO;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(nowHideMaskView) object:nil];
}
#pragma mark - 将要显示maskView
- (void)startShowMaskView
{
    if (self.isHideMaskView) {
        [UIView animateWithDuration:0.5 animations:^{
            self.playerMaskView.hidden = NO;
        }
                         completion:^(BOOL finished) {
                             self.hideMaskView = NO;
                             [self cancelPreviousPerformAndHideMaskView];
                             
                         }];
    }
}
#pragma mark -重新将延迟事件设置为7s
- (void)cancelPreviousPerformAndHideMaskView
{
    if (self.isHideMaskView)
        return;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(nowHideMaskView) object:nil];
    if (self.locationType != LSPlayerViewLocationTypeBottom) {
        [self performSelector:@selector(nowHideMaskView) withObject:nil afterDelay:7];
    }
}

#pragma mark - 隐藏maskView
- (void)nowHideMaskView
{
    if (!self.isHideMaskView) {
        [UIView animateWithDuration:0.5 animations:^{
            self.playerMaskView.hidden = YES;
        }
                         completion:^(BOOL finished) {
                             self.hideMaskView = YES;
                             
                         }];
    }
}

#pragma mark - 横屏frame
- (void)updatePlayerViewFrame
{
    
    //如果竖屏显示时在中间显示则superView为tableView
    [self removeFromSuperview];
    window.contentView = nil;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.frame = [UIScreen mainScreen].bounds;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}
#pragma mark - 定时器事件
- (void)startTime
{
    NSInteger b = CMTimeGetSeconds([_playerItem currentTime]);
    //    LSLog(@"sss======%ld", b);
    self.playerMaskView.slider.value = CMTimeGetSeconds([_playerItem currentTime]) / (_playerItem.duration.value / _playerItem.duration.timescale); //当前进度
    
    //当前播放时间
    NSInteger proMin = (NSInteger)CMTimeGetSeconds([self.player currentTime]) / 60; //当前秒
    NSInteger proSec = (NSInteger)CMTimeGetSeconds([self.player currentTime]) % 60; //当前分钟
    
    //duration 总时长
    NSInteger durMin = (NSInteger)_playerItem.duration.value / _playerItem.duration.timescale / 60; //总分
    NSInteger durSec = (NSInteger)_playerItem.duration.value / _playerItem.duration.timescale % 60; //总秒
    
    self.playerMaskView.currentTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", proMin, proSec];
    self.playerMaskView.totalTimeLabel.text = [NSString stringWithFormat:@"/%02ld:%02ld", durMin, durSec];
}
#pragma mark - 显示菊花 并因此播放按钮
- (void)startAnimation
{
    [self.playerMaskView.activity startAnimating];
    self.playerMaskView.activity.hidden = NO;
    self.playerMaskView.playButton.hidden = YES;
}
#pragma mark - 隐藏菊花
- (void)stopAnimation
{
    self.backgroundImageView.hidden = YES;
    [self.playerMaskView.activity stopAnimating];
    self.playerMaskView.activity.hidden = YES;
    self.playerMaskView.playButton.hidden = NO;
    
    if (self.locationType == LSPlayerViewLocationTypeBottom) {
        self.playerMaskView.playButton.hidden = YES;
    }
}

#pragma mark - 播放完成通知事件
- (void)moviePlayDidEnd:(NSNotification*)note
{
    
    LSLog(@"moviePlayDidEnd");
    //有时候有bug就是播放完时间和总时间差1s这里设置为一样
    self.playerMaskView.currentTimeLabel.text = [self.playerMaskView.totalTimeLabel.text substringFromIndex:1];
    self.playerMaskView.slider.value=1;
    [self stopTimer];
    [self showMaskView];
    self.playerStatus=LSPlayerStatusStop;
    self.playerMaskView.playButton.hidden = NO;
    if (self.fullScreen) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:LSPlayerViewPlayCompletedNotification object:@(self.index)];
    }
    
    
}
#pragma mark -  监听缓冲进度  KVO
- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary<NSString*, id>*)change context:(void*)context
{
    //当应用程序从后台进入前台时也会调用
    if (self.isLoseActive)
        return;
    if ([keyPath isEqualToString:@"status"]) {
        if ([self.playerItem status] == AVPlayerStatusReadyToPlay) { //准备播放
            LSLog(@"AVPlayerStatusReadyToPlay");
            self.playerStatus = LSPlayerStatusPlaying;
            [self createTimer];
            [self stopAnimation];
            [self cancelPreviousPerformAndHideMaskView]; //延迟隐藏
            [[LSNetworkSpeed shareNetworkSpeed] stop];
            self.playerMaskView.speedLabel.hidden = YES;
            // 转换成秒
            CGFloat totalSecond = self.playerItem.duration.value / self.playerItem.duration.timescale;
            self.playerMaskView.totalTimeLabel.text = [NSString stringWithFormat:@"/%@", [self durationStringWithTime:totalSecond]];
        }
        else if ([self.playerItem status] == AVPlayerStatusFailed) { //播放失败
            LSLog(@"AVPlayerStatusFailed");
            self.playerStatus=LSPlayerStatusFaild;
            [self stopAnimation];
            self.isFailed = YES;
        }
    }
    else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        // 计算缓冲进度
        NSTimeInterval timeInterval = [self availableDuration];
        CMTime duration = self.playerItem.duration;
        CGFloat totalDuration = CMTimeGetSeconds(duration);
        CGFloat progress = timeInterval / totalDuration;
        [self.playerMaskView.progressView setProgress:progress];
    }
    
    if (self.tempSuperView == nil)
        return;
    if (self.locationType != LSPlayerViewLocationTypeMiddle)
        return;
    if (self.isFullScreen)
        return;
    if (!self.isMonitoring)
        return;
    //此处需要判断全屏时不坚听contentOffset 让不然调用cellForIndexPath会出现崩溃bug
    //竖屏才监听contentOffset
    if ([keyPath isEqualToString:kLSPlayerViewContentOffset]) {
        if (([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft) || ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight))
            return;
        [self handleScrollOffsetWithDict:change];
    }
}
#pragma mark - 当tableview滚动时处理playerView的位置
- (void)handleScrollOffsetWithDict:(NSDictionary*)dict
{
    LSLog(@"%s", __func__);
    //测试证明在点击关闭按钮时会掉此方法
    UITableView* tableView = (UITableView*)self.tempSuperView;
    LSPlayerView* playerView = [LSPlayerView playerView];
    
    UITableViewCell* cell;
    CGRect rect;
    static NSInteger count;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        count = [tableView.dataSource numberOfSectionsInTableView:tableView];
    });
    if (count) { //是多组 每组一行
        cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.index]];
        rect = [tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.index]];
    }
    else { //只有一组 多行
        cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.index inSection:0]];
        rect = [tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:self.index inSection:0]];
    }
    
    CGFloat top = tableView.contentInset.top;
    CGPoint point = tableView.contentOffset;
    CGFloat y = point.y + top;
    if (self.currentFrame.origin.y - y > self.tempSuperView.frame.size.height - CellImageViewHeight - top) { //在底下
        playerView.locationType = LSPlayerViewLocationTypeBottom;
        
        [self updataPlayerViewBottomFrame];
        //        LSLog(@"在下面");
    }
    else if (y > rect.origin.y) {
        //在上面
        playerView.locationType = LSPlayerViewLocationTypeTop;
        [self updataPlayerViewTopFrame];
    }
}
#pragma mark - 底部视频框frame
- (void)updataPlayerViewBottomFrame
{
    CGSize size = [UIScreen mainScreen].bounds.size;
    //计算出tableView在window上的可视位置
    CGRect rect = CGRectIntersection([UIApplication sharedApplication].keyWindow.frame, self.tempSuperView.frame);
    [self topWindow].hidden = NO;
    [self topWindow].contentView = self;
    [self topWindow].frame = CGRectMake(size.width / 2.0, CGRectGetMaxY(rect) - CellImageViewHeight / 2.0, size.width / 2, CellImageViewHeight / 2.0);
    //强制让系统调用layoutSubviews 两个方法必须同时写
    //    [self setNeedsLayout]; //是标记 异步刷新 会调但是慢
    //    [self layoutIfNeeded]; //加上此代码立刻刷新
}
#pragma mark - 顶部视频框frame
- (void)updataPlayerViewTopFrame
{
    [self topWindow].frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, CellImageViewHeight);
    [self topWindow].hidden = NO;
    [self topWindow].contentView = self;
    //强制让系统调用layoutSubviews 两个方法必须同时写
    //    [self setNeedsLayout]; //是标记 异步刷新 会调但是慢
    //    [self layoutIfNeeded]; //加上此代码立刻刷新
}
#pragma mark - 获取缓冲进度
- (NSTimeInterval)availableDuration
{
    NSArray* loadedTimeRanges = [[self.player currentItem] loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue]; // 获取缓冲区域
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds; // 计算缓冲总进度
    return result;
}
#pragma mark - 根据时长求出字符串

- (NSString*)durationStringWithTime:(int)time
{
    // 获取分钟
    NSString* min = [NSString stringWithFormat:@"%02d", time / 60];
    // 获取秒数
    NSString* sec = [NSString stringWithFormat:@"%02d", time % 60];
    return [NSString stringWithFormat:@"%@:%@", min, sec];
}

#pragma mark 强制转屏相关

- (void)interfaceOrientation:(UIInterfaceOrientation)orientation
{
    self.currentOrientation = orientation;
    // arc下
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = orientation;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

#pragma mark - 将失去焦点通知
- (void)willResignActive
{
    self.loseActive = YES;
    if (!self.isFullScreen) {
        self.portraitFrame = self.frame;
    }
    self.lastDeviceOrientation = [UIDevice currentDevice].orientation;
    [self stopTimer];
    if (self.playerStatus == LSPlayerStatusPlaying) {
        [self playOrPause:self.playerMaskView.playButton];
    }
}
#pragma mark - 获取焦点通知
- (void)becomeActive
{
    self.loseActive = NO;
    [self interfaceOrientation:self.lastDeviceOrientation];
}

#pragma mark - 监听设备旋转方向
- (void)listeningRotating
{
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDeviceOrientationChange) name:UIDeviceOrientationDidChangeNotification object:nil];
}
- (void)handleDeviceOrientationChange
{
    if (self.isLoseActive)
        return;
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    //    if (self.lastDeviceOrientation==orientation) return;
    //    self.lastDeviceOrientation=orientation;
    switch (interfaceOrientation) {
            
        case UIInterfaceOrientationPortraitUpsideDown: {
            LSLog(@"第3个旋转方向---电池栏在下");
            
        } break;
        case UIInterfaceOrientationPortrait: {
            LSLog(@"第0个旋转方向---电池栏在上");
            
            self.fullScreen = NO;
            
        } break;
        case UIInterfaceOrientationLandscapeLeft: {
            LSLog(@"第2个旋转方向---电池栏在右"); //软件屏幕左右方向和设备左右是反的
            self.fullScreen = YES;
            
        } break;
        case UIInterfaceOrientationLandscapeRight: {
            self.fullScreen = YES;
            
        } break;
            
        default:
            break;
    }
}
#pragma mark - 视频框在底部时隐藏时间label slider
- (void)handleTimeLabelAndSliderWithHidden:(BOOL)hidden
{
    
    self.playerMaskView.currentTimeLabel.hidden = hidden;
    self.playerMaskView.totalTimeLabel.hidden = hidden;
    self.playerMaskView.slider.hidden = hidden;
    self.playerMaskView.progressView.hidden = hidden;
    self.playerMaskView.closeButton.hidden = NO;
}
- (void)setLocationType:(LSPlayerViewLocationType)locationType
{
    _locationType = locationType;
    switch (locationType) {
        case LSPlayerViewLocationTypeTop: {
            LSLog(@"在上面");
            self.playerMaskView.closeButton.hidden = NO;
            self.panGesture.enabled = YES;
            if (self.isMonitoring) {
                [self.tempSuperView removeObserver:self forKeyPath:kLSPlayerViewContentOffset];
            }
            self.monitoring = NO;
            self.pinchGesture.enabled = NO;
            break;
        }
        case LSPlayerViewLocationTypeMiddle: {
            LSLog(@"在中间");
            self.pinchGesture.enabled = NO;
            self.playerMaskView.closeButton.hidden = YES; //当在中间时隐藏关闭按钮
            self.panGesture.enabled = NO;
            break;
        }
        case LSPlayerViewLocationTypeBottom: {
            LSLog(@"在底下");
            self.pinchGesture.enabled = YES;
            if (self.isMonitoring) {
                [self.tempSuperView removeObserver:self forKeyPath:kLSPlayerViewContentOffset];
            }
            self.monitoring = NO;
            [[UIApplication sharedApplication] setStatusBarHidden:NO]; //次出会带来contentOffset变化导致在点击关闭按钮时
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(nowHideMaskView) object:nil];
            self.playerMaskView.hidden = NO;
            [self handleTimeLabelAndSliderWithHidden:YES];
            if (self.playerStatus==LSPlayerStatusPlaying) {
                self.playerMaskView.playButton.hidden = YES;
            }
            self.panGesture.enabled = YES;
            
            break;
        }
        case LSPlayerViewLocationTypeDragging: {
            
            break;
        }
    }
}

- (void)log
{
    
    //    LSLog(@"下载速度=======%@", [LSNetworkSpeed shareNetworkSpeed].downloadNetworkSpeed);
    self.playerMaskView.speedLabel.text = [LSNetworkSpeed shareNetworkSpeed].downloadNetworkSpeed;
}
#pragma mark - 高斯模糊
- (UIImage*)boxblurImageWithBlur:(CGFloat)blur
{
    
    NSData* imageData = UIImageJPEGRepresentation([UIImage imageNamed:LSPlayerViewSrcName(@"VideoCoverDefault")], 1); // convert to jpeg
    UIImage* destImage = [UIImage imageWithData:imageData];
    
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    
    CGImageRef img = destImage.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    
    vImage_Error error;
    
    void* pixelBuffer;
    
    //create vImage_Buffer with data from CGImageRef
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    //create vImage_Buffer for output
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    if (pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    // Create a third buffer for intermediate processing
    void* pixelBuffer2 = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    vImage_Buffer outBuffer2;
    outBuffer2.data = pixelBuffer2;
    outBuffer2.width = CGImageGetWidth(img);
    outBuffer2.height = CGImageGetHeight(img);
    outBuffer2.rowBytes = CGImageGetBytesPerRow(img);
    
    //perform convolution
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer2, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    error = vImageBoxConvolve_ARGB8888(&outBuffer2, &inBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(outBuffer.data, outBuffer.width, outBuffer.height, 8, outBuffer.rowBytes, colorSpace, (CGBitmapInfo)kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage(ctx);
    UIImage* returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    free(pixelBuffer2);
    CFRelease(inBitmapData);
    
    CGImageRelease(imageRef);
    
    return returnImage;
}

- (void)setCurrentFrame:(CGRect)currentFrame
{
    //高度默认W为图片高度
    currentFrame.size.height = CellImageViewHeight;
    _currentFrame = currentFrame;
}
- (void)setIsFailed:(BOOL)isFailed
{
    _isFailed = isFailed;
    self.retryButton.hidden = !isFailed;
    self.retryTipLabel.hidden = !isFailed;
    if (isFailed) {
        self.playerMaskView.playButton.hidden = YES;
    }
}
- (void)setIsHideMaskView:(BOOL)isHideMaskView
{
    _isHideMaskView = isHideMaskView;
    self.playerMaskView.hidden = isHideMaskView;
}
- (void)stall
{
    [self stopTimer];
    [self stopAnimation];
    self.playerMaskView.playButton.selected = NO;
    self.playerMaskView.playButton.hidden = NO;
    LSLog(@"%s", __func__);
}

- (void)showAlertView
{
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前网络为3G" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"继续", nil];
    _startedAlertView = NO;
    [alertView show];
}
+ (void)load
{
    [[NetworkReachabilityManager sharedInstance] startMonitoring];
}
- (void)handleNetworkChange
{
    int type = [NetworkReachabilityManager sharedInstance].netType;
    if (type == 2) { //3G
        [self.urlAsset cancelLoading];
        if (self.player.rate != 1)
            return;
        //停止缓冲并暂停
        self.playerMaskView.playButton.selected = YES;
        [self playOrPause:self.playerMaskView.playButton];
        [self showAlertView];
    }
}
#pragma mark - AVAssetResourceLoaderDelegate
- (void)resourceLoader:(AVAssetResourceLoader*)resourceLoader didCancelLoadingRequest:(AVAssetResourceLoadingRequest*)loadingRequest
{
}
- (BOOL)resourceLoader:(AVAssetResourceLoader*)resourceLoader shouldWaitForLoadingOfRequestedResource:(AVAssetResourceLoadingRequest*)loadingRequest
{
    
    return YES;
}
#pragma mark - UIGestureDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer*)otherGestureRecognizer
{
    
    LSLog(@"%@", otherGestureRecognizer.view.class);
    if (gestureRecognizer == self.panGesture && [otherGestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        return NO;
    }
    return YES;
    if (gestureRecognizer == self.panGesture && otherGestureRecognizer == self.pinchGesture) {
        return NO;
    }
    if (gestureRecognizer == self.pinchGesture && otherGestureRecognizer == self.panGesture) {
        return NO;
    }
    return YES;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.playerMaskView.frame = self.bounds;
}

+ (Class)layerClass
{
    return [AVPlayerLayer class];
}

- (AVPlayer*)player
{
    return [(AVPlayerLayer*)[self layer] player];
}

- (void)setPlayer:(AVPlayer*)player
{
    
    [((AVPlayerLayer*)[self layer]) setPlayer:player];
}
#pragma mark - AVPlayer通知测试

- (void)testAVPlayerNotification
{
    //测试在网络变化过程中通知的发送情况
    //AVPlayerItemTimeJumpedNotification  the item's current time has changed discontinuously
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jump) name:AVPlayerItemTimeJumpedNotification object:self.playerItem];
    
    //AVPlayerItemFailedToPlayToEndTimeNotification item has failed to play to its end time
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(failed) name:AVPlayerItemFailedToPlayToEndTimeNotification object:self.playerItem];
    
    //   //AVPlayerItemNewAccessLogEntryNotification a new access log entry has been added
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accessSuccess) name:AVPlayerItemNewAccessLogEntryNotification object:self.playerItem];
    
    //AVPlayerItemNewErrorLogEntryNotification  a new error log entry has been added
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accessError) name:AVPlayerItemNewErrorLogEntryNotification object:self.playerItem];
    
    //AVPlayerItemFailedToPlayToEndTimeErrorKey    // NSError
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(failedToPlay) name:AVPlayerItemFailedToPlayToEndTimeErrorKey object:self.playerItem];
}

- (void)jump
{
    
    LSLog(@"%s", __func__);
}
- (void)failed
{
    LSLog(@"%s", __func__);
}
- (void)accessSuccess
{
    LSLog(@"%s", __func__);
}
- (void)accessError
{
    LSLog(@"%s", __func__);
}
- (void)failedToPlay
{
    LSLog(@"%s", __func__);
}

@end
