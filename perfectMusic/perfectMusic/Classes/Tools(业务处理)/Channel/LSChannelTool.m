


//
//  LSChannelTool.m
//  perfectMusic
//
//  Created by song on 15/10/17.
//  Copyright © 2015年 song. All rights reserved.
//

#import "LSChannelTool.h"
#import "LSHttpTool.h"
#import "MJExtension.h"
#import "LSChannel.h"
#import "LSChannelMusic.h"
#import "LSMusicModel.h"
static int i=0;
@implementation LSChannelTool
+(void)getChannelInfoSuccess:(void(^)(NSArray*array))success failure:(void(^)(NSError*error))failure
{
    [LSHttpTool GET:@"http://www.douban.com/j/app/radio/channels" parameters:nil success:^(id responseObject) {
//        NSLog(@"%@",responseObject);
        
        NSArray *arr=responseObject[@"channels"];
        NSArray *channels=[LSChannel objectArrayWithKeyValuesArray:arr];
        if (success) {
            success(channels);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error );
        }
    }];
    
    
}
/*
 
 app_name	必选	string	radio_desktop_win	固定
 version	必选	int	100	固定
 user_id	非必选	string	user_id	若已登录，则填入
 expire	非必选	int	expire	若已登录，则填入
 token	非必选	string	token	若已登录，则填入
 sid	非必选	int	song id	在需要针对单曲操作时需要
 h	非必选	string	最近播放列表	单次报告曲目播放状态，其格式是 |sid:报告类型|sid:报告类型
 channel	非必选	int	频道id	获取频道时取得的channel_id
 type	必选	string	报告类型	需要调用的接口类型，也是使用下表的报告类型
 */
+(void)getCHannelMusicWithChannelID:(NSString*)channelID Success:(void(^)(NSArray*array))success failure:(void(^)(NSError*error))failure
{
    NSMutableDictionary *param=[NSMutableDictionary dictionary];
    param[@"app_name"]=@"radio_desktop_win";
    param[@"version"]=@100;
    param[@"channel"]=@"196";
    param[@"type"]=@"n";
    [LSHttpTool GET:@"http://www.douban.com/j/app/radio/people" parameters:param success:^(id responseObject) {
//        NSLog(@"responseObject=%@",responseObject);
        if (success) {
            
            NSArray *arr=responseObject[@"song"];
            NSMutableArray *arrM=[NSMutableArray array];
            for (NSDictionary *dict in arr) {

                LSMusicModel *model=[[LSMusicModel alloc]init];
                model.name=dict[@"title"];
                model.name=[NSString stringWithFormat:@"%d",random()%10];
                model.singer=dict[@"artist"];
                model.songUrl=dict[@"url"];
                model.albumPic=dict[@"picture"];
                [arrM addObject:model];
            }
            success(arrM);
           
        }
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
@end
