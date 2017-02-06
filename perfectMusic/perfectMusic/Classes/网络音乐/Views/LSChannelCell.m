



//
//  LSChannelCell.m
//  perfectMusic
//
//  Created by song on 15/10/17.
//  Copyright © 2015年 song. All rights reserved.
//

#import "LSChannelCell.h"
#import "LSChannel.h"
@implementation LSChannelCell

+(instancetype)channelCellWithTableView:(UITableView *)tableView
{
    LSChannelCell *cell=[tableView dequeueReusableCellWithIdentifier:@"channel"];
    if (cell==nil) {
        cell=[[ self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"channel"];
        cell.backgroundColor=[UIColor clearColor];
    }
    return cell;
}
+(CGFloat)cellHeight
{
    return 60;
}
-(void)setChannel:(LSChannel *)channel
{
    _channel=channel;
    self.textLabel.text=channel.tag_name;
}

@end
