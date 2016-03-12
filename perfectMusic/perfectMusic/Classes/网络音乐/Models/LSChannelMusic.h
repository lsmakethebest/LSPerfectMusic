//
//  LSChannelMusivc.h
//  perfectMusic
//
//  Created by song on 15/10/17.
//  Copyright © 2015年 song. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 aid = 2989780;
 album = "/subject/2989780/";
 albumtitle = "Tribal Gathering";
 "alert_msg" = "";
 artist = Kraftwerk;
 "file_ext" = mp3;
 kbps = 128;
 length = 351;
 like = 0;
 picture = "http://img3.douban.com/lpic/s2929582.jpg";
 sha256 = bdd7fd2abcbc76d63e657f6633ceb87b3214d04386dd966e5067ca9d849ff3dd;
 sid = 606995;
 singers =             (
 {
 id = 560;
 "is_site_artist" = 0;
 name = Kraftwerk;
 "related_site_id" = 0;
 }
 );
 ssid = 31e7;
 status = 0;
 subtype = "";
 title = Numbers;
 url = "http://mr7.doubanio.com/e85a4f75ec3b01dc0c7ffd3684fb46ef/0/fm/song/p606995_128k.mp3";
 ver = 0;

 */
@interface LSChannelMusic : NSObject

@property (nonatomic, copy) NSString *artist;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *url;

@end
