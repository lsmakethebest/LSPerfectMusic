//
//  LSChannelTool.h
//  perfectMusic
//
//  Created by song on 15/10/17.
//  Copyright © 2015年 song. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSChannelTool : NSObject
+(void)getChannelInfoSuccess:(void(^)(NSArray*array))success failure:(void(^)(NSError*error))failure;
+(void)getCHannelMusicWithChannelID:(NSString*)channelID Success:(void(^)(NSArray*array))success failure:(void(^)(NSError*error))failure;
@end
