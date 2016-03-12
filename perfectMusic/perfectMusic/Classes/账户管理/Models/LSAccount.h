//
//  LSAccountModel.h
//  perfectMusic
//
//  Created by song on 15/10/15.
//  Copyright © 2015年 song. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSAccount : NSObject
@property (nonatomic, copy) NSString * loginName;
@property (nonatomic, copy) NSString * nickName;
@property (nonatomic, copy) NSString * iconURL;
@property (nonatomic, copy) NSString *doubanID;
@end
