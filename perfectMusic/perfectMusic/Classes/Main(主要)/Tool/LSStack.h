//
//  LSStack.h
//  perfectMusic
//
//  Created by song on 15/11/5.
//  Copyright © 2015年 song. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSStack : NSObject
+(instancetype)stack;
-(id)getTop;
-(void)push:(id)obj;
-(void)pop;
@end
