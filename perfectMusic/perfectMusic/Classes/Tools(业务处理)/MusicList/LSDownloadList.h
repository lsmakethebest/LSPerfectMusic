//
//  LSDownloadList.h
//  perfectMusic
//
//  Created by song on 15/10/20.
//  Copyright © 2015年 song. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
@class LSDownloadMusic;
@interface LSDownloadList : NSObject
singalton_h(DownloadList);
-(void)addDownloader:(LSDownloadMusic*)downloader;
-(NSArray*)getDownloadList;
@end
