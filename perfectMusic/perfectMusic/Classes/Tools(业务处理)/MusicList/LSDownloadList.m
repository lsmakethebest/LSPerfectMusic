//
//  LSDownloadList.m
//  perfectMusic
//
//  Created by song on 15/10/20.
//  Copyright © 2015年 song. All rights reserved.
//

#import "LSDownloadList.h"
#import "LSDownloadMusic.h"
@interface LSDownloadList ()
@property (nonatomic, strong) NSMutableArray *downloadList;

@end
@implementation LSDownloadList
-(NSMutableArray *)downloadList
{
    if (_downloadList==nil) {
        _downloadList=[NSMutableArray array];
    }
    return _downloadList;
}
singalton_m(DownloadList);

-(void)addDownloader:(LSDownloadMusic*)downloader
{
    [self.downloadList addObject:downloader];
}
-(NSArray*)getDownloadList
{
    return self.downloadList;
}
@end
