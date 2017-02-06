//
//  LSChannel.h
//  perfectMusic
//
//  Created by song on 15/10/17.
//  Copyright © 2015年 song. All rights reserved.
//

#import <Foundation/Foundation.h>


/*
 "abbr_en" = My;
 "channel_id" = 0;
 name = "\U79c1\U4eba\U5146\U8d6b";
 "name_en" = "Personal Radio";
 "seq_id" = 0;
 
 */
@interface LSChannel : NSObject
@property (nonatomic, copy) NSString *tag_id;
@property (nonatomic, copy) NSString *tag_name;
@end
