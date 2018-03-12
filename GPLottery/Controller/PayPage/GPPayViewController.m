//
//  GPPayViewController.m
//  GPLottery
//
//  Created by cc on 2018/3/11.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPPayViewController.h"

@interface GPPayViewController ()

@property (strong, nonatomic) UIView *coverView;  // 遮罩view

@end

@implementation GPPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadData];
    [self loadSubView];
}

- (void)viewWillAppear:(BOOL)animated{
    
    // 进入页面添加遮罩view
    [self initCoverView];
}

#pragma mark - 加载子控件
- (void)loadSubView{
    
    
    
}

#pragma mark - 加载数据
- (void)loadData{
    
}

#pragma mark - 遮罩层view
- (void)initCoverView{
    
    // 添加提醒遮罩
    self.coverView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.coverView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3];
    [[UIApplication sharedApplication].keyWindow addSubview:self.coverView];  // 把遮罩层添加到keyWindow上
    
    // 添加点击事件
    UITapGestureRecognizer *hiddenTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenCover)];
    [self.coverView addGestureRecognizer:hiddenTap];
    
    // 遮罩上添加图片
    UIImageView *tipImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 200,200 , 200)];
    tipImage.image = [UIImage imageNamed:@""];
    [self.coverView addSubview:tipImage];
}

#pragma mark - 点击屏幕隐藏遮罩
- (void)hiddenCover{
    self.coverView.hidden = YES;
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
