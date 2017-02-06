


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
    [LSHttpTool GET:@"http://fm.api.ttpod.com/radiolist?image_type=240_200&app=ttpod&v=v8.0.1.2015091618&uid=&mid=iPhone7%2C1&f=f320&s=s310&imsi=&hid=&splus=9.0&active=1&net=2&openudid=17d5bcecf6ab1038818fefba634092be93a2829c&idfa=A04F9D23-1399-4FBB-93B0-AE747E6715FC&utdid=Vfwq4CLLI7wDAIM4GEJ4Bkg3&alf=201200&bundle_id=com.ttpod.music&latitude=&longtitude=" parameters:nil success:^(id responseObject) {
//        NSLog(@"%@",responseObject);
        
        NSMutableArray *array=[NSMutableArray array];
        NSArray *arr=responseObject[@"data"];
        if (arr.count) {
            for (NSDictionary *dict in arr) {
                NSArray *arr2=dict[@"data"];
                if (arr2.count>0) {
                    for (NSDictionary *dict2 in arr2) {
                        LSChannel *channel=[LSChannel objectWithKeyValues:dict2];
                        [array addObject:channel];
                        
                    }
                }
            }
        }
    

        if (success) {
            success(array);
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
   
    NSString *url=[NSString stringWithFormat:@"http://fm.api.ttpod.com/vipradiosong?num=150&tagid=%@&app=ttpod&v=v8.0.1.2015091618&uid=&mid=iPhone7,1&f=f320&s=s310&imsi=&hid=&splus=9.0&active=1&net=2&openudid=17d5bcecf6ab1038818fefba634092be93a2829c&idfa=A04F9D23-1399-4FBB-93B0-AE747E6715FC&utdid=Vfwq4CLLI7wDAIM4GEJ4Bkg3&alf=201200&bundle_id=com.ttpod.music&latitude=&longtitude=",channelID];
    [LSHttpTool GET:url parameters:nil success:^(id responseObject) {
        NSArray *arr=responseObject[@"data"];
        if (success) {
            
            NSMutableArray *arrM=[NSMutableArray array];
            for (NSDictionary *dict in arr) {
//
                LSMusicModel *model=[[LSMusicModel alloc]init];
                model.name=dict[@"song_name"];
                model.singer=dict[@"singer_name"];
                model.songUrl=[dict[@"url_list"] lastObject][@"url"];
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
