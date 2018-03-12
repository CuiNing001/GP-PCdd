//
//  GPNoticeViewController.m
//  GPLottery
//
//  Created by cc on 2018/3/11.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPNoticeViewController.h"

@interface GPNoticeViewController ()
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
