//
//  LSStack.m
//  perfectMusic
//
//  Created by song on 15/11/5.
//  Copyright © 2015年 song. All rights reserved.
//

#import "LSStack.h"

@interface LSStack ()


@property (nonatomic, strong) NSMutableArray *images;
@end
@implementation LSStack

+(instancetype)stack
{
    LSStack *stack=[[LSStack alloc]init];
    return stack;
}
-(NSMutableArray *)images
{
    if (_images==nil) {
        _images=[NSMutableArray array];
    }
    return _images;
}
-(void)pop
{
    if (![self isEmpty]) {
        [self.images removeLastObject];
    }
}
-(void)push:(id)obj
{
    if (obj) {
        [self.images addObject:obj];
    }
}
-(id)getTop
{
    if (![self isEmpty]) {
        return self.images.lastObject;
    }else {
        
        return nil;
    }
    
}
-(BOOL)isEmpty
{
    if (self.images.count) {
        return NO;
    }else{
        return YES;
    }
}
@end
