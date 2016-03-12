
//
//  LSCover.m
//  perfectMusic
//
//  Created by song on 15/10/23.
//  Copyright © 2015年 song. All rights reserved.
//

#import "LSCover.h"
#import "LSMusicList.h"
@interface LSCover ()<UITableViewDataSource,UITableViewDelegate>
- (IBAction)newListClick:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIView *myView;
- (IBAction)cancelClick:(UIButton *)sender;
@property (nonatomic, strong) NSArray *datas;
@end
@implementation LSCover

+(instancetype)show
{
    LSCover *cover=[[[NSBundle mainBundle]loadNibNamed:@"Cover" owner:nil options:nil]lastObject];
    cover.width=LSScreenWidth;
    cover.height=LSScreenHeight;
    cover.backgroundColor=[UIColor colorWithWhite:0.8 alpha:0.2];
    cover.myView.transform=CGAffineTransformMakeTranslation(0, cover.height);
    cover.listView.rowHeight=30;
    cover.listView.delegate=cover;
    cover.listView.dataSource=cover;
    [LSKeyWindow addSubview:cover];
    cover.alpha=0;
    [UIView animateWithDuration:0.3 animations:^{
        cover.myView.transform=CGAffineTransformIdentity;
        cover.alpha=1;
    }];
    
    return cover;
    
}
-(void)awakeFromNib
{
    [self addTarget:self action:@selector(tapClick) forControlEvents:UIControlEventTouchUpInside];
}
-(void)tapClick
{
    [self dismiss];
    
}
-(void)dismiss
{
    [UIView animateWithDuration:0.5 animations:^{
        self.myView.transform=CGAffineTransformMakeTranslation(0, self.height);
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
}
- (IBAction)newListClick:(UIButton *)sender {
    [self dismiss];
    if ([self.delegate respondsToSelector:@selector(coverNewFavorListClick:)]) {
        [self.delegate coverNewFavorListClick:self];
    }
}

- (IBAction)cancelClick:(UIButton *)sender {
    [self dismiss];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.datas=[[LSMusicList musicList] getAllFavorListName];
    return self.datas.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *name=self.datas[indexPath.row];
    UITableViewCell  *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];

    }
    cell.textLabel.text=name;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(coverAddMmusic:listName:)]) {
        [self.delegate  coverAddMmusic:self listName:self.datas[indexPath.row]];
    }
    [self dismiss];
}

@end
