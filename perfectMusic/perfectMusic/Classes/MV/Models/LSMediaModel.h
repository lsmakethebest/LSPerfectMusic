//
//  LSMediaModel.h
//  LSPlayer
//
//  Created by ls on 16/3/8.
//  Copyright © 2016年 song. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSMediaModel : NSObject

/// 回帖数
@property (nonatomic, assign) int replyCount;

///// 图片
@property (nonatomic, copy) NSString *cover;
// 播放次数
@property (nonatomic, assign) int playCount;

// 题目
@property (nonatomic, copy) NSString * title;

// 来源
@property (nonatomic, copy) NSString *source;

//暂时不知道干啥
@property (nonatomic, copy) NSString *replyBoard;

// 简单描述信息
@property (nonatomic, copy) NSString *myDescription;

@property (nonatomic, copy) NSString *replyid;

// 播放地址
@property (nonatomic, copy) NSString *mp4_url;

// 发布时间
@property (nonatomic, copy) NSString *ptime;

//  视频时长(秒)
@property (nonatomic, assign) int length;
-(instancetype)initWithDictionary:(NSDictionary*)dict;
@end

