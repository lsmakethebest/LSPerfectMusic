






//
//  LSMusicList.m
//  perfectMusic
//
//  Created by song on 15/10/19.
//  Copyright © 2015年 song. All rights reserved.
//


#import "LSMusicModel.h"
#import "LSMusicList.h"
#import "LSFMDBTool.h"

@interface LSMusicList ()
@property (nonatomic, strong) LSFMDBTool *tool;
@end

@implementation LSMusicList

-(LSFMDBTool *)tool
{
    if (_tool==nil) {
        _tool=[LSFMDBTool fmdbTool];
    }
    return _tool;
}
+(instancetype)musicList
{
    return [[self alloc]init];
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        if (![[NSFileManager defaultManager] fileExistsAtPath:LSMusicPath isDirectory:NULL]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:LSMusicPath withIntermediateDirectories:YES attributes:nil error:NULL];
        }
    }
    return self;
}
-(void)addMusicWithMusicModel:(LSMusicModel*)model
{
    [self.tool addLocalMusic:model];
}
-(NSArray*)getAllMusic
{

    NSArray *musics=[self.tool  getAllLocalMusics];
    return musics;
    
}
+(NSString*)urlWithString:(NSString*)string
{
    
    NSString *url=[NSString stringWithFormat:@"file://%@/%@.mp3",LSMusicPath,[string stringByReplacingOccurrencesOfString:@"/" withString:@""]];
    NSString *str =[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",url);
    return str;
}
-(void)updateMusic:(LSMusicModel*)model
{
    [self.tool updateMusic:model];
}
//获取所有喜欢歌曲
-(NSArray *)getAllLikeMusic
{
    return [self.tool getAllLikeMusic];
    
}
#pragma mark - 收藏列表操作
// 添加收藏列表
-(BOOL)addFavorWithListName:(NSString *)listName
{
   return  [self.tool addFavorWithListName:listName];
}
//删除收藏列表
-(BOOL)delFavorWithListName:(NSString*)listName
{
    return [self.tool delFavorWithListName:listName];
}
//获取所有收藏列表
-(NSArray*)getAllFavorListName
{
    return [self.tool getAllFavorListName];
}
/**
 *往指定收藏列表添加歌曲
 */
-(BOOL)addMusic:(LSMusicModel*)musicModel listName:(NSString*)listName
{
    return [self.tool addMusic:musicModel listName:listName];
}
/**
 *删除指定收藏列表歌曲
 */
-(BOOL)delMusic:(LSMusicModel*)musicModel listName:(NSString*)listName
{
    return [self.tool delMusic:musicModel listName:listName];
}
/**
 *获取指定收藏列表的歌曲
 */
-(NSArray*)getFavorListMusic:(NSString*)listName
{
    return [self.tool getFavorListMusic:listName];
}
-(BOOL)delLocalMusic:(LSMusicModel *)musicModel
{
    return [self.tool delLocalMusic:musicModel];
}
+(NSURL *)urlWithMusicModel:(LSMusicModel *)model
{
    NSString *urlstring=[self urlWithString:model.name];
    NSURL *url=[NSURL URLWithString:urlstring];
    return url;
}
@end
