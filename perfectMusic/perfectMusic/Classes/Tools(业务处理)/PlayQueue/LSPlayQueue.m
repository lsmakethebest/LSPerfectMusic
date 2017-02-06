




//
//  LSPlayQueue.m
//  perfectMusic
//
//  Created by song on 15/10/26.
//  Copyright © 2015年 song. All rights reserved.
//

#import "LSPlayQueue.h"
#import "LSMusicList.h"
#import "LSMusicModel.h"
#define LSPlayQueueModeKey @"LSPlayQueueModeKey"
NSString *const LSPlayQueueChangeIndexNotification=@"LSPlayQueueChangeIndexNotification";

static LSPlayQueue * _instance=nil;
@interface LSPlayQueue ()


@property (nonatomic, strong) LSMusicList *tool;
@end
@implementation LSPlayQueue
-(LSMusicList *)tool
{
    if (_tool==nil) {
        _tool=[LSMusicList musicList];
    }
    return _tool;
}

+(instancetype)sharedPlayQueue
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance=[[self alloc]init];
        
        _instance.mode=(LSPlayQueueMode)[[NSUserDefaults standardUserDefaults] doubleForKey:LSPlayQueueModeKey ];
        NSLog(@"mode===%d",_instance.mode);
        //                                                             integerForKey:LSPlayQueueMode];
    });
    return _instance;
}
-(void)setPlayQueue:(NSString *)listName currentIndex:(LSMusicModel *)musicModel orIndex:(NSInteger)index
{
    if (listName==nil) return;
    //判断所在列表名称
    if ([listName isEqualToString:LSAllLocalList]) {
        _queue=[self.tool getAllMusic];
    }else if ([listName isEqualToString:LSAllLikeList]){
        
        _queue=[self.tool getAllLikeMusic];
    }else {
        _queue=[self.tool getFavorListMusic:listName];
    }
//    if (musicModel==nil) {
//        self.currentIndex=index;
//    }else {
//        //遍历歌曲获取下标
//        for (int i=0; i<self.queue.count ; i++) {
//            LSMusicModel *model=self.queue[i];
//            if ([musicModel.name  isEqualToString:model.name]&&[musicModel.singer isEqualToString:model.singer]) {
//                self.currentIndex=i;
//            }
//        }
//    }
    self.currentIndex=index;
    self.listName=listName;
    [self postMusicChangeNotification];
    
}
-(LSMusicModel*)getNextModel
{
    if (self.queue==nil||self.queue.count==0) return nil;
    NSInteger nextIndex;
    switch (self.mode) {
        case LSPlayQueueModeCycle:
            nextIndex=(self.currentIndex+1)%self.queue.count;
            break;
        case LSPlayQueueModeRandom:
            nextIndex=random()%self.queue.count;
            break;
        case LSPlayQueueModeSingleCycle:
            nextIndex=self.currentIndex;
        default:
            break;
    }
    
    self.currentIndex=nextIndex;
    [self postMusicChangeNotification];
    LSMusicModel *model=self.queue[nextIndex];
    return model;
}
-(void)setCurrentIndex:(NSInteger)currentIndex
{
    _currentIndex=currentIndex;
    
    
}
-(void)postMusicChangeNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:LSPlayQueueChangeIndexNotification object:nil userInfo:@{LSPlayQueueChangeIndexNotificationKey:@(self.currentIndex)}];
}
-(void)updatePlayMode
{
    if (self.mode==LSPlayQueueModeCycle) {
        self.mode=LSPlayQueueModeRandom;
    }else if(self.mode==LSPlayQueueModeRandom){
        self.mode=LSPlayQueueModeSingleCycle;
    }else if(self.mode==LSPlayQueueModeSingleCycle){
        self.mode=LSPlayQueueModeCycle;
    }
   
}
-(void)setMode:(LSPlayQueueMode)mode
{

    _mode=mode;
    NSUserDefaults *defaults= [NSUserDefaults standardUserDefaults];
    [defaults  setInteger: self.mode forKey:LSPlayQueueModeKey];
    [defaults synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:LSPlayQueueChangeModeNotification object:nil userInfo:@{LSPlayQueueChangeModeNotificationKey:@(self.mode)}];
}

@end
