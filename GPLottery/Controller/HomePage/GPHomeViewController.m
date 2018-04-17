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
#import "GPIndexModel.h"
#import "GPBannerListModel.h"
#import "GPProductListModel.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "GPGameInstroctionViewController.h"
#import "GPPlayListViewController.h"
#import "GPRoomBetView.h"
#import "GPServiceViewController.h"
#import "GPBannerTypeTwoViewController.h"
#import "GPBannerTypeThreeViewController.h"
#import "GPHomeMoreView.h"
#import "GPPayViewController.h"
#import "GPWithdrawViewController.h"
#import "GPUserStatusModel.h"
#import "GPHomeLeftItemView.h"
#import "GPWalletViewController.h"
#import "GPMyMessageViewController.h"
#import "GPCoverView.h"
#import "GPWalletModel.h"
#import "GPAlertNoticeView.h"
#import "GPNoticeModel.h"
#import "UITabBar+RedCircle.h"

static int errorState = 1;  // 数据连接状态
static int touch = 0;   // 右侧更多按钮点击次数
static int leftViewTouch = 0;  // 左侧更多按钮点击次数
@interface GPHomeViewController ()<SDCycleScrollViewDelegate,UITabBarControllerDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *bgScrollView;

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
@property (strong, nonatomic) GPInfoModel        *infoModel;            // 本地数据
@property (strong, nonatomic) MBProgressHUD  *progressHUD;
@property (strong, nonatomic) NSString *token;
@property (strong, nonatomic) SDCycleScrollView *scrollView;            // 轮播图
@property (strong, nonatomic) NSMutableArray *bannerListArray;          // 轮播图地址
@property (strong, nonatomic) NSMutableArray *productArray;             // 产品
@property (strong, nonatomic) GPProductListModel *leftProductModel;     // 左侧按钮model
@property (strong, nonatomic) GPProductListModel *rightProductModel;    // 右侧按钮model
@property (strong, nonatomic) NSString *userType;  // 用户类型：resulet:1 普通用户  ; 4 代理用户

@property (strong, nonatomic) UIView *itemView;   // bar item
@property (strong, nonatomic) UIButton *itemBtn;  // bar item button
@property (strong, nonatomic) GPHomeMoreView *moreView; // 顶部item more按钮
@property (strong, nonatomic) GPUserStatusModel  *userStatusModel;   // 用户公共信息
@property (strong, nonatomic) GPHomeLeftItemView *indexLeftMoreView; // 左侧更多页面
@property (strong, nonatomic) GPCoverView *coverView;  // 导航遮罩层
@property (strong, nonatomic) NSString *indexCoverCount; // 首页lunch次数

@property (strong, nonatomic) GPAlertNoticeView *alertNoticeView;  // 公告弹窗
@property (strong, nonatomic) NSString *noticeAlertCount;  // 公告弹窗点击次数
@property (strong, nonatomic) GPNoticeModel *noticeModel;  // 公告列表
@property (strong, nonatomic) NSString *noticeDetailStr;   // 公告详情地址
@property (strong, nonatomic) NSMutableArray *bannerLocArray; // 轮播图地址

@property (strong, nonatomic) NSMutableArray *noticeDataArr;   // 公告数据

@end

@implementation GPHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self loadData];
    [self loadSubView];
    
//    [UserDefaults deleateNoticeStauts];
}


#pragma mark - 自定义navigation bar item
- (void)customNavigationBarItem{
    
    // 导航栏右侧按钮
    self.itemView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 50)];
    
    self.itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _itemBtn.frame = CGRectMake(0, 10, 40, 30);
    
    [_itemBtn setImage:[UIImage imageNamed:@"service_item"] forState:UIControlStateNormal];
    
    [_itemBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    
    [_itemBtn addTarget:self action:@selector(turnToService:) forControlEvents:UIControlEventTouchUpInside];
    
    [_itemView addSubview:_itemBtn];
    
    UIButton *webBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    webBtn.frame = CGRectMake(40, 10, 40, 30);
    
    [webBtn setImage:[UIImage imageNamed:@"more_item"] forState:UIControlStateNormal];
    
    [webBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    
    [webBtn addTarget:self action:@selector(turnToChooseView:) forControlEvents:UIControlEventTouchUpInside];
    
    [_itemView addSubview:webBtn];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:_itemView];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
}

#pragma mark - 跳转客服
- (void)turnToService:(UIBarButtonItem *)sender{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    GPServiceViewController *serviceVC = [storyboard instantiateViewControllerWithIdentifier:@"serviceVC"];
    
    serviceVC.hidesBottomBarWhenPushed = YES;
    
    [self presentViewController:serviceVC animated:YES completion:nil];
}

