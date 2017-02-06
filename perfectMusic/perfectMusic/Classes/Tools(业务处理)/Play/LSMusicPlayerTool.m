

//
//  LSMusicPlayerTool.m
//  perfectMusic
//
//  Created by song on 15/10/14.
//  Copyright © 2015年 song. All rights reserved.
//

#import "LSMusicList.h"
#import "LSMusicModel.h"
#import "LSMusicPlayerTool.h"
#import "LSPlayQueue.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
static LSMusicPlayerTool* tool;
@interface LSMusicPlayerTool () <AVAudioPlayerDelegate>
@property (nonatomic, strong) AVAudioPlayer* player;
@property (nonatomic, strong) NSTimer* timer;
@property (nonatomic, assign, getter=isFirst) BOOL first;
@property (nonatomic, assign) BOOL interrupted;
@property (nonatomic, strong) LSMusicModel *model;
@end
@implementation LSMusicPlayerTool

+ (instancetype)sharedMusicPlayerTool
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [[self alloc] init];
        AVAudioSession* session = [[AVAudioSession alloc] init];
        [session setActive:YES error:NULL];
        [session setCategory:AVAudioSessionCategoryPlayback error:NULL];
        
    });
    return tool;
}

- (void)handle:(NSNotification*)note
{
    
    AVAudioSessionInterruptionType key=[note.userInfo[AVAudioSessionInterruptionTypeKey] longLongValue];
    if (key==AVAudioSessionInterruptionTypeBegan) {
        [[LSMusicPlayerTool sharedMusicPlayerTool] pause];
    }
    else if (key == AVAudioSessionInterruptionTypeEnded) {
        [[LSMusicPlayerTool sharedMusicPlayerTool] resume];
    }
}
+ (instancetype)allocWithZone:(struct _NSZone*)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [super allocWithZone:zone];
    });
    return tool;
}

- (void)playWithModel:(LSMusicModel *)model
{

    self.model=model;
    NSString *urlStr=[LSMusicList  urlWithString:model.name];
    NSURL *url=[NSURL URLWithString:urlStr];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL];
    self.player.delegate = self;
    self.state = LSMusicPlayerToolPlayStatePrepare;
    [self.player prepareToPlay];
    [self.player play];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handle:) name:AVAudioSessionInterruptionNotification object:[AVAudioSession sharedInstance]];//中断
    
    [self setPlayingInfoWithModel:model time:0];
    self.state = LSMusicPlayerToolPlayStatePlaying;
    if (self.timer == nil) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(progress) userInfo:nil repeats:YES];
    }
}
- (void)setPlayingInfoWithModel:(LSMusicModel*)model time:(NSInteger)currentTime
{
    //    设置后台播放时显示的东西，例如歌曲名字，图片等
    //    <MediaPlayer/MediaPlayer.h>
    
    MPMediaItemArtwork* artWork = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:@"1"]];
    NSString* time = [NSString stringWithFormat:@"%lf", self.player.duration];
    NSDictionary* dic = @{ MPMediaItemPropertyTitle : model.name,
        MPMediaItemPropertyArtist : model.singer,
        MPMediaItemPropertyArtwork : artWork,
        MPNowPlayingInfoPropertyElapsedPlaybackTime:@(currentTime),
        MPMediaItemPropertyPlaybackDuration : time
    };
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dic];
}

//定时器回调方法
- (void)progress
{
    CGFloat progress = self.player.currentTime / self.player.duration;
    [[NSNotificationCenter defaultCenter] postNotificationName:LSMusicPlayerToolProgressChangeNotification object:nil userInfo:@{ LSMusicPlayerToolProgressChangeNotificationKey : @(progress) }];
}
- (void)playAtPosition:(CGFloat)position
{
    self.player.currentTime = position * self.player.duration;
    [self setPlayingInfoWithModel:self.model time:position * self.player.duration];
}
- (void)pause
{
    [self.player pause];
    
    [self setPlayingInfoWithModel:self.model time:self.player.currentTime];
    [self.timer invalidate];
    self.timer = nil;
    self.state = LSMusicPlayerToolPlayStatePause;
    
}
- (void)resume
{

    
    [self.player prepareToPlay];
    [self.player play];
       [self setPlayingInfoWithModel:self.model time:self.player.currentTime];
    if (self.timer == nil) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(progress) userInfo:nil repeats:YES];
    }
    self.state = LSMusicPlayerToolPlayStatePlaying;
}
#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer*)player successfully:(BOOL)flag
{
    self.state = LSMusicPlayerToolPlayStateStop;
    [[NSNotificationCenter defaultCenter] postNotificationName:LSMusicPlayerToolMusicFinishNotificatin object:nil];
}
- (void)setState:(LSMusicPlayerToolPlayState)state
{
    _state = state;
    [[NSNotificationCenter defaultCenter] postNotificationName:LSMusicPlayerToolStateChangedNotification object:nil];
}
@end
