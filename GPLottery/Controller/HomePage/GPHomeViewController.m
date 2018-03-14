//
//  GPHomeViewController.m
//  GPLottery
//
//  Created by cc on 2018/3/11.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPHomeViewController.h"
#import <SDCycleScrollView/SDCycleScrollView.h>
#import "GPLoginViewController.h"

@interface GPHomeViewController ()<SDCycleScrollViewDelegate,UITabBarControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *bgView;                    // 背景view
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewHeight;  // 背景view的高度
@property (weak, nonatomic) IBOutlet UIView *headerView;                // 轮播图
@property (weak, nonatomic) IBOutlet UIButton *leftButton;              // 左房间按钮
@property (weak, nonatomic) IBOutlet UIButton *rightButton;             // 右房间按钮
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;                 // 已赚元宝
@property (weak, nonatomic) IBOutlet UILabel *personLab;                // 已注册人数
@property (weak, nonatomic) IBOutlet UILabel *ratioLab;                 // 赚钱率
@property (assign, nonatomic) NSString *isLogin;                        // 登陆状态
@property (strong, nonatomic) GPLoginViewController *loginVC;
@property (strong, nonatomic) GPInfoModel        *infoModel;       // 本地数据

@end

@implementation GPHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self loadData];
    [self loadSubView];
}

-(void)viewWillAppear:(BOOL)animated{
    
    // 加载本地数据
    [self loadUserDefaultsData];
}

#pragma mark - 加载子控件
- (void)loadSubView{
    
    // 添加tabbar代理
    self.tabBarController.delegate = self;
    
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
    
    // 设置登陆状态
    self.isLogin = self.infoModel.islogin;
}

#pragma mark - 加载本地数据
- (void)loadUserDefaultsData{
    
    NSMutableDictionary *infoDic = [UserDefaults searchData];
    
    self.infoModel               = [[GPInfoModel alloc]init];
    
    [self.infoModel setValuesForKeysWithDictionary:infoDic];
    
    // 设置登陆状态
    self.isLogin = self.infoModel.islogin;
    
    NSLog(@"|HOME-VC|-[登陆状态]:%@-[token]:%@",self.isLogin,self.infoModel.token);

}

#pragma mark - tab bar controller代理方法
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{

    // 未登陆状态点击其他页面跳转到登陆页面
    if (![self.isLogin isEqualToString:@"1"]) {
        
        if (![viewController.tabBarItem.title isEqualToString:@"首页"]) {
            
            [self getControllerFromStoryboardWithIdentifier:@"loginVC" myVC:self.loginVC];
            
            return NO;
        }else{
            
            return YES;
        }
        
    }else{
        
       return YES;
    }
}



#pragma mark - 轮播图点击事件
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
}

#pragma mark - storyboard controller
- (void)getControllerFromStoryboardWithIdentifier:(NSString *)identifier myVC:(UIViewController *)myVC{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    myVC = [storyboard instantiateViewControllerWithIdentifier:identifier];
    
    [self presentViewController:myVC animated:YES completion:nil];
    
}

#pragma mark - 提醒框
- (void)alertViewWithTitle:(NSString *)title message:(NSString *)message{
    
    UIAlertController *alert  = [UIAlertController alertControllerWithTitle:title
                                                                    message:message
                                                             preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction     *action = [UIAlertAction actionWithTitle:@"确定"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           
                                                           [self dismissViewControllerAnimated:YES
                                                                                    completion:nil];
                                                       }];
    
    [alert addAction:action];
    
    [self presentViewController:alert
                       animated:YES
                     completion:nil];
    
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
