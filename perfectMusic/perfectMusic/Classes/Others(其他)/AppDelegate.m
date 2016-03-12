//
//  AppDelegate.m
//  perfectMusic
//
//  Created by song on 15/10/13.
//  Copyright © 2015年 song. All rights reserved.
//

#import "AppDelegate.h"
#import "LSChooseRootController.h"
#import "LSMusicPlayerTool.h"
#import "LSPlayQueue.h"
#import "LSPlayQueue.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
    AVAudioSession* session = [[AVAudioSession alloc] init];
    [session setActive:YES error:NULL];
    [session setCategory:AVAudioSessionCategoryPlayback error:NULL];
    
    [self becomeFirstResponder];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [LSChooseRootController chooseRootController:self.window];
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication*)application
{
    AVAudioSession* session = [[AVAudioSession alloc] init];
    [session setActive:YES error:NULL];
    [session setCategory:AVAudioSessionCategoryPlayback error:NULL];
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

#pragma mark - 接收方法的设置
- (void)remoteControlReceivedWithEvent:(UIEvent*)event
{
    if (event.type == UIEventTypeRemoteControl) { //判断是否为远程控制
        switch (event.subtype) {
        case UIEventSubtypeRemoteControlPlay:
            [[LSMusicPlayerTool sharedMusicPlayerTool] resume];
            break;
        case UIEventSubtypeRemoteControlPause:
            [[LSMusicPlayerTool sharedMusicPlayerTool] pause];
            break;
        case UIEventSubtypeRemoteControlNextTrack:
            NSLog(@"下一首");
            break;
        case UIEventSubtypeRemoteControlPreviousTrack:
            NSLog(@"上一首 ");
            break;
        default:
            break;
        }
    }
}
- (void)applicationDidEnterBackground:(UIApplication*)application
{
}

- (void)applicationWillEnterForeground:(UIApplication*)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication*)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication*)application
{

    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[LSPlayQueue sharedPlayQueue].listName forKey:LSSaveListNameKey];
    [defaults setInteger:[LSPlayQueue sharedPlayQueue].currentIndex forKey:LSSavePlayIndexKey];
    [defaults synchronize];
}

@end
