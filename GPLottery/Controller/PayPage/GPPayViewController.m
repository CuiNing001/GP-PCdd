//
//  GPPayViewController.m
//  GPLottery
//
//  Created by cc on 2018/3/11.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPPayViewController.h"
#import "GPPayMoneyViewController.h"
#import "GPLinePayRecordViewController.h"
#import "GPNormalPayViewController.h"
#import "GPCoverView.h"
#import "GPNormalAliPayViewController.h"
#import "GPPayNoticeView.h"

/*
 * indexNum==0  QQ支付    ==>默认状态
 * indexNum==1  QQ钱包支付
 * indexNum==2  QQ钱包支付2
 * indexNum==3  支付宝支付
 */
static NSInteger indexNum;
@interface GPPayViewController ()
@property (weak, nonatomic) IBOutlet UIButton *checkRecordBtn;

@property (weak, nonatomic) IBOutlet UIImageView *indexZeroImg;  // index0图片
@property (weak, nonatomic) IBOutlet UIImageView *indexOneImg;   // index1图片
@property (strong, nonatomic) GPPayNoticeView   *coverView;            // 遮罩view
@property (strong, nonatomic) NSString *normalImageName;      // 单选框正常状态
@property (strong, nonatomic) NSString *selectedImageName;    // 单选框选中状态

@property (strong, nonatomic) GPInfoModel *infoModel;            // 本地数据
@property (strong, nonatomic) MBProgressHUD *progressHUD;
@property (strong, nonatomic) NSString *token;
@property (strong, nonatomic) NSString *notice;


@end

@implementation GPPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadData];
    [self loadSubView];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [self loadUserDefaultsData];
    
    // 未登陆状态返回首页界面
    if (![self.infoModel.islogin isEqualToString:@"1"]) {
        
        self.tabBarController.selectedIndex = 0;
    }else{
        
        // 添加引导页
        [self initCoverView];
    }
    
}

#pragma mark - 加载子控件
- (void)loadSubView{
    
    self.automaticallyAdjustsScrollViewInsets = false;
    
}

#pragma mark - 加载数据
- (void)loadData{
    
    
    // 单选框图片
    self.normalImageName   = @"check_normal";
    self.selectedImageName = @"check_seleced";
    
    // 设置默认选项
    indexNum = 0;
    
    self.checkRecordBtn.layer.borderWidth = 1;
    self.checkRecordBtn.layer.borderColor = [UIColor colorWithRed:26/255.0 green:198/255.0 blue:133/255.0 alpha:1].CGColor;
    
}

#pragma mark - 加载本地数据
- (void)loadUserDefaultsData{
    
    NSMutableDictionary *infoDic = [UserDefaults searchData];
    
    self.infoModel               = [[GPInfoModel alloc]init];
    
    [self.infoModel setValuesForKeysWithDictionary:infoDic];
    
    self.token   = self.infoModel.token;
    
}

#pragma mark - 获取充值须知
- (NSString *)loadPayNotice{
    
    NSString *payNoticeLoc = [NSString stringWithFormat:@"%@1/payNotice",kBaseLocation];
    
    // 请求登陆接口
    __weak typeof(self)weakSelf = self;
    [AFNetManager requestPOSTWithURLStr:payNoticeLoc paramDic:nil token:self.token finish:^(id responserObject) {
        
        NSLog(@"|PAY-NOTICE-VC|success:%@",responserObject);
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        GPRespondModel *respondModel = [GPRespondModel new];
        
        [respondModel setValuesForKeysWithDictionary:responserObject];
        
        if (respondModel.code.integerValue == 9200) {
            
//            [ToastView toastViewWithMessage:respondModel.msg timer:1.5];
            
            // 获取充值须知
            self.notice = [respondModel.data objectForKey:@"payNotice"];
            
            [self.coverView setDataWithString:self.notice];
            
        }else{
            
            [ToastView toastViewWithMessage:respondModel.msg timer:2.5];
        }
        
    } enError:^(NSError *error) {
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        [ToastView toastViewWithMessage:@"数据连接出错，请稍后再试" timer:3.0];
        
    }];
    
    return self.notice;
}

#pragma mark - section one check-box 单选框点击事件
- (IBAction)indexZeroTap:(UITapGestureRecognizer *)sender {
    
    // 修改单选框图片状态
    self.indexZeroImg.image  = [UIImage imageNamed:self.selectedImageName];
    self.indexOneImg.image   = [UIImage imageNamed:self.normalImageName];
  
    // 设置选中按钮
    indexNum = 0;
    
}

- (IBAction)indexOneTap:(UITapGestureRecognizer *)sender {
    
    // 修改单选框图片状态
    self.indexOneImg.image   = [UIImage imageNamed:self.selectedImageName];
    self.indexZeroImg.image  = [UIImage imageNamed:self.normalImageName];
   
    // 设置选中按钮
    indexNum = 1;
}


// 去支付
- (IBAction)payforButton:(UIButton *)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    GPPayMoneyViewController *payMoneyVC = [storyboard instantiateViewControllerWithIdentifier:@"payMoneyVC"];
    
    if (indexNum==0) {
        
        NSLog(@"微信支付");
        
        [ToastView toastViewWithMessage:@"暂未开启" timer:3.0];
        
//        payMoneyVC.titleStr = @"微信支付";
//        payMoneyVC.typeStr = @"2";
//        payMoneyVC.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:payMoneyVC animated:YES];
        
    }else if (indexNum==1){
        
        NSLog(@"跳转支付宝支付");
        
        payMoneyVC.titleStr = @"支付宝支付";
        payMoneyVC.typeStr = @"1";
        payMoneyVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:payMoneyVC animated:YES];
        
    }
   
}


#pragma mark - section two 点击事件
- (IBAction)sectionTwoRowZeroTap:(UITapGestureRecognizer *)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    GPNormalPayViewController *normalPayVC = [storyboard instantiateViewControllerWithIdentifier:@"normalPayVC"];
    
    normalPayVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:normalPayVC animated:YES];
}

- (IBAction)sectionTwoRowOneTap:(UITapGestureRecognizer *)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    GPNormalAliPayViewController *normalAliPayVC = [storyboard instantiateViewControllerWithIdentifier:@"normalAliPayVC"];
    
    normalAliPayVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:normalAliPayVC animated:YES];
}

// 查看转账记录
- (IBAction)viewTransferRecord:(UIButton *)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    GPLinePayRecordViewController *linePayVC = [storyboard instantiateViewControllerWithIdentifier:@"linePayVC"];
    
    linePayVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:linePayVC animated:YES];
    
}

#pragma mark - 遮罩层view
- (void)initCoverView{
    
    NSString *notice = [self loadPayNotice];
    
    // 添加提醒遮罩
    self.coverView = [[GPPayNoticeView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.coverView];  // 把遮罩层添加到keyWindow上
    
    // 添加点击事件
    UITapGestureRecognizer *hiddenTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenCover)];
    [self.coverView addGestureRecognizer:hiddenTap];
    
    
    
//    // 遮罩上添加图片
//    UIImageView *tipImage = [[UIImageView alloc]initWithFrame:self.view.frame];
//    tipImage.image = [UIImage imageNamed:@"pay_lunch@2x"];
//    [self.coverView addSubview:tipImage];
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
