//
//  LSPlayQueue.h
//  perfectMusic
//
//  Created by song on 15/10/26.
//  Copyright © 2015年 song. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
#define LSAllLocalList @"#########LSAllLocalList"
#define LSAllLikeList @"##########LSAllLikeList"
#define LSPlayQueueChangeIndexNotificationKey @"LSPlayQueueChangeIndexNotification"
#define LSPlayQueueChangeModeNotification @"LSPlayQueueChangeModeNotification"
#define LSPlayQueueChangeModeNotificationKey @"LSPlayQueueChangeModeNotificationKey"
extern NSString *const LSPlayQueueChangeIndexNotification;


typedef enum
{
    LSPlayQueueModeCycle,
    LSPlayQueueModeRandom,
    LSPlayQueueModeSingleCycle
}LSPlayQueueMode;

@class LSMusicModel;
@interface LSPlayQueue : NSObject

@property (nonatomic, strong,readonly) NSArray *queue;
@property(nonatomic,assign) NSInteger currentIndex;
@property (nonatomic, copy) NSString *listName;
@property(nonatomic,assign) LSPlayQueueMode mode;
singalton_h(PlayQueue);
-(void)setPlayQueue:(NSString *)listName currentIndex:(LSMusicModel *)musicModel orIndex:(NSInteger)index;
-(LSMusicModel*)getNextModel;
-(void)updatePlayMode;

@end
