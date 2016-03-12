//
//  LSMusicModel.h
//  perfectMusic
//
//  Created by song on 15/10/14.
//  Copyright © 2015年 song. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSMusicModel : NSObject

@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * singer;
@property (nonatomic, copy) NSString * geci;
@property (nonatomic, copy) NSString * time;
@property (nonatomic, copy) NSString * index;
@property (nonatomic, copy) NSString *songUrl;
@property (nonatomic, copy) NSString *albumPic;
@property(nonatomic,assign,getter=isLike) BOOL like;
@end
