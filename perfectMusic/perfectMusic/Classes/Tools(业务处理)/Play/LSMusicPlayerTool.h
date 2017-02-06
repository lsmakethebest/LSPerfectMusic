//
//  LSMusicPlayerTool.h
//  perfectMusic
//
//  Created by song on 15/10/14.
//  Copyright © 2015年 song. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSMusicModel.h"
#define LSMusicPlayerToolProgressChangeNotification @"LSMusicPlayerToolProgressChangeNotification"
#define LSMusicPlayerToolProgressChangeNotificationKey @"LSMusicPlayerToolProgressChangeNotificationKey"

#define LSMusicPlayerToolStateChangedNotification @"LSMusicPlayerToolStateChangedNotification"
#define LSMusicPlayerToolStateChangedNotificationKey @"LSMusicPlayerToolStateChangedNotificationKey"

#define LSMusicPlayerToolMusicFinishNotificatin @"LSMusicPlayerToolMusicFinishNotificatin"
#define LSMusicPlayerToolMusicFinishNotificatinKey @"LSMusicPlayerToolMusicFinishNotificatinKey"
typedef enum
{
    LSMusicPlayerToolPlayStatePrepare,
    LSMusicPlayerToolPlayStatePlaying,
    LSMusicPlayerToolPlayStatePause,
    LSMusicPlayerToolPlayStateStop
    
}LSMusicPlayerToolPlayState ;

@interface LSMusicPlayerTool : NSObject
@property(nonatomic,assign) LSMusicPlayerToolPlayState state;
+(instancetype)sharedMusicPlayerTool;
//播放
-(void)playWithModel:(LSMusicModel*)model;
//播放指定时间歌曲
-(void)playAtPosition:(CGFloat)position;
//暂停
-(void)pause;
//继续
-(void)resume;


@end
