//
//  GPHomeViewController.m
//  GPLottery
//
//  Created by cc on 2018/3/11.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPHomeViewController.h"
#import <SDCycleScrollView/SDCycleScrollView.h>


@interface GPHomeViewController ()<SDCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *bgView;                    // 背景view
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewHeight;  // 背景view的高度
@property (weak, nonatomic) IBOutlet UIView *headerView;                // 轮播图
@property (weak, nonatomic) IBOutlet UIButton *leftButton;              // 左房间按钮
@property (weak, nonatomic) IBOutlet UIButton *rightButton;             // 右房间按钮
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;                 // 已赚元宝
@property (weak, nonatomic) IBOutlet UILabel *personLab;                // 已注册人数
@property (weak, nonatomic) IBOutlet UILabel *ratioLab;                 // 赚钱率


@end

@implementation GPHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self loadData];
    [self loadSubView];
}

#pragma mark - 加载子控件
- (void)loadSubView{
    
    // 轮播图view添加边框
    self.headerView.layer.borderColor = [UIColor orangeColor].CGColor;
    self.headerView.layer.borderWidth = 1;
    
    // 设置轮播图
    CGRect rect = CGRectMake(self.headerView.bounds.origin.x, self.headerView.bounds.origin.y, self.headerView.bounds.size.width, self.headerView.bounds.size.height);
    SDCycleScrollView *scrollView = [SDCycleScrollView cycleScrollViewWithFrame:rect
                                                                       delegate:self
                                                               placeholderImage:[UIImage imageNamed:@"1.jpg"]];
//    scrollView.imageURLStringsGroup = self.bannerListArrya;                            // 轮播图网络图片
    scrollView.localizationImageNamesGroup = @[@"1.jpg",@"2.jpg"];                       // 轮播图本地图片
    scrollView.scrollDirection             = UICollectionViewScrollDirectionHorizontal;; // 轮播图滚动方向（左右滚动）
    scrollView.autoScrollTimeInterval      = 3.0;                                        // 轮播图滚动时间间隔
    scrollView.contentMode = UIViewContentModeScaleAspectFit;
    [self.headerView addSubview:scrollView];
    
}

#pragma mark - 加载数据
- (void)loadData{
    
    
    
}

#pragma mark - 轮播图点击事件
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
