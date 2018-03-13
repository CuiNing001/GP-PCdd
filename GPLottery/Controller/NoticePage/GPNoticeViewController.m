//
//  GPNoticeViewController.m
//  GPLottery
//
//  Created by cc on 2018/3/11.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPNoticeViewController.h"
#import <SDCycleScrollView/SDCycleScrollView.h>

@interface GPNoticeViewController ()<SDCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *headerView;     // 轮播图
@property (weak, nonatomic) IBOutlet UIView *noticeBtnView;  // 公告底部view
@property (weak, nonatomic) IBOutlet UIView *msgBtnView;     // 消息底部view
@property (weak, nonatomic) IBOutlet UIButton *noticeBtn;    // 公告按钮
@property (weak, nonatomic) IBOutlet UIButton *msgBtn;       // 消息按钮
@property (weak, nonatomic) IBOutlet UITableView *tableView; // 消息列表


@end

@implementation GPNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadSubView];
    [self loadData];
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
    scrollView.contentMode = UIViewContentModeScaleAspectFit;                            // 设置图片模式
    [self.headerView addSubview:scrollView];
    
}

#pragma mark - 加载数据
- (void)loadData{
    
}



#pragma mark - 通知公告按钮
- (IBAction)noticeButton:(UIButton *)sender {
    
    // 点击按钮切换选中颜色，底部view颜色修改
    self.noticeBtnView.backgroundColor = [UIColor orangeColor];
     [self.noticeBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    
    self.msgBtnView.backgroundColor = [UIColor whiteColor];
    [self.msgBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
}

#pragma mark - 我的消息按钮
- (IBAction)messageButton:(UIButton *)sender {
    
    // 点击按钮切换选中颜色，底部view颜色修改
    self.noticeBtnView.backgroundColor = [UIColor whiteColor];
    [self.noticeBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    self.msgBtnView.backgroundColor = [UIColor orangeColor];
    [self.msgBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    
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
