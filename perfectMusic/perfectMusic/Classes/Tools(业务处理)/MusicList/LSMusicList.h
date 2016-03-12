//
//  LSMusicList.h
//  perfectMusic
//
//  Created by song on 15/10/19.
//  Copyright © 2015年 song. All rights reserved.
//

#import <Foundation/Foundation.h>
#define LSMusicListPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"music.data"]
#define LSMusicPath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES)firstObject] stringByAppendingPathComponent:@"Music"]
@class LSMusicModel;
@interface LSMusicList : NSObject
+(instancetype)musicList;
//获取URL
+(NSString*)urlWithString:(NSString*)string;

//根据模型获取URL
+(NSURL*)urlWithMusicModel:(LSMusicModel*)model;

#pragma mark - 所有音乐列表操作
//添加音乐
-(void)addMusicWithMusicModel:(LSMusicModel*)model;
//获取所有歌曲
-(NSArray*)getAllMusic;
//更新歌曲信息
-(void)updateMusic:(LSMusicModel*)model;
/**
 *删除本地歌曲
 */
-(BOOL)delLocalMusic:(LSMusicModel*)musicModel;

#pragma mark - 喜欢列表操作
//获取所有喜欢歌曲
-(NSArray*)getAllLikeMusic;

#pragma mark - 收藏列表操作
// 添加收藏列表
-(BOOL)addFavorWithListName:(NSString *)listName;
//删除收藏列表
-(BOOL)delFavorWithListName:(NSString*)listName;
//获取所有收藏列表
-(NSArray*)getAllFavorListName;
/**
 *往指定收藏列表添加歌曲
 */
-(BOOL)addMusic:(LSMusicModel*)musicModel listName:(NSString*)listName;
/**
 *删除指定收藏列表歌曲
 */
-(BOOL)delMusic:(LSMusicModel*)musicModel listName:(NSString*)listName;
/**
 *获取指定收藏列表的歌曲
 */
-(NSArray*)getFavorListMusic:(NSString*)listName;
@end