#pragma mark - 顶部提现充值
- (void)turnToChooseView:(UIBarButtonItem *)sender{
    
    touch++;
    
    if (touch%2==0) {

        self.moreView.hidden = YES;
        
    }else{
        
        self.moreView.hidden = NO;
    }
    
}

#pragma mark - 顶部左侧item
- (IBAction)leftMoreItem:(UIBarButtonItem *)sender {
    
    if (![self.isLogin isEqualToString:@"1"]) {
        
        [ToastView toastViewWithMessage:@"请先登陆" timer:3.0];
    }else{
    
    leftViewTouch++;
        CATransition *transition = [CATransition animation];
        transition.duration = 0.3;
        transition.type     = kCATransitionMoveIn;
        transition.subtype  = kCATransitionFromBottom;
        self.indexLeftMoreView.hidden = NO;
        [self.indexLeftMoreView.layer addAnimation:transition forKey:@"animation"];
        // 刷新用户数据
        self.indexLeftMoreView.nickNameLab.text = self.infoModel.nickname;
        [self loadUserMoney];
        
    }
}

#pragma mark - 加载公告数据
- (void)loadNetDataWithPage:(NSString *)page rows:(NSString *)rows{
    
    [self.noticeDataArr removeAllObjects];
    
    [self.progressHUD showAnimated:YES];
    
    [self loadUserDefaultsData];
    
    NSString *noticeLoc = [NSString stringWithFormat:@"%@notice/1/allNotice",kBaseLocation];
    
//    NSDictionary *paramDic = @{@"page":page,@"rows":rows};
    
    // 请求登陆接口
    __weak typeof(self)weakSelf = self;
    [AFNetManager requestPOSTWithURLStr:noticeLoc paramDic:nil token:self.token finish:^(id responserObject) {
        
        NSLog(@"|NOTICE-VC|success:%@",responserObject);
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        NSString *code = [NSString stringWithFormat:@"%@",[responserObject objectForKey:@"code"]];
        NSString *msg = [responserObject objectForKey:@"msg"];
        
        if (code.integerValue == 9200) {
            
            NSMutableArray *dataArr = [responserObject objectForKey:@"data"];
            
            for (NSDictionary *dataDic in dataArr) {
                
                GPNoticeModel *noticeModel = [GPNoticeModel new];
                
                [noticeModel setValuesForKeysWithDictionary:dataDic];
                
                [weakSelf.noticeDataArr addObject:noticeModel];
            }
            
            // 已读消息数量和所有公告消息数量相等时关闭小红点
            NSArray *locaArr = [UserDefaults searchNoticeStauts];
            NSLog(@"==========%lu=======%lu",(unsigned long)locaArr.count,(unsigned long)self.noticeDataArr.count);
            if (locaArr.count != self.noticeDataArr.count) {
                
                // 显示小红点
                [self.tabBarController.tabBar showBadgeOnItemIndex:2];
            }
            
        }else{
            
            [ToastView toastViewWithMessage:msg timer:3.0];
        }
        
    } enError:^(NSError *error) {
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        [ToastView toastViewWithMessage:@"数据连接出错，请稍后再试" timer:3.0];
        
    }];

}

#pragma mark - 页面即将出现
-(void)viewWillAppear:(BOOL)animated{
    
    // 加载本地数据
    [self loadUserDefaultsData];
    
    // 已登录状态加载公告数据判断是否添加提示小红点
    if (self.token.length>0) {
        
        [self loadNetDataWithPage:@"1" rows:@"10"];
    }

    
    
    // 验证token
//    [self checkToken];
}

#pragma mark - 验证token
- (void)checkToken{
    
    NSString *checkLoc = [NSString stringWithFormat:@"%@checkToken",kBaseLocation];
    
    if (self.token.length>0) {
        
       NSDictionary *paramDic = @{@"token":self.token};
        
        // 请求登陆接口
        __weak typeof(self)weakSelf = self;
        [AFNetManager requestPOSTWithURLStr:checkLoc paramDic:paramDic token:nil finish:^(id responserObject) {
            
            NSLog(@"|HOME-VC-CHECK-TOKEN|success:%@",responserObject);
            
            [weakSelf.progressHUD hideAnimated:YES];
            
            GPRespondModel *respondModel = [GPRespondModel new];
            
            [respondModel setValuesForKeysWithDictionary:responserObject];
            
            if (respondModel.code.integerValue == 9201) {
                
                [JMSGUser logout:nil];
                // 删除本地数据
                [UserDefaults deleateData];
                
            }else{
                
                [ToastView toastViewWithMessage:respondModel.msg timer:2.5];
            }
            
        } enError:^(NSError *error) {
            
            [weakSelf.progressHUD hideAnimated:YES];
            
            [ToastView toastViewWithMessage:@"数据连接出错，请稍后再试" timer:3.0];
            
        }];
    } 
}

