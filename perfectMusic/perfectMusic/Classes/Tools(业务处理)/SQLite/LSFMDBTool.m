

//
//  LSFMDBTool.m
//  perfectMusic
//
//  Created by song on 15/10/21.
//  Copyright © 2015年 song. All rights reserved.
//

#import "LSFMDBTool.h"
#import "LSMusicModel.h"
#import "FMDB.h"
#define LSAllLocalMusicTableName @"music"
#define LSFavorListTableName @"favorList"
#define LSFavorListMusicTableNamePrex @"favorListMusicName"
#define LSFMDBPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:@"myMusic.sqlite"]

@interface LSFMDBTool ()
@property (nonatomic, strong) FMDatabaseQueue *queue;
@end
@implementation LSFMDBTool

+(instancetype)fmdbTool
{
    return  [[self alloc]init];
}
-(instancetype)init
{
    if (self=[super init]) {
        [self  setupDB];
    }
    return self;
}
//加载数据库
-(void)setupDB
{
    self.queue=[FMDatabaseQueue databaseQueueWithPath:LSFMDBPath];
    if (self.queue==nil) {
        NSLog(@"连接数据库失败");
    }
    //创建所有音乐的表
    [self createAllMusicListTable];
    //    创建收藏列表
    [self createFavorListTable];
    __block    BOOL v=YES;
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString *s=[NSString stringWithFormat:@"select * from %@ where listName='我的歌单'",LSFavorListTableName];
        FMResultSet *rs=[db executeQuery:s];
        while ([rs next]) {
            v=NO;
        }
        
    }];
    if (v) {
        
        [self addFavorWithListName:@"我的歌单"];
    }
}
#pragma mark - 公共方法
//创建所有音乐的表
-(void)createAllMusicListTable
{
    NSString *sqlStr=[NSString stringWithFormat:@"create  table if not exists  %@(name text, singer text, geci text, time text,songUrl text,albumPic text,like integer );",LSAllLocalMusicTableName];
    [self.queue inDatabase:^(FMDatabase *db) {
        if (![db executeUpdate:sqlStr]) {
            NSLog(@"%@ %@",sqlStr, db.lastError);
            return ;
        }
    }];
}
//    创建收藏列表（包含所有收藏列表名）
-(void)createFavorListTable
{
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString *s=[NSString stringWithFormat:@"create table if not exists %@(listName text primary key)",LSFavorListTableName];
        if(![db executeUpdate:s]){
            NSLog(@"%@:%@",s,db.lastErrorMessage);
        }
    }];
}
#pragma mark - 本地音乐操作
//添加一首歌曲
-(void)addLocalMusic:(LSMusicModel *)musicModel
{
    __block BOOL v=YES;
    NSString *s=[NSString stringWithFormat:@"select * from %@ where name='%@' and singer='%@'",LSAllLocalMusicTableName,musicModel.name,musicModel.singer];
    [self.queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs=[db executeQuery:s];
        while ([rs next]) {
            v=NO;
        }
        
    }];
    if (v) {
        NSString *sqlStr=[NSString stringWithFormat:@"insert into %@ values('%@','%@','%@','%@','%@','%@',%d)",LSAllLocalMusicTableName,musicModel.name,musicModel.singer,musicModel.geci,musicModel.time, musicModel.songUrl,musicModel.albumPic,musicModel.isLike];
        [self.queue inDatabase:^(FMDatabase *db) {
            if (![db executeUpdate:sqlStr]) {
                NSLog(@"%@ %@",sqlStr,db.lastError);
            }
            
        }];
    }
}
/**
 *删除一首本地歌曲 需要遍历所有收藏列表，如果有就删除
 */
