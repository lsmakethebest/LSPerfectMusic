




//
//  LSSecondCell.m
//  perfectMusic
//
//  Created by song on 15/10/13.
//  Copyright © 2015年 song. All rights reserved.
//

#import "LSSecondCell.h"

@implementation LSSecondCell
+(instancetype)secondCellWithTableView:(UITableView *)tableView
{
    LSSecondCell *cell=[tableView dequeueReusableCellWithIdentifier:@"secondCell"];
    if (cell==nil) {
        cell=[[LSSecondCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"secondCell"];
        cell.backgroundColor=[UIColor clearColor];
        cell.textLabel.textColor=[UIColor whiteColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
}
+(CGFloat)cellHeight
{
    return 44;
}
-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (selected) {
        self.textLabel.textColor=[UIColor yellowColor];
        
    }
    else{
        self.textLabel.textColor=[UIColor whiteColor];
        
    }
}
@end
