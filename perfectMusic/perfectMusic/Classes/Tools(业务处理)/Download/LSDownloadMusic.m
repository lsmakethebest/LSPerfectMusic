





//
//  LSDownloadMusic.m
//  perfectMusic
//
//  Created by song on 15/10/19.
//  Copyright © 2015年 song. All rights reserved.
//

#import "LSDownloadMusic.h"
#import "AFNetworking.h"
#import "LSMusicModel.h"
#import "LSMusicList.h"
#import "KVNProgress.h"
#import "LSDownloadList.h"
@interface LSDownloadMusic ()

@property (nonatomic, strong) NSURLSessionDownloadTask *task;
@property (nonatomic, strong) NSData *data;
@property(nonatomic,assign) BOOL first;
@end
@implementation LSDownloadMusic


+(instancetype)downloadWithMusicModel:(LSMusicModel*)model
{
    return  [[self alloc]initWithMusicModel:model];
    
}
-(instancetype)initWithMusicModel:(LSMusicModel*)model
{
    
    if (self=[super init]) {
        self.first=YES;
        [KVNProgress showSuccessWithStatus:[NSString stringWithFormat:@"%@ 添加到下载队列",model.name]];
        self.musicModel=model;
        
        NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:model.songUrl]];
        NSProgress *progress;
        self.task=   [[AFHTTPSessionManager manager]  downloadTaskWithRequest:request progress:&progress destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
            NSURL *url=[NSURL URLWithString:[LSMusicList urlWithString:model.name]];
            
            return url;
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error){
            
            if (error) {
                [KVNProgress showErrorWithStatus:error.localizedDescription];
            }else{
                [KVNProgress showSuccessWithStatus:@"下载完成"];
                [[LSMusicList  musicList]addMusicWithMusicModel:model];
                
                
            }
        }];
        self.progress=progress;
        [progress addObserver:self forKeyPath:@"fractionCompleted" options:NSKeyValueObservingOptionNew context:nil];
        
        
    }
    return self;
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (object==self.progress) {
        NSLog(@"progress==%lf",self.progress.fractionCompleted);
        if ( self.progress.fractionCompleted>0.999999&& self.progress.fractionCompleted<1.00001) {
            self.state=LSDownloadMusicStateCompleted;
            self.data=nil;
            self.first=NO;
            self.progress=nil;
        }else {
            if ([self.delegate respondsToSelector:@selector(downloadMusic:)]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.delegate downloadMusic:self];
                });
                
            }
        }
    }
}
-(void)setState:(LSDownloadMusicState)state
{
    _state=state;
//    [[LSMusicList  musicList]addMusicWithMusicModel:self.musicModel];
    if (state==LSDownloadMusicStateDownload) {
        
        if (!self.data) {
            if (self.first) {
                [self.task resume];
                [[LSDownloadList  sharedDownloadList] addDownloader:self];
            }
            else {
                NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:self.musicModel.songUrl]];
                //                 NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://127.0.0.1/123.dmg"]];
                NSProgress *progress;
                self.task=   [[AFHTTPSessionManager manager]  downloadTaskWithRequest:request progress:&progress destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                    NSURL *url=[NSURL URLWithString:[LSMusicList urlWithString:self.musicModel.name]];
                    
                    return url;
                } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error){
                    
                    if (error) {
                        [KVNProgress showErrorWithStatus:error.localizedDescription];
                    }else{
                        [KVNProgress showSuccessWithStatus:@"下载完成"];
                        [[LSMusicList  musicList]addMusicWithMusicModel:self.musicModel];
                        
                        
                    }
                }];
                self.progress=progress;
                [progress addObserver:self forKeyPath:@"fractionCompleted" options:NSKeyValueObservingOptionNew context:nil];
                
                
                
            }
        }
        else {
            NSProgress *progress;
            self.task =[[AFHTTPSessionManager manager] downloadTaskWithResumeData:self.data progress:&progress destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                NSURL *url=[NSURL URLWithString:[LSMusicList urlWithString:self.musicModel.name]];
                return url;
            } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                
                if (error) {
                    [KVNProgress showErrorWithStatus:error.localizedDescription];
                }else{
                    [KVNProgress showSuccessWithStatus:@"下载完成"];
                    [[LSMusicList  musicList]addMusicWithMusicModel:self.musicModel];
                }
                
            }];
            [self.task resume];
            self.progress=progress;
            [self.progress addObserver:self forKeyPath:@"fractionCompleted" options:NSKeyValueObservingOptionNew context:nil];
            
        }
        
        
    }else if (state==LSDownloadMusicStatePause){
        [self.task cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
            self.data=resumeData;
        }];
        
        
    }else if (state==LSDownloadMusicStateCompleted)
    {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.delegate downloadMusic:self];
        });
    }
    
}

-(void)setDelegate:(id<LSDownloadMusicDelegate>)delegate
{
    _delegate=delegate;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.delegate downloadMusic:self];
    });
}
@end
