//
//  LSCover.h
//  perfectMusic
//
//  Created by song on 15/10/23.
//  Copyright © 2015年 song. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LSCover;

@protocol LSCoverDelegate <NSObject>

-(void)coverNewFavorListClick:(LSCover*)cover;
-(void)coverAddMmusic:(LSCover*)cover listName:(NSString*)listName;

@end

@interface LSCover : UIButton

@property (weak, nonatomic) IBOutlet UITableView *listView;
@property (nonatomic, weak) id<LSCoverDelegate> delegate;

+(instancetype)show;
-(void)dismiss;

@end
