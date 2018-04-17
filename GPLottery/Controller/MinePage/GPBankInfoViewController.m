//
//  GPBankInfoViewController.m
//  GPLottery
//
//  Created by cc on 2018/3/20.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPBankInfoViewController.h"
#import "GPBankCardView.h"
#import "GPBankInfoModel.h"
#import "GPBindBancCardViewController.h"

@interface GPBankInfoViewController ()

@property (strong, nonatomic) GPInfoModel        *infoModel;       // 本地数据
@property (strong, nonatomic) NSString           *token;
@property (strong, nonatomic) MBProgressHUD      *progressHUD;
@property (strong, nonatomic) GPBankCardView     *bankCardView;

@end

@implementation GPBankInfoViewController

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
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}

- (void)loadData{
    
    [self.progressHUD showAnimated:YES];
    
    [self loadUserDefaultsData];
    
    NSString *bankInfoLoc = [NSString stringWithFormat:@"%@user/1/myBankInfo",kBaseLocation];
    
    // 请求登陆接口
    __weak typeof(self)weakSelf = self;
    [AFNetManager requestPOSTWithURLStr:bankInfoLoc paramDic:nil token:self.token finish:^(id responserObject) {
        
        NSLog(@"|BANKINFO-VC|success:%@",responserObject);
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        GPRespondModel *respondModel = [GPRespondModel new];
        
        [respondModel setValuesForKeysWithDictionary:responserObject];
        
        if (respondModel.code.integerValue == 9200) {
            
//            [ToastView toastViewWithMessage:respondModel.msg timer:1.5];
            
            GPBankInfoModel *bankInfoModel = [GPBankInfoModel new];
            
            [bankInfoModel setValuesForKeysWithDictionary:respondModel.data];
            
            [weakSelf.bankCardView setDataWithModel:bankInfoModel];
            
        }else{
            
            [ToastView toastViewWithMessage:respondModel.msg timer:2.5];
        }
        
    } enError:^(NSError *error) {
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        [ToastView toastViewWithMessage:@"数据连接出错，请稍后再试" timer:3.0];
        
    }];
    
}

- (void)loadSubView{
    
    self.title = self.pageTitle;
    
    self.bankCardView = [[GPBankCardView alloc]initWithFrame:CGRectMake(0, 84, kSize_width, kSize_height)];
    [self.view addSubview:_bankCardView];
    
    // 初始化加载框
    self.progressHUD = [[MBProgressHUD alloc]initWithFrame:CGRectMake(0, 0, kSize_width, kSize_height)];
    [self.view addSubview:_progressHUD];
    
    // 修改银行卡信息
    __weak typeof(self)weakSelf = self;
    self.bankCardView.changeBankBlock = ^{
        
        [weakSelf changeBnakInfoButton];
    };
}

#pragma mark - 修改银行卡信息
- (void)changeBnakInfoButton{
    
    UIStoryboard *storyboard              = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    GPBindBancCardViewController *bindBankCardVC      = [storyboard instantiateViewControllerWithIdentifier:@"bindBankCardVC"];
    bindBankCardVC.hidesBottomBarWhenPushed     = YES;
    [self.navigationController pushViewController:bindBankCardVC animated:YES];
}

#pragma mark - 加载本地数据
- (void)loadUserDefaultsData{
    
    NSMutableDictionary *infoDic = [UserDefaults searchData];
    
    self.infoModel               = [[GPInfoModel alloc]init];
    
    [self.infoModel setValuesForKeysWithDictionary:infoDic];
    
    self.token = self.infoModel.token;
    
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
