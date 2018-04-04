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

@end

@implementation GPHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self loadData];
    [self loadSubView];
    
    
//    //延迟加载VersionBtn - 避免wimdow还没出现就往上加控件造成的crash
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self setVersionBtn];
//    });
}

//#pragma mark - 添加全局按钮
//-(void)setVersionBtn{
//    
//    MNAssistiveBtn *btn = [MNAssistiveBtn mn_touchWithType:MNAssistiveTouchTypeNone
//                                                     Frame:CGRectMake(0, 200, 50, 50)
//                                                     title:nil
//                                                titleColor:[UIColor whiteColor]
//                                                 titleFont:[UIFont systemFontOfSize:11]
//                                           backgroundColor:nil
//                                           backgroundImage:[UIImage imageNamed:@"global_btn"]];
//    
//    [btn addTarget:self action:@selector(turnToService:) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    
//    [window addSubview:btn];
//    
//}
//#pragma mark - 跳转客服
//- (void)turnToService:(UIButton *)sender{
//    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    
//    GPServiceViewController *serviceVC = [storyboard instantiateViewControllerWithIdentifier:@"serviceVC"];
//    
//    serviceVC.hidesBottomBarWhenPushed = YES;
//    
//    // 创建单聊会话成功
//    [self.navigationController pushViewController:serviceVC animated:YES];
//
//}

-(void)viewWillAppear:(BOOL)animated{
    
    
    // 加载本地数据
    [self loadUserDefaultsData];
}

#pragma mark - 动态计算scrollview高度
- (void)viewWillLayoutSubviews{
    
    [self.bgView layoutIfNeeded];
    
//    self.bgViewHeight.constant = kSize_height;
}

#pragma mark - 加载子控件
- (void)loadSubView{
    
    self.automaticallyAdjustsScrollViewInsets = false;
    
//    GPRoomBetView *betView = [[GPRoomBetView alloc]initWithFrame:self.view.frame];
//    [self.view addSubview:betView];
    
    // 添加tabbar代理
    self.tabBarController.delegate = self;
    
    // 轮播图view添加边框
//    self.headerView.layer.borderColor = [UIColor orangeColor].CGColor;
//    self.headerView.layer.borderWidth = 1;
    
    // 设置轮播图
    CGRect rect = CGRectMake(self.headerView.bounds.origin.x, self.headerView.bounds.origin.y, self.headerView.bounds.size.width, self.headerView.bounds.size.height);
    self.scrollView = [SDCycleScrollView cycleScrollViewWithFrame:rect
                                                                       delegate:self
                                                               placeholderImage:[UIImage imageNamed:@"home_banner_placehorder.jpg"]];
    //    scrollView.imageURLStringsGroup = self.bannerListArrya;                            // 轮播图网络图片
//    self.scrollView.localizationImageNamesGroup = @[@"1.jpg",@"2.jpg"];                       // 轮播图本地图片
    self.scrollView.scrollDirection             = UICollectionViewScrollDirectionHorizontal;; // 轮播图滚动方向（左右滚动）
    self.scrollView.autoScrollTimeInterval      = 3.0;                                        // 轮播图滚动时间间隔
    self.scrollView.contentMode = UIViewContentModeScaleToFill;
    [self.headerView addSubview:self.scrollView];
    
    // 初始化加载框
    self.progressHUD = [[MBProgressHUD alloc]initWithFrame:CGRectMake(0, 0, kSize_width, kSize_height)];
    [self.view addSubview:_progressHUD];
    
}

#pragma mark - 加载数据
- (void)loadData{
    
    // 设置登陆状态
    self.isLogin = self.infoModel.islogin;
    
    [self loadNetData];
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
            
            NSMutableArray *bannerLocArray = [NSMutableArray array];
            // 获取轮播图数据
            for (NSDictionary *bannerDic in indexModel.bannerList) {
                
//                NSString *bannerLoc = [NSString stringWithFormat:@"%@%@",kImageLoction,[bannerDic objectForKey:@"imagePath"]];
                
                GPBannerListModel *bannerModel = [GPBannerListModel new];

                [bannerModel setValuesForKeysWithDictionary:bannerDic];
                
                [weakSelf.bannerListArray addObject:bannerModel];
                
                NSString *bannerLoc = [NSString stringWithFormat:@"%@%@",kImageLoction,bannerModel.imagePath];
                
                [bannerLocArray addObject:bannerLoc];
                
                NSLog(@"|HOME-BANNER-TYPE|%@",bannerModel.type);
                
            }
            
            
            // 设置轮播图地址
            self.scrollView.imageURLStringsGroup = bannerLocArray;
            
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
        
        [ToastView toastViewWithMessage:@"数据连接出错，请稍后再试" timer:3.0];
        
        NSLog(@"|HOME-VC|-|home-error|%@",error);
        
    }];
    
}

#pragma mark - 设置首页基本数据
- (void)setIndexDataWithModel:(GPIndexModel *)indexModel{
    
    self.personLab.text = [NSString stringWithFormat:@"%@",indexModel.registerNum];
    self.ratioLab.text = [NSString stringWithFormat:@"%@",indexModel.winRate];
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
    
    GPBannerListModel *bannerModel = self.bannerListArray[index];
    
    NSLog(@"|HOME-BANNER-点击事件|%@",bannerModel.type);
    
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

#pragma mark - 左侧进入房间按钮
- (IBAction)enterRoomLeftButton:(UIButton *)sender {
    
    NSString *productID = self.leftProductModel.id;
    NSString *productName = self.leftProductModel.productName;
    
    [self turnToPlayListPageWithProductName:productName productID:productID];
}

#pragma mark - 左侧玩法说明按钮
- (IBAction)gameInstructionButton:(UIButton *)sender {
    
    NSString *productID = self.leftProductModel.id;
    NSString *productName = self.leftProductModel.productName;
    
    NSLog(@"|left|name:%@==id:%@",productName,productID);
    
    NSDictionary *paramDic = @{@"id":productID};
    
    [self loadProductDetailDataWithParamDic:paramDic productName:productName];
}


#pragma mark - 右侧进入房间按钮
- (IBAction)enterRoomRightButton:(UIButton *)sender {
    
    NSString *productID = self.rightProductModel.id;
    NSString *productName = self.rightProductModel.productName;
    
    [self turnToPlayListPageWithProductName:productName productID:productID];
}

#pragma mark - 右侧玩法说明按钮
- (IBAction)rightGameInsButton:(UIButton *)sender {
    
    NSString *productID = self.rightProductModel.id;
    NSString *productName = self.rightProductModel.productName;
    
    NSLog(@"|right|name:%@==id:%@",productName,productID);
    
    NSDictionary *paramDic = @{@"id":productID};
    
    [self loadProductDetailDataWithParamDic:paramDic productName:productName];
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
        
        [ToastView toastViewWithMessage:@"数据连接出错，请稍后再试" timer:3.0];
        
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
