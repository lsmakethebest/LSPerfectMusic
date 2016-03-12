//
//  LSDownloadMusic.h
//  perfectMusic
//
//  Created by song on 15/10/19.
//  Copyright © 2015年 song. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LSMusicModel,LSDownloadMusic;
typedef enum
{
LSDownloadMusicStateDownload,
    LSDownloadMusicStatePause,
    LSDownloadMusicStateCompleted,
    LSDownloadMusicStateFaild
}LSDownloadMusicState;

@protocol LSDownloadMusicDelegate <NSObject>

-(void)downloadMusic:(LSDownloadMusic*)downloadMusic;

@end

@interface LSDownloadMusic : NSObject
@property(nonatomic,assign) LSDownloadMusicState state;
@property (nonatomic, strong) NSProgress *progress;
@property (nonatomic, weak) id<LSDownloadMusicDelegate> delegate;
@property (nonatomic, strong) LSMusicModel *musicModel;
+(instancetype)downloadWithMusicModel:(LSMusicModel*)model;
@end