#pragma mark - 动态计算scrollview高度
- (void)viewWillLayoutSubviews{
    
    [self.bgView layoutIfNeeded];
    
//    self.bgViewHeight.constant = kSize_height;
}

#pragma mark - 加载子控件
- (void)loadSubView{
    [self loadUserDefaultsData];
    __weak typeof(self)weakSelf = self;
    
    // ^^^^^^^遮罩层^^^^^^^^^
    self.coverView = [[GPCoverView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [[UIApplication sharedApplication].keyWindow addSubview:self.coverView];
    self.coverView.coverImageView.image = [UIImage imageNamed:@"home_lunch"];
    if (self.indexCoverCount.integerValue == 1) {
        
        // 第一次登陆显示遮罩
        self.coverView.hidden = NO;
    }else{
        //
        self.coverView.hidden = YES;
    }
    
    self.coverView.dissMissBlock = ^{
      
        weakSelf.coverView.hidden = YES;
        // 修改登陆次数
        [UserDefaults upDataWithIndexLunchCount:@"2"];
    };
    
    // ^^^^^^^^^公告弹窗^^^^^^^^^^^^
    self.alertNoticeView = [[GPAlertNoticeView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:self.alertNoticeView];
    if (self.noticeAlertCount.integerValue == 1) {
        
        // 公告赋值
        [self loadNoticeDetailData];
        
        self.alertNoticeView.hidden = NO;
    }else{
        self.alertNoticeView.hidden = YES;
    }
    
    self.alertNoticeView.dissMissBlock = ^{
      
        weakSelf.alertNoticeView.hidden = YES;
        // 修改是否弹窗状态
        [UserDefaults changeLunchCountWithCount:@"2"];
    };
    
    // 自定义右侧导航按钮
    [self customNavigationBarItem];
    
    self.automaticallyAdjustsScrollViewInsets = false;
    
//    GPRoomBetView *betView = [[GPRoomBetView alloc]initWithFrame:self.view.frame];
//    [self.view addSubview:betView];
    
    // 添加tabbar代理
    self.tabBarController.delegate = self;
    
    // 轮播图view添加边框
//    self.headerView.layer.borderColor = [UIColor orangeColor].CGColor;
//    self.headerView.layer.borderWidth = 1;
    
    // 设置轮播图
    CGRect rect = CGRectMake(self.headerView.bounds.origin.x, self.headerView.bounds.origin.y, self.headerView.bounds.size.width+38, self.headerView.bounds.size.height);
    self.scrollView = [SDCycleScrollView cycleScrollViewWithFrame:rect
                                                                       delegate:self
                                                               placeholderImage:[UIImage imageNamed:@"notice_scroll_img_one.jpg"]];
    //    scrollView.imageURLStringsGroup = self.bannerListArrya;                            // 轮播图网络图片
//    self.scrollView.localizationImageNamesGroup = @[@"1.jpg",@"2.jpg"];                       // 轮播图本地图片
    self.scrollView.scrollDirection             = UICollectionViewScrollDirectionHorizontal;; // 轮播图滚动方向（左右滚动）
    self.scrollView.autoScrollTimeInterval      = 3.0;                                        // 轮播图滚动时间间隔
    self.scrollView.contentMode = UIViewContentModeScaleAspectFit;
    [self.headerView addSubview:self.scrollView];
    
    // 初始化加载框
    self.progressHUD = [[MBProgressHUD alloc]initWithFrame:CGRectMake(0, 0, kSize_width, kSize_height)];
    [self.view addSubview:_progressHUD];
    
    // ^^^^^^^^^^^^^^^^^^^^^^^^顶部右侧more按钮^^^^^^^^^^^^^^^^^^^^^^^^^^
    self.moreView = [[GPHomeMoreView alloc]initWithFrame:CGRectMake(kSize_width-120, 84, 100, 80)];
    [self.view addSubview:self.moreView];
    self.moreView.hidden = YES;
    
    // 顶部右侧more按钮-充值
    self.moreView.rechargeBlock = ^{
      
        [weakSelf turnToPayVC];
    };
    
    // 顶部右侧more按钮-提现
    self.moreView.withdrawBlock = ^{
        
        [weakSelf turnToWithdrawVC];
    };
    
    // ^^^^^^^^^^^^^^^^^^^^^^^^顶部左侧more按钮^^^^^^^^^^^^^^^^^^^^^^^^^^
    self.indexLeftMoreView = [[GPHomeLeftItemView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [[UIApplication sharedApplication].keyWindow addSubview:self.indexLeftMoreView];
    
    self.indexLeftMoreView.hidden = YES;
    
    // 顶部左侧more按钮 - 返回
    self.indexLeftMoreView.dissmissBlock = ^{
      
        leftViewTouch++;

        CATransition *transition = [CATransition animation];
        transition.duration = 0.5;
        transition.type     = kCATransitionMoveIn;
        transition.subtype  = kCATransitionFromBottom;
        [weakSelf.indexLeftMoreView.layer addAnimation:transition forKey:@"animation"];
        weakSelf.indexLeftMoreView.hidden = YES;
        
    };
    // 顶部左侧more按钮 - 充值
    self.indexLeftMoreView.topUpBlock = ^{
        
        // 未登陆状态提醒
        if (![weakSelf.isLogin isEqualToString:@"1"]) {
            
            [ToastView toastViewWithMessage:@"请先登陆" timer:3.0];
        }else{
            
            leftViewTouch++;
            weakSelf.indexLeftMoreView.hidden = YES;
            
            UIStoryboard *storyboard       = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            GPPayViewController *payVC     = [storyboard instantiateViewControllerWithIdentifier:@"payVC"];
            payVC.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:payVC animated:YES];
        }
    };
    // 顶部左侧more按钮 - 提现
    self.indexLeftMoreView.withdrawalBlock = ^{
        
        // 未登陆状态提醒
        if (![weakSelf.isLogin isEqualToString:@"1"]) {
            
            [ToastView toastViewWithMessage:@"请先登陆" timer:3.0];
        }else{
            
            // 未绑定银行卡提醒先绑定银行卡
            if (weakSelf.userStatusModel.bankStatus.integerValue == 0) {
                
                [ToastView toastViewWithMessage:@"请先绑定银行卡" timer:3.0];
                
            }else{
                
                leftViewTouch++;
                weakSelf.indexLeftMoreView.hidden = YES;
                
                // 已绑定跳转到提现页面
                UIStoryboard *storyboard             = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                GPWithdrawViewController *withdrawVC = [storyboard instantiateViewControllerWithIdentifier:@"withdrawVC"];
                withdrawVC.hidesBottomBarWhenPushed  = YES;
                [weakSelf.navigationController pushViewController:withdrawVC animated:YES];
            }
        }
    };
    // 顶部左侧more按钮 - 我的钱包
    self.indexLeftMoreView.myWalletBlock = ^{
        
        // 未登陆状态提醒
        if (![weakSelf.isLogin isEqualToString:@"1"]) {
            
            [ToastView toastViewWithMessage:@"请先登陆" timer:3.0];
        }else{
            
            leftViewTouch++;
            weakSelf.indexLeftMoreView.hidden = YES;
            
            UIStoryboard *storyboard              = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            GPWalletViewController *walletVC      = [storyboard instantiateViewControllerWithIdentifier:@"walletVC"];
            walletVC.hidesBottomBarWhenPushed     = YES;
            [weakSelf.navigationController pushViewController:walletVC animated:YES];
        }

    };
    // 顶部左侧more按钮 - 我的消息
    self.indexLeftMoreView.myMessageBlock = ^{
        
        // 未登陆状态提醒
        if (![weakSelf.isLogin isEqualToString:@"1"]) {
            
            [ToastView toastViewWithMessage:@"请先登陆" timer:3.0];
        }else{
            
            leftViewTouch++;
            weakSelf.indexLeftMoreView.hidden = YES;
            
            UIStoryboard *storyboard              = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            GPMyMessageViewController *myMessageVC= [storyboard instantiateViewControllerWithIdentifier:@"myMessageVC"];
            myMessageVC.hidesBottomBarWhenPushed     = YES;
            [weakSelf.navigationController pushViewController:myMessageVC animated:YES];
        }
    };
}

#pragma mark - 加载数据
- (void)loadData{
    
    // 设置登陆状态
    self.isLogin = self.infoModel.islogin;
    
    [self loadNetData];
    
    // 获取用户信息
    [self loadUserStatus];
}

#pragma mark - 充值
- (void)turnToPayVC{
    
    touch++;
    
    self.moreView.hidden = YES;
    
    // 未登陆状态提醒
    if (![self.isLogin isEqualToString:@"1"]) {
        
        [ToastView toastViewWithMessage:@"请先登陆" timer:3.0];
    }else{
        
        UIStoryboard *storyboard       = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        GPPayViewController *payVC     = [storyboard instantiateViewControllerWithIdentifier:@"payVC"];
        payVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:payVC animated:YES];
    }
}

#pragma mark - 提现
- (void)turnToWithdrawVC{
    
    touch++;
    self.moreView.hidden = YES;
    
    // 未登陆状态提醒
    if (![self.isLogin isEqualToString:@"1"]) {
        
        [ToastView toastViewWithMessage:@"请先登陆" timer:3.0];
    }else{
        
        // 未绑定银行卡提醒先绑定银行卡
        if (self.userStatusModel.bankStatus.integerValue == 0) {
            
            [ToastView toastViewWithMessage:@"请先绑定银行卡" timer:3.0];
            
        }else{
            
            // 已绑定跳转到提现页面
            UIStoryboard *storyboard             = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            GPWithdrawViewController *withdrawVC = [storyboard instantiateViewControllerWithIdentifier:@"withdrawVC"];
            withdrawVC.hidesBottomBarWhenPushed  = YES;
            [self.navigationController pushViewController:withdrawVC animated:YES];
        }
    }
    
}

#pragma mark - 获取用户公共信息
/*
 * @param phoneStatus:手机绑定状态  // 0:未绑定，1:已绑定
 * @param luckTurntableStatus:转盘抽奖次数
 * @param userExchange:提现密码绑定状态
 * @param bankStatus:银行卡绑定状态
 */
- (void)loadUserStatus{
    
    [self.progressHUD showAnimated:YES];
    
    [self loadUserDefaultsData];
    
    NSString *userStatusLoc = [NSString stringWithFormat:@"%@user/1/userCommon",kBaseLocation];
    
    // 请求登陆接口
    __weak typeof(self)weakSelf = self;
    [AFNetManager requestPOSTWithURLStr:userStatusLoc paramDic:nil token:self.token finish:^(id responserObject) {
        
        NSLog(@"|HOME-VC-WIDTHRAW|success:%@",responserObject);
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        GPRespondModel *respondModel = [GPRespondModel new];
        
        [respondModel setValuesForKeysWithDictionary:responserObject];
        
        if (respondModel.code.integerValue == 9200) {
            
            // [ToastView toastViewWithMessage:respondModel.msg timer:1.5];
            
            self.userStatusModel = [GPUserStatusModel new];
            
            [self.userStatusModel setValuesForKeysWithDictionary:respondModel.data];
            
        }else{
            
            [ToastView toastViewWithMessage:respondModel.msg timer:2.5];
        }
        
    } enError:^(NSError *error) {
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        [ToastView toastViewWithMessage:@"数据连接超时，请稍后再试" timer:3.0];
        
    }];
}

#pragma mark - 加载网络数据
- (void)loadNetData{
    
    [self.progressHUD showAnimated:YES];
    
    [self loadUserDefaultsData];
    
    NSString *indexLoc = [NSString stringWithFormat:@"%@1/index",kBaseLocation];
    
    NSDictionary *paramDic = [NSDictionary dictionary];
    
    if (self.infoModel.userID.length>0) {
        
        paramDic = @{@"userId":self.infoModel.userID};
    }else{
        
        paramDic = @{@"userId":@""};
    }

    
    // 请求登陆接口
    __weak typeof(self)weakSelf = self;
    [AFNetManager requestPOSTWithURLStr:indexLoc paramDic:paramDic token:self.infoModel.token finish:^(id responserObject) {
        
        // 设置数据连接状态
        errorState = 0;
        
        NSLog(@"|INDEX-VC|success:%@",responserObject);
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        NSString *code = [NSString stringWithFormat:@"%@",[responserObject objectForKey:@"code"]];
        NSString *msg = [responserObject objectForKey:@"msg"];
        
        if (code.integerValue == 9200) {
            
//            [ToastView toastViewWithMessage:msg timer:1.5];
            
            NSDictionary *dataDic = [responserObject objectForKey:@"data"];
            
            GPIndexModel *indexModel = [GPIndexModel new];
                
            [indexModel setValuesForKeysWithDictionary:dataDic];
            
            // 设置首页基本数据
            [weakSelf setIndexDataWithModel:indexModel];
            
            // 轮播图排序
//            NSSortDescriptor *bannerSD = [NSSortDescriptor sortDescriptorWithKey:@"type" ascending:YES];
//            weakSelf.bannerListArray = [[indexModel.bannerList sortedArrayUsingDescriptors:@[bannerSD]]mutableCopy];
            
//            NSMutableArray *bannerLocArray = [NSMutableArray array];
            // 获取轮播图数据
            for (NSDictionary *bannerDic in indexModel.bannerList) {
                
//                NSString *bannerLoc = [NSString stringWithFormat:@"%@%@",kImageLoction,[bannerDic objectForKey:@"imagePath"]];
                
                GPBannerListModel *bannerModel = [GPBannerListModel new];

                [bannerModel setValuesForKeysWithDictionary:bannerDic];
                
                NSString *bannerLoc = [NSString stringWithFormat:@"%@%@",kImageLoction,bannerModel.imagePath];
                
                [self.bannerLocArray addObject:bannerLoc];
                
                [weakSelf.bannerListArray addObject:bannerModel];

                NSLog(@"|bannerLoc|%@%@",kImageLoction,bannerModel.imagePath);
                
                NSLog(@"|HOME-BANNER-TYPE|type:%@--%@%@",bannerModel.type,kImageLoction,bannerModel.imagePath);
                
            }
            
            
            // 设置轮播图地址
            self.scrollView.imageURLStringsGroup = self.bannerLocArray;
            
            // 获取产品数据
            for (NSDictionary *productDic in indexModel.productList) {
                
                GPProductListModel *productModel = [GPProductListModel new];
                
                [productModel setValuesForKeysWithDictionary:productDic];
                
                [weakSelf.productArray addObject:productModel];
            }
            // 设置产品数据
            weakSelf.leftProductModel = weakSelf.productArray[0];
//            [weakSelf setProductListWithModel:weakSelf.leftProductModel sender:weakSelf.leftButton];
            weakSelf.rightProductModel = weakSelf.productArray[1];
//            [weakSelf setProductListWithModel:weakSelf.rightProductModel sender:weakSelf.rightButton];
            
            // 修改用户类型
            weakSelf.userType = indexModel.userType;
            [UserDefaults upDataWithUserType:weakSelf.userType];
            NSLog(@"|INDEX-VC-USER-TYPE|%@",weakSelf.userType);
            
            // 修改个人中心关于页面地址
            [UserDefaults upDataWithAboutUrl:indexModel.aboutUrl];
        }else{
            
            [ToastView toastViewWithMessage:msg timer:2.5];
        }
        
    } enError:^(NSError *error) {
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        // 设置数据连接状态
        errorState = 1;
        
        [ToastView toastViewWithMessage:@"数据连接超时，请稍后再试" timer:3.0];
        
        NSLog(@"|HOME-VC|-|home-error|%@",error);
        
    }];
    
}

#pragma mark - 设置首页基本数据
- (void)setIndexDataWithModel:(GPIndexModel *)indexModel{
    
    self.personLab.text = [NSString stringWithFormat:@"%@",indexModel.registerNum];
//    self.ratioLab.text = [NSString stringWithFormat:@"%@",indexModel.winRate];
    self.ratioLab.text = [NSString stringWithFormat:@"98"];
    self.moneyLab.text = [NSString stringWithFormat:@"%@",indexModel.earnedIncome];
    
}

#pragma mark - 设置轮播图数据
- (void)setBannerImageWithModel:(GPBannerListModel *)bannerModel{
    

}

#pragma mark - 设置产品列表数据
- (void)setProductListWithModel:(GPProductListModel *)productModel sender:(UIButton *)sender{
    
    NSString *imageLoc = [NSString stringWithFormat:@"%@%@",kImageLoction,productModel.productUrl];
    
    // 设置button背景图
    [sender sd_setBackgroundImageWithURL:[NSURL URLWithString:imageLoc] forState:UIControlStateNormal];
    
    
}

#pragma mark - 加载本地数据
- (void)loadUserDefaultsData{
    
    NSMutableDictionary *infoDic = [UserDefaults searchData];
    
    self.infoModel               = [[GPInfoModel alloc]init];
    
    [self.infoModel setValuesForKeysWithDictionary:infoDic];
    
    // 设置登陆状态
    self.isLogin = self.infoModel.islogin;
    self.token   = self.infoModel.token;
    self.indexCoverCount = self.infoModel.indexLunchCount;
    self.noticeAlertCount = self.infoModel.noticeAlertCount;
    
    NSLog(@"|HOME-VC|-[登陆状态]:%@-[token]:%@-[userID]:%@",self.isLogin,self.infoModel.token,self.infoModel.userID);

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
    
    
    if (![self.isLogin isEqualToString:@"1"]) {
        
        [ToastView toastViewWithMessage:@"请先登陆" timer:3.0];
    }else{
        
        GPBannerListModel *bannerModel = [GPBannerListModel new];
        
        bannerModel = self.bannerListArray[index];
        
        NSLog(@"|HOME-BANNER-点击事件|type:%@--imagePath:http://128.14.128.207:8815/28/%@",bannerModel.type,bannerModel.imagePath);
        
        if (bannerModel.type.integerValue == -1) {   // 无作用
            
            
        }else if (bannerModel.type.integerValue == 1){  // 根据prouctId请求productDetail
            
            NSString *productID = [NSString stringWithFormat:@"%@",bannerModel.productId];
            NSString *productName = @"玩法说明";
            
            NSDictionary *paramDic = @{@"id":productID};
            
            [self loadProductDetailDataWithParamDic:paramDic productName:productName];
            
        }else if (bannerModel.type.integerValue == 2){  // 生成二维码
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            GPBannerTypeTwoViewController *bannerTypeTwoVC = [storyboard instantiateViewControllerWithIdentifier:@"bannerTypeTwoVC"];
            
            bannerTypeTwoVC.hidesBottomBarWhenPushed = YES;
            
            bannerTypeTwoVC.QRLocation = bannerModel.url;
            
            [self.navigationController pushViewController:bannerTypeTwoVC animated:YES];
            
            
        }else if (bannerModel.type.integerValue == 3){  // 外链
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            GPBannerTypeThreeViewController *bannerTypeThreeVC = [storyboard instantiateViewControllerWithIdentifier:@"bannerTypeThreeVC"];
            
            bannerTypeThreeVC.hidesBottomBarWhenPushed = YES;
            
            bannerTypeThreeVC.webViewLoc = bannerModel.url;
            
            [self.navigationController pushViewController:bannerTypeThreeVC animated:YES];
            
        }
    }
}

#pragma mark - 左侧进入房间按钮
- (IBAction)enterRoomLeftButton:(UIButton *)sender {
    
    if (errorState == 1) {  // 数据连接出错
        
        [ToastView toastViewWithMessage:@"数据连接超时，请稍后再试" timer:3.0];
        
    }else{
        
        if (![self.isLogin isEqualToString:@"1"]) {
            
            [ToastView toastViewWithMessage:@"请先登陆" timer:3.0];
        }else{
            
            NSString *productID = self.leftProductModel.id;
            NSString *productName = self.leftProductModel.productName;
            
            [self turnToPlayListPageWithProductName:productName productID:productID];
        }
    }
    
    
}

#pragma mark - 左侧玩法说明按钮
- (IBAction)gameInstructionButton:(UIButton *)sender {
    
    if (errorState == 1) {  // 数据连接出错
        
        [ToastView toastViewWithMessage:@"数据连接超时，请稍后再试" timer:3.0];
        
    }else{
        
        if (![self.isLogin isEqualToString:@"1"]) {
            
            [ToastView toastViewWithMessage:@"请先登陆" timer:3.0];
        }else{
            
            NSString *productID = self.leftProductModel.id;
            NSString *productName = self.leftProductModel.productName;
            
            NSLog(@"|left|name:%@==id:%@",productName,productID);
            
            NSDictionary *paramDic = @{@"id":productID};
            
            [self loadProductDetailDataWithParamDic:paramDic productName:productName];
        }
    }
    
    
}


#pragma mark - 右侧进入房间按钮
- (IBAction)enterRoomRightButton:(UIButton *)sender {
    
    if (errorState == 1) {  // 数据连接出错
        
        [ToastView toastViewWithMessage:@"数据连接超时，请稍后再试" timer:3.0];
        
    }else{
        
        if (![self.isLogin isEqualToString:@"1"]) {
            
            [ToastView toastViewWithMessage:@"请先登陆" timer:3.0];
        }else{
            
            NSString *productID = self.rightProductModel.id;
            NSString *productName = self.rightProductModel.productName;
            
            [self turnToPlayListPageWithProductName:productName productID:productID];
        }
    }
    
    
}

#pragma mark - 右侧玩法说明按钮
- (IBAction)rightGameInsButton:(UIButton *)sender {
    
    if (errorState == 1) {  // 数据连接出错
        
        [ToastView toastViewWithMessage:@"数据连接超时，请稍后再试" timer:3.0];
        
    }else{
        
        if (![self.isLogin isEqualToString:@"1"]) {
            
            [ToastView toastViewWithMessage:@"请先登陆" timer:3.0];
        }else{
            
            NSString *productID = self.rightProductModel.id;
            NSString *productName = self.rightProductModel.productName;
            
            NSLog(@"|right|name:%@==id:%@",productName,productID);
            
            NSDictionary *paramDic = @{@"id":productID};
            
            [self loadProductDetailDataWithParamDic:paramDic productName:productName];
        }
    }
    
    
}

#pragma mark - 加载玩法说明
- (void)loadProductDetailDataWithParamDic:(NSDictionary *)paramDic productName:(NSString *)productName{
    
    [self.progressHUD showAnimated:YES];
    
    [self loadUserDefaultsData];
    
    NSString *productDetailLoc = [NSString stringWithFormat:@"%@product/1/productDetail",kBaseLocation];
    
    // 请求登陆接口
    __weak typeof(self)weakSelf = self;
    [AFNetManager requestPOSTWithURLStr:productDetailLoc paramDic:paramDic token:self.token finish:^(id responserObject) {
        
        NSLog(@"|GAMEINS-VC|success:%@",responserObject);
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        GPRespondModel *respondModel = [GPRespondModel new];
        
        [respondModel setValuesForKeysWithDictionary:responserObject];
        
        if (respondModel.code.integerValue == 9200) {
            
//            [ToastView toastViewWithMessage:respondModel.msg timer:1.5];
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            GPGameInstroctionViewController *gameInsVC = [storyboard instantiateViewControllerWithIdentifier:@"gameInstrostionVC"];
            
            gameInsVC.htmlString = [respondModel.data objectForKey:@"productExplain"];
            
            gameInsVC.myTitle = productName;
            
            gameInsVC.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:gameInsVC animated:YES];
            
        }else{
            
            [ToastView toastViewWithMessage:respondModel.msg timer:2.5];
        }
        
    } enError:^(NSError *error) {
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        [ToastView toastViewWithMessage:@"数据连接超时，请稍后再试" timer:3.0];
        
    }];
    
}

#pragma mark - 跳转玩法列表
- (void)turnToPlayListPageWithProductName:(NSString *)productName productID:(NSString *)productID{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    GPPlayListViewController *playListVC = [storyboard instantiateViewControllerWithIdentifier:@"playListVC"];
    
    playListVC.productName = productName;
    
    playListVC.productID = productID;
    
    playListVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:playListVC animated:YES];
}

#pragma mark - 获取用户余额
- (void)loadUserMoney{
    
    // 刷新钱包金额
    self.indexLeftMoreView.moneyLab.text = @"??元宝";
    
    [self.progressHUD showAnimated:YES];
    
    NSString *walletLoc = [NSString stringWithFormat:@"%@user/1/money",kBaseLocation];
    
    // 请求登陆接口
    __weak typeof(self)weakSelf = self;
    [AFNetManager requestPOSTWithURLStr:walletLoc paramDic:nil token:self.token finish:^(id responserObject) {
        
        NSLog(@"|MINE-VC-MONEY-REFSH|success:%@",responserObject);
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        GPRespondModel *respondModel = [GPRespondModel new];
        
        [respondModel setValuesForKeysWithDictionary:responserObject];
        
        if (respondModel.code.integerValue == 9200) {
            
            GPWalletModel *walletModel = [GPWalletModel new];
            
            [walletModel setValuesForKeysWithDictionary:respondModel.data];
            
            // 刷新钱包金额
            weakSelf.indexLeftMoreView.moneyLab.text = walletModel.moneyNum;
            
        }else{
            
            [ToastView toastViewWithMessage:respondModel.msg timer:2.5];
        }
        
    } enError:^(NSError *error) {
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        [ToastView toastViewWithMessage:@"数据连接出错，请稍后再试" timer:3.0];
        
    }];
    
}


#pragma mark - 获取第一条公告信息详情
- (void)loadNoticeDetailData{
    
    NSString *contentLoc = [NSString stringWithFormat:@"%@notice/1/noticeDetail",kBaseLocation];
    
    NSDictionary *paramDic = @{@"id":@"x"};
    
    // 请求登陆接口
    __weak typeof(self)weakSelf = self;
    [AFNetManager requestPOSTWithURLStr:contentLoc paramDic:paramDic token:self.token finish:^(id responserObject) {
        
        NSLog(@"|NOTICE-ALERT-CONTENT-VC|success:%@",responserObject);
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        GPRespondModel *respondModel = [GPRespondModel new];
        
        [respondModel setValuesForKeysWithDictionary:responserObject];
        
        if (respondModel.code.integerValue == 9200) {
            
            weakSelf.noticeDetailStr = [respondModel.data objectForKey:@"content"];
            weakSelf.alertNoticeView.noticeTitle.text = [respondModel.data objectForKey:@"title"];
            // 详情内容不为空时加载数据
            if (weakSelf.noticeDetailStr.length != 0) {
                
                [weakSelf.alertNoticeView loadDataWithString:weakSelf.noticeDetailStr];
            }
        }else{
            
//            [ToastView toastViewWithMessage:respondModel.msg timer:2.5];
        }
        
    } enError:^(NSError *error) {
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        [ToastView toastViewWithMessage:@"数据连接超时，请稍后再试" timer:3.0];
        
    }];
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

#pragma mark - 懒加载
- (NSMutableArray *)bannerListArray{
    
    if (!_bannerListArray) {
        
        self.bannerListArray = [NSMutableArray array];
    }
    return _bannerListArray;
}

- (NSMutableArray *)productArray{
    
    if (!_productArray) {
        
        self.productArray = [NSMutableArray array];
    }
    return _productArray;
}

- (GPProductListModel *)leftProductModel{
    
    if (!_leftProductModel) {
        
        self.leftProductModel = [GPProductListModel new];
    }
    return _leftProductModel;
}

- (GPProductListModel *)rightProductModel{
    
    if (!_rightProductModel) {
        
        self.rightProductModel = [GPProductListModel new];
    }
    return _rightProductModel;
}

- (NSMutableArray *)bannerLocArray{
    
    if (!_bannerLocArray) {
        
        self.bannerLocArray = [NSMutableArray array];
    }
    return _bannerLocArray;
}

- (NSMutableArray *)noticeDataArr{
    
    if (!_noticeDataArr) {
        
        self.noticeDataArr = [NSMutableArray array];
    }
    return _noticeDataArr;
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
