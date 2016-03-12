

//
//  LSNewFeatureController.m
//  至美微博
//
//  Created by ls on 15/10/4.
//  Copyright © 2015年 ls. All rights reserved.
//

#import "LSNewFeatureController.h"
#import "LSNewFeatureCell.h"
@interface LSNewFeatureController ()<UIScrollViewDelegate>
@property (nonatomic, weak) UIPageControl *pageControl;
@end

@implementation LSNewFeatureController

static NSString * const reuseIdentifier = @"newFeature";
-(instancetype)init
{UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    layout.itemSize=[UIScreen mainScreen].bounds.size;
    layout.scrollDirection=UICollectionViewScrollDirectionHorizontal;
    
    layout.minimumLineSpacing=0;
    return [super initWithCollectionViewLayout:layout];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //添加pageControl
    CGFloat h=[UIScreen mainScreen].bounds.size.height;
    CGFloat w=100;
    UIPageControl *pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake((LSScreenWidth-w)/2, h-30, 100, 20)];

    pageControl.currentPageIndicatorTintColor=[UIColor orangeColor];
    pageControl.pageIndicatorTintColor=[UIColor blueColor];
    [self.view addSubview:pageControl];
    self.pageControl=pageControl;
    pageControl.numberOfPages=5;
    
    //设置collectionView
    self.collectionView.backgroundColor=[UIColor whiteColor];
    [self.collectionView registerClass:[LSNewFeatureCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.bounces=YES;
    self.collectionView.pagingEnabled=YES;
    self.collectionView.showsHorizontalScrollIndicator=NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


#pragma mark <UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    LSNewFeatureCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    // 拼接图片名称
    NSString *imageName = [NSString stringWithFormat:@"introduction_%d-568",(long)indexPath.row + 1];
    cell.image = [UIImage imageNamed:imageName];
    [cell setIndexPath:indexPath count:5];
    
    
    return cell;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    
    CGFloat x=  self.collectionView.contentOffset.x;
    self.pageControl.currentPage=(x+LSScreenWidth/2)/LSScreenWidth;
}
-(BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
