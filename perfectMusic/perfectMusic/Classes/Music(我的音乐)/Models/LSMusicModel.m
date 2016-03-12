



//
//  LSMusicModel.m
//  perfectMusic
//
//  Created by song on 15/10/14.
//  Copyright © 2015年 song. All rights reserved.
//

#import "LSMusicModel.h"
#define LSName @"name"
#define LSSinger @"singer"
#define LSGeci @"geci"
#define LSTime @"time"
#define LSIndex @"index"
#define LSUrl @"url"
#define LSLike @"like"
@interface LSMusicModel ()<NSCoding>

@end
@implementation LSMusicModel

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super init]) {
        
        _name=[aDecoder decodeObjectForKey:LSName];
          _singer=[aDecoder decodeObjectForKey:LSSinger];
          _geci=[aDecoder decodeObjectForKey:LSGeci];
          _time=[aDecoder decodeObjectForKey:LSTime];
          _index=[aDecoder decodeObjectForKey:LSIndex];
        _songUrl=[aDecoder decodeObjectForKey:LSUrl];
        _like=[aDecoder decodeBoolForKey:LSLike];
        
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_name forKey:LSName];
     [aCoder encodeObject:_singer forKey:LSSinger];
     [aCoder encodeObject:_geci forKey:LSGeci];
     [aCoder encodeObject:_time forKey:LSTime];
     [aCoder encodeObject:_index forKey:LSIndex];
    [aCoder encodeObject:_songUrl forKey:LSUrl];
    [aCoder encodeBool:_like forKey:LSLike];
}
@end
