

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
+ (instancetype)allocWithZone:(struct _NSZone*)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [super allocWithZone:zone];
    });
    return tool;
}

- (void)playWithURL:(NSURL*)url
{

    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL];
    self.player.delegate = self;
    self.state = LSMusicPlayerToolPlayStatePrepare;
    [self.player play];
    [self setPlayingInfoWithUrl:url];
    self.state = LSMusicPlayerToolPlayStatePlaying;
    if (self.timer == nil) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(progress) userInfo:nil repeats:YES];
    }
}
- (void)setPlayingInfoWithUrl:(NSURL*)url
{
    //    设置后台播放时显示的东西，例如歌曲名字，图片等
    //    <MediaPlayer/MediaPlayer.h>
    NSString *name=[[url.absoluteString componentsSeparatedByString:@"/"]lastObject];
    name=[name stringByRemovingPercentEncoding];
    name=[name substringToIndex:name.length-4];
    MPMediaItemArtwork* artWork = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:@"1"]];
    NSString* time = [NSString stringWithFormat:@"%lf", self.player.duration];
    NSDictionary* dic = @{ MPMediaItemPropertyTitle : url.absoluteString,
        MPMediaItemPropertyArtist : name,
        MPMediaItemPropertyArtwork : artWork,
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
}
- (void)pause
{
    [self.player pause];
    [self.timer invalidate];
    self.timer = nil;
    self.state = LSMusicPlayerToolPlayStatePause;
}
- (void)resume
{
    [self.player play];
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
