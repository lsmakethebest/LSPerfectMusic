


//
//  LSDownloadMangerCell.m
//  perfectMusic
//
//  Created by song on 15/10/20.
//  Copyright © 2015年 song. All rights reserved.
//

#import "LSDownloadMangerCell.h"
#import "ACPDownloadView.h"
#import "LSDownloadMusic.h"
#import "LSMusicModel.h"
#import "ACPStaticImagesAlternative.h"

@interface LSDownloadMangerCell ()<LSDownloadMusicDelegate>
@property (weak, nonatomic) IBOutlet UILabel *name;
@property(nonatomic,assign) CGFloat lastProgress;
@property (weak, nonatomic) IBOutlet UILabel *singer;
@property (weak, nonatomic) IBOutlet ACPDownloadView *downloadView;


@end
@implementation LSDownloadMangerCell
+(instancetype)downloadMangerCell:(UITableView *)tableView
{
    LSDownloadMangerCell *cell=[tableView dequeueReusableCellWithIdentifier:@"download"];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    ACPStaticImagesAlternative * myOwnImages = [ACPStaticImagesAlternative new];
    [myOwnImages updateColor:cell.downloadView.tintColor];
    [cell.downloadView setImages:myOwnImages];

    [cell.downloadView setActionForTap:^(ACPDownloadView *downloadView, ACPDownloadStatus status) {
        switch (status) {
            case ACPDownloadStatusNone:
            
                NSLog(@"ACPDownloadStatusNone");
                [downloadView  setIndicatorStatus:ACPDownloadStatusRunning];
                cell.downloader.state=LSDownloadMusicStateDownload;
                break;
                case ACPDownloadStatusRunning:
                NSLog(@"ACPDownloadStatusRunning");
                [downloadView  setIndicatorStatus:ACPDownloadStatusCompleted];
                cell.downloader.state=LSDownloadMusicStatePause;
                break;
            case ACPDownloadStatusCompleted:
                NSLog(@"ACPDownloadStatusCompleted");
                [downloadView setIndicatorStatus:ACPDownloadStatusRunning];

                cell.downloader.state = LSDownloadMusicStateDownload;
                break;
            case ACPDownloadStatusIndeterminate:
                NSLog(@"ACPDownloadStatusIndeterminate");
                break;

            default:
                break;
        }
    }];
    return cell;
}
-(void)setDownloader:(LSDownloadMusic *)downloader
{
    _downloader=downloader;
    downloader.delegate=self;
    self.name.text=downloader.musicModel.name;
    self.singer.text=downloader.musicModel.singer;
//    self..
}
+(CGFloat)cellHeight
{

    return 60.f;
}
-(void)downloadMusic:(LSDownloadMusic *)downloadMusic
{
    if (downloadMusic.state==LSDownloadMusicStateDownload) {
        [self.downloadView setIndicatorStatus:ACPDownloadStatusRunning];
        [self.downloadView setProgress:downloadMusic.progress.fractionCompleted animated:YES];
        self.lastProgress=downloadMusic.progress.fractionCompleted;
    }else if(downloadMusic.state==LSDownloadMusicStatePause){
        [self.downloadView setIndicatorStatus:ACPDownloadStatusCompleted];
    
    }else if (downloadMusic.state==LSDownloadMusicStateCompleted)
    {
        [self.downloadView setIndicatorStatus:ACPDownloadStatusNone];
        
    }
}
@end