-(BOOL)delLocalMusic:(LSMusicModel *)musicModel
{
    
    __block BOOL v=YES;
    for (NSString *listName in [self getAllFavorListName]) {
        
        [self delMusic:musicModel listName:listName];
    }
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString *s=[NSString stringWithFormat:@"delete from %@ where name='%@' and singer='%@'",LSAllLocalMusicTableName, musicModel.name,musicModel.singer];
        if(![db executeUpdate:s]){
            NSLog(@"%@:%@",s,db.lastErrorMessage);
            v=NO;
        }
    }];
    
    return YES;
}
//获取所有本地音乐
-(NSArray*)getAllLocalMusics
{
    NSMutableArray *array=[NSMutableArray array];
    NSString *sqlStr=[NSString stringWithFormat:@"select * from %@",LSAllLocalMusicTableName];
    
    [self.queue inDatabase:^(FMDatabase *db) {
        FMResultSet *re =[db executeQuery:sqlStr];
        if (re==nil) {
            NSLog(@"%@%@",sqlStr,db.lastError);
            return ;
        }
        while ([re next]) {
            LSMusicModel *model=[[LSMusicModel alloc]init];
            model.name=[re stringForColumn:@"name"];
            model.singer=[re stringForColumn:@"singer"];
            model.geci=[re stringForColumn:@"geci"];
            model.time=[re stringForColumn:@"time"];
            model.songUrl=[re stringForColumn:@"songUrl"];
            model.albumPic=[re stringForColumn:@"albumPic"];
            model.like=[re intForColumn:@"like"];
            [array addObject:model];
        }
        [re close];
        
    }];
    return array;
}
//更新本地音乐信息
-(void)updateMusic:(LSMusicModel*)model
{
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString *s=[NSString stringWithFormat:@"update %@ set like=%d where name='%@' and singer='%@'",LSAllLocalMusicTableName,model.isLike,model.name,model.singer];
        if (![db executeUpdate:s]) {
            NSLog(@"%@:%@",s,db.lastErrorMessage);
            return ;
        }
    }];
    
}

#pragma mark - 喜欢列表操作
//获取所有喜欢歌曲
-(NSArray *)getAllLikeMusic
{
    NSMutableArray *musics=[NSMutableArray array];
    [self.queue inDatabase:^(FMDatabase *db) {
        
        NSString *s=[NSString stringWithFormat:@"select * from %@ where like=1",LSAllLocalMusicTableName];
        FMResultSet *re=  [db executeQuery:s];
        if (re==nil) {
            NSLog(@"%@:%@",s,db.lastErrorMessage);
        }
        while ([re next]) {
            LSMusicModel *model=[[LSMusicModel alloc]init];
            model.name=[re stringForColumn:@"name"];
            model.singer=[re stringForColumn:@"singer"];
            model.geci=[re stringForColumn:@"geci"];
            model.time=[re stringForColumn:@"time"];
            model.songUrl=[re stringForColumn:@"songUrl"];
            model.albumPic=[re stringForColumn:@"albumPic"];
            model.like=[re intForColumn:@"like"];
            [musics addObject:model];
        }
    }];
    return musics;
    
}

#pragma mark - 收藏列表操作
// 添加收藏列表
-(BOOL)addFavorWithListName:(NSString *)listName
{
    __block BOOL v=YES;
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *s=[NSString stringWithFormat:@"insert into %@ values('%@')",LSFavorListTableName, listName];
        if(![db executeUpdate:s]){
            NSLog(@"%@:%@",s,db.lastErrorMessage);
            v=NO;
        }
        if (v) {
            NSString *s2=[NSString stringWithFormat:@"create table if not exists %@_%@(name text,singer text)",LSFavorListMusicTableNamePrex,listName];
            if (![db executeUpdate:s2 ]) {
                v=NO;
                *rollback=YES;
                NSLog(@"%@:%@",s,db.lastErrorMessage);
            }
        }
    }];
    return v;
    
}
/**
 *添加指定歌曲到收藏列表
 */
-(BOOL)addMusic:(LSMusicModel *)musicModel listName:(NSString *)listName
{
    __block BOOL v=YES;
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *s=[NSString stringWithFormat:@"select * from %@_%@ where name='%@' and singer='%@'",LSFavorListMusicTableNamePrex,listName,musicModel.name,musicModel.singer];
        FMResultSet *rs=[db executeQuery:s];
        if(rs==nil){
            NSLog(@"%@:%@",s,db.lastErrorMessage);
            v=NO;
        }
        while ([rs next]) {
            v=NO;
        }
        if (v) {
            NSString *s2=[NSString stringWithFormat:@"insert into %@_%@ values('%@','%@')",LSFavorListMusicTableNamePrex,listName,musicModel.name,musicModel.singer];
            if (![db executeUpdate:s2 ]) {
                v=NO;
                *rollback=YES;
                NSLog(@"%@:%@",s,db.lastErrorMessage);
            }
        }
    }];
    return v;
}
/**
 *获取指定收藏列表歌曲
 */
