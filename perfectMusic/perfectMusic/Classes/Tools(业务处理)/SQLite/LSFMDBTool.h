//
//  LSFMDBTool.h
//  perfectMusic
//
//  Created by song on 15/10/21.
//  Copyright © 2015年 song. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LSMusicModel;
@interface LSFMDBTool : NSObject
//类方法创建
+(instancetype)fmdbTool;
#pragma mark - 所有音乐的操作
//添加一首歌曲
-(void)addLocalMusic:(LSMusicModel*)musicModel;
//获取所有本地歌曲
-(NSArray*)getAllLocalMusics;
-(void)updateMusic:(LSMusicModel*)model;
/**
 *删除本地歌曲
 */
-(BOOL)delLocalMusic:(LSMusicModel*)musicModel;

#pragma mark - 喜欢列表操作
//获取所有喜欢歌曲
-(NSArray *)getAllLikeMusic;

#pragma mark - 收藏列表操作
// 添加收藏列表
-(BOOL)addFavorWithListName:(NSString *)listName;
//删除收藏列表
-(BOOL)delFavorWithListName:(NSString*)listName;
//获取所有收藏列表名称
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
