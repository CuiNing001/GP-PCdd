//
//  GPWalletViewController.m
//  GPLottery
//
//  Created by cc on 2018/3/14.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPWalletViewController.h"
#import "GPMineListCell.h"
#import "GPWalletModel.h"
#import "GPBindBancCardViewController.h"
#import "GPPayViewController.h"
#import "GPWithdrawViewController.h"
#import "GPRechargeViewController.h"
#import "GPWithdrawListViewController.h"
#import "GPUserStatusModel.h"
#import "GPBinfPhoneViewController.h"
#import "GPBankPasswordViewController.h"
#import "GPBankInfoViewController.h"

@interface GPWalletViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel     *myMoneyLab;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) MBProgressHUD      *progressHUD;
@property (strong, nonatomic) NSMutableArray     *listImageArray;  // 图标数据
@property (strong, nonatomic) NSMutableArray     *listTextArray;   // 文字数据
@property (strong, nonatomic) NSString           *walletLoc;       // 钱包数据地址
@property (strong, nonatomic) GPInfoModel        *infoModel;       // 本地数据
@property (strong, nonatomic) NSString           *token;
@property (strong, nonatomic) GPUserStatusModel  *userStatusModel;


@end

@implementation GPWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的钱包";
    
    [self loadSubView];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated{
    
    
    [self loadUserDefaultsData];
    
    // 未登陆状态返回首页界面
    if (![self.infoModel.islogin isEqualToString:@"1"]) {
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        
        // 获取用户状态信息
        [self loadUserStatus];
    }
    
    
}

- (void)loadData{
    
    // 初始化list数据
    self.listImageArray = @[@"wallet_card",@"wallet_ recharge",@"wallet_ withdraw",@"wallet_recharge_list",@"wallet_ withdraw_list"].mutableCopy;
    self.listTextArray  = @[@"我的银行卡",@"充值",@"提现",@"充值记录",@"提现记录"].mutableCopy;
    
    // 请求数据
    [self loadNetData];
}

- (void)loadSubView{
    
    // table view 代理
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    
    // tableView样式
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled  = NO;
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"GPMineListCell" bundle:nil] forCellReuseIdentifier:@"mineListCell"];
    
    // 初始化加载框
    self.progressHUD = [[MBProgressHUD alloc]initWithFrame:CGRectMake(0, 0, kSize_width, kSize_height)];
    [self.view addSubview:_progressHUD];
    
}

#pragma mark - 请求数据
- (void)loadNetData{
    
    [self.progressHUD showAnimated:YES];
    
    [self loadUserDefaultsData];
    
    self.walletLoc = [NSString stringWithFormat:@"%@user/1/money",kBaseLocation];
    
    // 请求登陆接口
    __weak typeof(self)weakSelf = self;
    [AFNetManager requestPOSTWithURLStr:self.walletLoc paramDic:nil token:self.token finish:^(id responserObject) {
        
        NSLog(@"|WALLET-VC|success:%@",responserObject);
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        GPRespondModel *respondModel = [GPRespondModel new];
        
        [respondModel setValuesForKeysWithDictionary:responserObject];
        
        if (respondModel.code.integerValue == 9200) {
            
//            [ToastView toastViewWithMessage:respondModel.msg timer:1.5];
            
            GPWalletModel *walletModel = [GPWalletModel new];
            
            [walletModel setValuesForKeysWithDictionary:respondModel.data];
            
            // 设置钱包金额
            self.myMoneyLab.text = walletModel.moneyNum;
            
        }else{
            
            [ToastView toastViewWithMessage:respondModel.msg timer:2.5];
        }
        
    } enError:^(NSError *error) {
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        [ToastView toastViewWithMessage:@"数据连接出错，请稍后再试" timer:3.0];
        
    }];
    
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
        
        NSLog(@"|WALLET-VC|success:%@",responserObject);
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        GPRespondModel *respondModel = [GPRespondModel new];
        
        [respondModel setValuesForKeysWithDictionary:responserObject];
        
        if (respondModel.code.integerValue == 9200) {
            
//            [ToastView toastViewWithMessage:respondModel.msg timer:1.5];
            
            self.userStatusModel = [GPUserStatusModel new];
            
            [self.userStatusModel setValuesForKeysWithDictionary:respondModel.data];
            
        }else{
            
            [ToastView toastViewWithMessage:respondModel.msg timer:2.5];
        }
        
    } enError:^(NSError *error) {
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        [ToastView toastViewWithMessage:@"数据连接出错，请稍后再试" timer:3.0];
        
    }];
}


#pragma mark - 加载本地数据
- (void)loadUserDefaultsData{
    
    NSMutableDictionary *infoDic = [UserDefaults searchData];
    
    self.infoModel               = [[GPInfoModel alloc]init];
    
    [self.infoModel setValuesForKeysWithDictionary:infoDic];
    
    self.token = self.infoModel.token;
    
}


