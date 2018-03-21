//
//  GPGameViewController.m
//  GPLottery
//
//  Created by cc on 2018/3/14.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPGameViewController.h"
#import "GPLuckyListViewController.h"

@interface GPGameViewController ()<CAAnimationDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *gameBgImge; // 抽奖背景图
@property (weak, nonatomic) IBOutlet UIButton *gameBtn;       // 抽奖按钮
@property (strong, nonatomic) NSArray *dataArray;
@property (assign, nonatomic) NSInteger randomNum;

@end

@implementation GPGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"幸运抽奖";
    
    [self customNavigationBarItem];
}

#pragma mark - 自定义bar item
- (void)customNavigationBarItem{
    
    UIView *barView             = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 30)];
    barView.backgroundColor     = [UIColor blackColor];
    barView.layer.masksToBounds = YES;
    barView.layer.cornerRadius  = 5;
    barView.layer.borderWidth   = 1;
    barView.layer.borderColor   = [UIColor whiteColor].CGColor;
    UIButton *barButton = [UIButton buttonWithType:UIButtonTypeCustom];
    barButton.frame     = CGRectMake(0, 0, 80, 30);
    [barButton setTitle:@"抽奖记录" forState:UIControlStateNormal];
    [barButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    barButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [barButton addTarget:self action:@selector(turunToGameList:) forControlEvents:UIControlEventTouchUpInside];
    [barView addSubview:barButton];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:barView];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}

#pragma mark - 点击抽奖
- (IBAction)gameButton:(UIButton *)sender {
    
    // 转盘动画
    [self startAnimaition];
}

#pragma mark - 动画
- (void)startAnimaition{
    
    // 设置数据源
    self.dataArray  = @[@"1星红包",@"2星红包",@"1星红包",@"3星红包",@"1星红包",@"5星红包",@"2星红包",@"1星红包",@"4星红包",@"1星红包",@"2星红包",@"3星红包"];
    self.randomNum  = arc4random()%12; // 获取0~11的随机数
    NSInteger angle = self.randomNum; // 偏移量（M_PI/6:180°等分6份，）(M_PI/6*angle)
    NSLog(@"randomNum:%ld===angle:%ld===text:%@",self.randomNum,angle,self.dataArray[self.randomNum]);

    // 设置动画
    CABasicAnimation *baseAnimation   = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];// 创建动画
    baseAnimation.toValue             = [NSNumber numberWithFloat:M_PI*4+M_PI/6*angle]; // keyPath对应的结束值'M_PI/4=45°;M_PI*4=720°'
    baseAnimation.timingFunction      = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]; // 先慢后快再慢
    baseAnimation.duration            = 3.0f; // 动画时长
    baseAnimation.cumulative          = YES;
    baseAnimation.removedOnCompletion = NO; // 结束后不删除动画
    baseAnimation.fillMode            = kCAFillModeForwards; // 保存动画最新状态
    baseAnimation.delegate            = self;
    [self.gameBgImge.layer addAnimation:baseAnimation forKey:@"rotationAnimation"]; // 添加到背景层  ‘rotationAnimation：旋转动画’
    
}

#pragma mark 动画结束
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    // 动画结束后弹窗
    [ToastView toastViewWithMessage:self.dataArray[self.randomNum] timer:2];
}

#pragma mark - 跳转抽奖记录
- (void)turunToGameList:(UIButton *)sender{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    GPLuckyListViewController *luckyVC = [storyboard instantiateViewControllerWithIdentifier:@"luckyVC"];
    [self.navigationController pushViewController:luckyVC animated:YES];
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
