//
//  LSQueueView.h
//  perfectMusic
//
//  Created by song on 15/10/26.
//  Copyright © 2015年 song. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LSQueueView;
@protocol LSQueueViewDelegate <NSObject>

-(void)queueViewClick:(LSQueueView*)queueView;
@end
@interface LSQueueView : UIButton
@property (nonatomic, weak) id<LSQueueViewDelegate> delegate;
+(instancetype)queueView;
-(void)reloadTableView;
-(void)dismiss;
@end
