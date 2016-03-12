//
//  LSFirstCell.m
//  perfectMusic
//
//  Created by song on 15/10/13.
//  Copyright © 2015年 song. All rights reserved.
//

#import "LSFirstCell.h"

@interface LSFirstCell ()
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIImageView *myImageView;
@end
@implementation LSFirstCell

+(instancetype)firstCell:(UITableView *)tableView
{
    LSFirstCell *cell=[tableView dequeueReusableCellWithIdentifier:@"firstCell"];
    return cell;
}
+(CGFloat)cellHeight
{
    return 106;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected) {
        self.label.textColor=[UIColor yellowColor];
        self.myImageView.hidden=NO;

    }
    else
    {
        self.label.textColor=[UIColor whiteColor];
        self.myImageView.hidden=YES;
    }
}
-(void)setContentDict:(NSDictionary *)contentDict
{
    _contentDict=contentDict;
    self.label.text=contentDict[@"title"];
}
@end