#pragma mark - tableView dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.listImageArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GPMineListCell *mineListCell = [tableView dequeueReusableCellWithIdentifier:@"mineListCell" forIndexPath:indexPath];
    
    [mineListCell setDataWithImage:self.listImageArray[indexPath.row] text:self.listTextArray[indexPath.row] money:nil];
    
    return mineListCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 点击后取消cell的点击状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {        // 我的银行卡
       
        if (self.userStatusModel.phoneStatus.integerValue == 0) {
            
            // 手机号未绑定跳转绑定手机号
            [self alertViewWithTitle:@"提醒" message:@"请先绑定手机号"];
            
        }else{
            
            // 未设置提现密码先设置提现密码
            if (self.userStatusModel.userExchange.integerValue == 0) {
                
                [self bankPasswordVCAlertViewWithTitle:@"提醒" message:@"请先设置提现密码"];
                
            }else{
                
                // 未绑定银行卡跳转到绑定银行卡页面
                if (self.userStatusModel.bankStatus.integerValue == 0) {
                    
                    UIStoryboard *storyboard                     = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    GPBindBancCardViewController *bindBankCardVC = [storyboard instantiateViewControllerWithIdentifier:@"bindBankCardVC"];
                    bindBankCardVC.hidesBottomBarWhenPushed      = YES;
                    [self.navigationController pushViewController:bindBankCardVC animated:YES];
                    
                }else{
                    // 已绑定跳转银行信息页面
                    GPBankInfoViewController *bankInfoVC = [[GPBankInfoViewController alloc]init];
                    bankInfoVC.pageTitle = @"我的银行卡";
                    [self.navigationController pushViewController:bankInfoVC animated:YES];
                    
                }
                
            }
        }
    }else if (indexPath.row == 1){   // 充值
        
        UIStoryboard *storyboard       = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        GPPayViewController *payVC     = [storyboard instantiateViewControllerWithIdentifier:@"payVC"];
        payVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:payVC animated:YES];
        
    }else if (indexPath.row == 2){   // 提现
        
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

    }else if (indexPath.row == 3){   // 充值记录
        
        UIStoryboard *storyboard             = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        GPRechargeViewController *rechargeVC = [storyboard instantiateViewControllerWithIdentifier:@"rechargeListVC"];
        rechargeVC.hidesBottomBarWhenPushed  = YES;
        [self.navigationController pushViewController:rechargeVC animated:YES];
        
    }else if (indexPath.row == 4){   // 提现记录
        
        UIStoryboard *storyboard                     = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        GPWithdrawListViewController *withdrawListVC = [storyboard instantiateViewControllerWithIdentifier:@"withdrawListVC"];
        withdrawListVC.hidesBottomBarWhenPushed      = YES;
        [self.navigationController pushViewController:withdrawListVC animated:YES];
    }
    
}
    
#pragma mark - 提醒框
// 跳转到绑定手机号
- (void)alertViewWithTitle:(NSString *)title message:(NSString *)message{
        
        UIAlertController *alert  = [UIAlertController alertControllerWithTitle:title
                                                                        message:message
                                                                 preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction     *action = [UIAlertAction actionWithTitle:@"确定"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * _Nonnull action) {
                                                               
                                                               // 跳转到绑定手机号
                                                               UIStoryboard *storyboard               = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                                               GPBinfPhoneViewController *bindPhoneVC = [storyboard instantiateViewControllerWithIdentifier:@"bindPhoneVC"];
                                                               bindPhoneVC.hidesBottomBarWhenPushed   = YES;
                                                               [self.navigationController pushViewController:bindPhoneVC animated:YES];
                                                           }];
        
        [alert addAction:action];
        
        [self presentViewController:alert
                           animated:YES
                         completion:nil];
        
    }
    
// 跳转到设置提现密码
- (void)bankPasswordVCAlertViewWithTitle:(NSString *)title message:(NSString *)message{
        
        UIAlertController *alert  = [UIAlertController alertControllerWithTitle:title
                                                                        message:message
                                                                 preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction     *action = [UIAlertAction actionWithTitle:@"确定"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * _Nonnull action) {
                                                               
                                                               // 跳转到设置提现密码
                                                               UIStoryboard *storyboard                     = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                                               GPBankPasswordViewController *bankPasswordVC = [storyboard instantiateViewControllerWithIdentifier:@"bankPasswordVC"];
                                                               bankPasswordVC.hidesBottomBarWhenPushed      = YES;
                                                               [self.navigationController pushViewController:bankPasswordVC animated:YES];
                                                               
                                                           }];
        
        [alert addAction:action];
        
        [self presentViewController:alert
                           animated:YES
                         completion:nil];
        
    }

#pragma mark - 懒加载
- (NSMutableArray *)listImageArray{
    
    if (!_listImageArray) {
        
        self.listImageArray = [NSMutableArray array];
    }
    
    return _listImageArray;
}

- (NSMutableArray *)listTextArray{
    
    if (!_listTextArray) {
        
        self.listTextArray = [NSMutableArray array];
    }
    
    return _listTextArray;
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