-(NSArray *)getFavorListMusic:(NSString *)listName
{
    
    NSMutableArray *dicts=[NSMutableArray array];
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString *s=[NSString stringWithFormat:@"select * from %@_%@",LSFavorListMusicTableNamePrex,listName];
        FMResultSet *rs=[db executeQuery:s];
        if (rs==nil) {
            NSLog(@"%@:%@",s,db.lastErrorMessage);
        }
        while ([rs next]) {
            NSMutableDictionary *dict=[NSMutableDictionary dictionary];
            dict[@"name"]=[rs stringForColumn:@"name"];
            dict[@"singer"]=[rs stringForColumn:@"singer"];
            [dicts addObject:dict];
        }
    }];
    NSMutableArray *musics=[NSMutableArray array];
    for (NSDictionary * dict in dicts) {
        NSString *s=[NSString stringWithFormat:@"select * from %@ where  name='%@' and singer='%@'",LSAllLocalMusicTableName, dict[@"name"],dict[@"singer"]];
        [self.queue inDatabase:^(FMDatabase *db) {
            FMResultSet *rs=[db executeQuery:s];
            if (rs==nil) {
                NSLog(@"%@:%@",s,db.lastErrorMessage);
            }
            while ([rs next]) {
                LSMusicModel *model=[[LSMusicModel alloc]init];
                model.name=[rs stringForColumn:@"name"];
                model.singer=[rs stringForColumn:@"singer"];
                model.geci=[rs stringForColumn:@"geci"];
                model.time=[rs stringForColumn:@"time"];
                model.songUrl=[rs stringForColumn:@"songUrl"];
                model.albumPic=[rs stringForColumn:@"albumPic"];
                model.like=[rs intForColumn:@"like"];
                [musics addObject:model];
            }
            
        }];
    }
    
    
    return musics;
    
}
//删除收藏列表
-(BOOL)delFavorWithListName:(NSString*)listName
{
    __block BOOL v=YES;
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString *s=[NSString stringWithFormat:@"delete from %@ where listName='%@'",LSFavorListTableName, listName];
        if(![db executeUpdate:s]){
            NSLog(@"%@:%@",s,db.lastErrorMessage);
            v=NO;
        }
    }];
    if (v) {
        [self.queue inDatabase:^(FMDatabase *db) {
            NSString *s=[NSString stringWithFormat:@"drop table %@_%@",LSFavorListMusicTableNamePrex,listName];
            if(![db executeUpdate:s]){
                NSLog(@"%@:%@",s,db.lastErrorMessage);
                v=NO;
            }
        }];
    }
    return v;
}
/**
 *删除指定收藏列表歌曲
 */
-(BOOL)delMusic:(LSMusicModel *)musicModel listName:(NSString *)listName
{
    __block BOOL v=YES;
    NSString *s=[NSString stringWithFormat:@"delete from %@_%@ where name='%@' and singer='%@'",LSFavorListMusicTableNamePrex,listName,musicModel.name,musicModel.singer];
    [self.queue inDatabase:^(FMDatabase *db) {
        if (![db executeUpdate:s]) {
            v=NO;
            NSLog(@"%@:%@",s,db.lastErrorMessage);
        }
    }];
    return v;
}

//获取所有收藏列表
-(NSArray*)getAllFavorListName
{
    NSMutableArray *names=[NSMutableArray array];
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString *s=[NSString stringWithFormat:@"select * from %@ ",LSFavorListTableName];
        FMResultSet *re=[db executeQuery:s];
        if(re==nil){
            NSLog(@"%@:%@",s,db.lastErrorMessage);
        }
        while ([re next]) {
            NSString * str=[re stringForColumn:@"listName"];
            [names addObject:str];
        }
    }];
    return names;
    
}

@end
