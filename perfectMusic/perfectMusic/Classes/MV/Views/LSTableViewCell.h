//
//  LSTableViewCell.h
//  LSPlayer
//
//  Created by ls on 16/3/8.
//  Copyright © 2016年 song. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSMediaModel.h"

@interface LSTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *picView;

@property (nonatomic, strong) LSMediaModel *model;

@property (nonatomic, assign) NSInteger index;//方便在滚动时取出对应cell的frame

+(instancetype)cellWithTabelView:(UITableView*)tableview;
- (IBAction)playClick:(id)sender;
@end
