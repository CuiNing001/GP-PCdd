//
//  GPMineViewController.m
//  GPLottery
//
//  Created by cc on 2018/3/11.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPMineViewController.h"
#import "GPMineListCell.h"
#import "GPChangeDataViewController.h"
#import "GPWalletViewController.h"
#import "GPBackWaterViewController.h"
#import "GPGameViewController.h"
#import "GPGameListViewController.h"
#import "GPHistoryViewController.h"
#import "GPShareViewController.h"
#import "GPAgentOpenViewController.h"
#import "GPAgentBgViewController.h"
#import "GPSettingViewController.h"
#import "GPEarningsViewController.h"
#import "GPAboutViewController.h"
#import "GPWalletModel.h"

@interface GPMineViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewHeight;

@property (strong, nonatomic) NSString *token;
@property (weak, nonatomic) IBOutlet UIView      *headerView;      // headerView
@property (weak, nonatomic) IBOutlet UITableView *tableView;       // tableView
@property (weak, nonatomic) IBOutlet UIButton    *userImageBtn;    // 头像按钮
@property (weak, nonatomic) IBOutlet UIView      *nickView;        // 昵称、签名view
@property (weak, nonatomic) IBOutlet UILabel     *nickNameLab;     // 昵称lable
@property (weak, nonatomic) IBOutlet UILabel     *signatureLabel;  // 签名label
@property (strong, nonatomic) NSMutableArray     *listImageArray;  // 图标数据
@property (strong, nonatomic) NSMutableArray     *listTextArray;   // 文字数据
@property (strong, nonatomic) NSString           *money;           // 元宝金额
@property (strong, nonatomic) GPInfoModel        *infoModel;       // 本地数据
@property (assign, nonatomic) NSString           *isLogin;         // 登陆状态
@property (strong, nonatomic) MBProgressHUD      *progressHUD;
@property (strong, nonatomic) NSString           *userType;        // 用户类型（1、普通用户。4、代理用户）


@end

@implementation GPMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    [self loadSubView];

}

#pragma mark - 动态计算scrollview高度
- (void)viewWillLayoutSubviews{
    
    [self.bgView layoutIfNeeded];
    
        self.bgViewHeight.constant = 180+self.listTextArray.count*60;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [self loadUserDefaultsData];
    
    // 未登陆状态返回首页界面
    if (![self.isLogin isEqualToString:@"1"]) {
        
        self.tabBarController.selectedIndex = 0;
    }
}


#pragma mark - 加载子控件
- (void)loadSubView{
    
    self.automaticallyAdjustsScrollViewInsets = false;
    
    // 修改资料view添加点击事件
    UITapGestureRecognizer *dataTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeData)];
    [self.nickView addGestureRecognizer:dataTap];
    
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

#pragma mark - 加载数据
- (void)loadData{
    
    [self loadUserDefaultsData];
    
    // 获取用户余额
    [self loadUserMoney];
    
    if (self.userType.integerValue == 1||self.userType.integerValue == 2) {     // 普通用户 1:普通用户，2:测试用户
        
        // 初始化list数据
        self.listImageArray = @[@"mine_wallet",@"mine_backwater",@"mine_game",@"mine_history",@"mine_game_list",@"mine_share",@"mine_get",@"mine_setting",@"mine_about"].mutableCopy;
        self.listTextArray  = @[@"钱包",@"我的回水",@"幸运抽奖",@"帐变记录",@"游戏记录",@"我要分享",@"我的收益",@"设置",@"关于"].mutableCopy;
        
    }else if (self.userType.integerValue == 4){ // 代理用户
        
        // 初始化list数据
        self.listImageArray = @[@"mine_wallet",@"mine_backwater",@"mine_game",@"mine_history",@"mine_game_list",@"mine_agent_open",@"mine_agent_background",@"mine_setting",@"mine_about"].mutableCopy;
        self.listTextArray  = @[@"钱包",@"我的回水",@"幸运抽奖",@"帐变记录",@"游戏记录",@"代理开户",@"代理后台",@"设置",@"关于"].mutableCopy;
    }else{
        
        // 初始化list数据
        self.listImageArray = @[@"mine_wallet",@"mine_backwater",@"mine_game",@"mine_history",@"mine_game_list",@"mine_share",@"mine_get",@"mine_setting",@"mine_about"].mutableCopy;
        self.listTextArray  = @[@"钱包",@"我的回水",@"幸运抽奖",@"帐变记录",@"游戏记录",@"我要分享",@"我的收益",@"设置",@"关于"].mutableCopy;
    }
 
}

#pragma mark - 修改头像
- (IBAction)changeUserImageBtn:(UIButton *)sender {
    
    
}

#pragma mark - 获取用户余额
- (void)loadUserMoney{
    
    [self.progressHUD showAnimated:YES];
    
//    [self loadUserDefaultsData];
    
    self.money = @"??元宝";
    
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
            self.money = walletModel.moneyNum;
            
        }else{
            
            [ToastView toastViewWithMessage:respondModel.msg timer:2.5];
        }
        
        if (![weakSelf.money isEqualToString:@"??元宝"]) {
            
            // 刷新cell-index-0
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
            [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        }
    } enError:^(NSError *error) {
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        [ToastView toastViewWithMessage:@"数据连接出错，请稍后再试" timer:3.0];
        
    }];
    
}

#pragma mark - 修改资料
- (void)changeData{
    
    UIStoryboard *storyboard                 = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    GPChangeDataViewController *changeDataVC = [storyboard instantiateViewControllerWithIdentifier:@"changeDataVC"];
    changeDataVC.username                    = self.infoModel.loginName;
    changeDataVC.hidesBottomBarWhenPushed    = YES;
    [self.navigationController pushViewController:changeDataVC animated:YES];
}

#pragma mark - 加载本地数据
- (void)loadUserDefaultsData{
    
    NSMutableDictionary *infoDic = [UserDefaults searchData];
    
    self.infoModel               = [[GPInfoModel alloc]init];
    
    [self.infoModel setValuesForKeysWithDictionary:infoDic];
    
    // 初始化钱包金额
    self.token = self.infoModel.token;
    
    // 登录状态
    self.isLogin = self.infoModel.islogin;
    
    // 昵称
    self.nickNameLab.text = self.infoModel.nickname;
    
    // 用户类型
    self.userType = self.infoModel.userType;
    
    // 签名
    if (![self.infoModel.autograph isEqualToString:@"请添加个性签名..."]) {
        
        self.signatureLabel.text = self.infoModel.autograph;
    }
    
    NSLog(@"|MINE-VC|-[token]:%@-[username]:%@-[nickname]:%@-[autograph]:%@",self.infoModel.token,self.infoModel.loginName,self.infoModel.nickname,self.infoModel.autograph);
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
    
    // 赋值cell
    if (indexPath.row==0) {
        
        [mineListCell setDataWithImage:self.listImageArray[indexPath.row] text:self.listTextArray[indexPath.row] money:self.money];
        
    }else{
        
        [mineListCell setDataWithImage:self.listImageArray[indexPath.row] text:self.listTextArray[indexPath.row] money:nil];
    }
    
    return mineListCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 点击后取消cell的点击状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.userType.integerValue == 1 || self.userType.integerValue == 2) {  // 普通用户
        
        // cell点击事件
        if (indexPath.row == 0) {       // 钱包
            
            UIStoryboard *storyboard              = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            GPWalletViewController *walletVC      = [storyboard instantiateViewControllerWithIdentifier:@"walletVC"];
            walletVC.hidesBottomBarWhenPushed     = YES;
            [self.navigationController pushViewController:walletVC animated:YES];
            
        }else if (indexPath.row == 1){  // 我的回水
            
            UIStoryboard *storyboard                = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            GPBackWaterViewController *backWaterVC  = [storyboard instantiateViewControllerWithIdentifier:@"backWaterVC"];
            backWaterVC.hidesBottomBarWhenPushed    = YES;
            [self.navigationController pushViewController:backWaterVC animated:YES];
            
        }else if (indexPath.row == 2){  // 幸运抽奖
            
            UIStoryboard *storyboard        = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            GPGameViewController *gameVC    = [storyboard instantiateViewControllerWithIdentifier:@"gameVC"];
            gameVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:gameVC animated:YES];
            
        }else if (indexPath.row == 3){  // 帐变记录
            
            UIStoryboard *storyboard           = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            GPHistoryViewController *historyVC = [storyboard instantiateViewControllerWithIdentifier:@"historyVC"];
            historyVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:historyVC animated:YES];
            
        }else if (indexPath.row == 4){  // 游戏记录
            
            UIStoryboard *storyboard             = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            GPGameListViewController *gameListVC = [storyboard instantiateViewControllerWithIdentifier:@"gameListVC"];
            gameListVC.hidesBottomBarWhenPushed  = YES;
            [self.navigationController pushViewController:gameListVC animated:YES];
            
        }else if (indexPath.row == 5){  // VIP分享
            
            UIStoryboard *storyboard             = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            GPAgentOpenViewController *agentOpenVC = [storyboard instantiateViewControllerWithIdentifier:@"agentOpenVC"];
            agentOpenVC.hidesBottomBarWhenPushed  = YES;
            [self.navigationController pushViewController:agentOpenVC animated:YES];
            
        }else if (indexPath.row == 6){  //  我的收益
            
            UIStoryboard *storyboard             = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            GPEarningsViewController *earningsVC = [storyboard instantiateViewControllerWithIdentifier:@"earningsVC"];
            earningsVC.hidesBottomBarWhenPushed  = YES;
            [self.navigationController pushViewController:earningsVC animated:YES];
            
        }else if (indexPath.row == 7){  // 设置
            
            UIStoryboard *storyboard           = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            GPSettingViewController *settingVC = [storyboard instantiateViewControllerWithIdentifier:@"settingVC"];
            settingVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:settingVC animated:YES];
            
        }else if (indexPath.row == 8){  //  关于
            
            UIStoryboard *storyboard         = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            GPAboutViewController *aboutVC   = [storyboard instantiateViewControllerWithIdentifier:@"aboutVC"];
            aboutVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:aboutVC animated:YES];
            
        }
    }else if (self.userType.integerValue == 4){  // 代理用户
        
        // cell点击事件
        if (indexPath.row == 0) {       // 钱包
            
            UIStoryboard *storyboard              = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            GPWalletViewController *walletVC      = [storyboard instantiateViewControllerWithIdentifier:@"walletVC"];
            walletVC.hidesBottomBarWhenPushed     = YES;
            [self.navigationController pushViewController:walletVC animated:YES];
            
        }else if (indexPath.row == 1){  // 我的回水
            
            UIStoryboard *storyboard                = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            GPBackWaterViewController *backWaterVC  = [storyboard instantiateViewControllerWithIdentifier:@"backWaterVC"];
            backWaterVC.hidesBottomBarWhenPushed    = YES;
            [self.navigationController pushViewController:backWaterVC animated:YES];
            
        }else if (indexPath.row == 2){  // 幸运抽奖
            
            UIStoryboard *storyboard        = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            GPGameViewController *gameVC    = [storyboard instantiateViewControllerWithIdentifier:@"gameVC"];
            gameVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:gameVC animated:YES];
            
        }else if (indexPath.row == 3){  // 帐变记录
            
            UIStoryboard *storyboard           = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            GPHistoryViewController *historyVC = [storyboard instantiateViewControllerWithIdentifier:@"historyVC"];
            historyVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:historyVC animated:YES];
            
        }else if (indexPath.row == 4){  // 游戏记录
            
            UIStoryboard *storyboard             = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            GPGameListViewController *gameListVC = [storyboard instantiateViewControllerWithIdentifier:@"gameListVC"];
            gameListVC.hidesBottomBarWhenPushed  = YES;
            [self.navigationController pushViewController:gameListVC animated:YES];
            
        }else if (indexPath.row == 5){  // 代理开户
            
            UIStoryboard *storyboard             = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            GPAgentOpenViewController *agentOpenVC = [storyboard instantiateViewControllerWithIdentifier:@"agentOpenVC"];
            agentOpenVC.hidesBottomBarWhenPushed  = YES;
            [self.navigationController pushViewController:agentOpenVC animated:YES];
            
        }else if (indexPath.row == 6){  //  代理后台
            
            UIStoryboard *storyboard         = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            GPAgentBgViewController *agentBgVC   = [storyboard instantiateViewControllerWithIdentifier:@"agentBgVC"];
            agentBgVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:agentBgVC animated:YES];
            
        }else if (indexPath.row == 7){  // 设置
            
            UIStoryboard *storyboard           = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            GPSettingViewController *settingVC = [storyboard instantiateViewControllerWithIdentifier:@"settingVC"];
            settingVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:settingVC animated:YES];
            
        }else if (indexPath.row == 8){  //  关于
            
            UIStoryboard *storyboard         = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            GPAboutViewController *aboutVC   = [storyboard instantiateViewControllerWithIdentifier:@"aboutVC"];
            aboutVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:aboutVC animated:YES];
            
        }
    }
    
//    // cell点击事件
//    if (indexPath.row == 0) {       // 钱包
//
//        UIStoryboard *storyboard              = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        GPWalletViewController *walletVC      = [storyboard instantiateViewControllerWithIdentifier:@"walletVC"];
//        walletVC.hidesBottomBarWhenPushed     = YES;
//        [self.navigationController pushViewController:walletVC animated:YES];
//
//    }else if (indexPath.row == 1){  // 我的回水
//
//        UIStoryboard *storyboard                = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        GPBackWaterViewController *backWaterVC  = [storyboard instantiateViewControllerWithIdentifier:@"backWaterVC"];
//        backWaterVC.hidesBottomBarWhenPushed    = YES;
//        [self.navigationController pushViewController:backWaterVC animated:YES];
//
//    }else if (indexPath.row == 2){  // 幸运抽奖
//
//        UIStoryboard *storyboard        = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        GPGameViewController *gameVC    = [storyboard instantiateViewControllerWithIdentifier:@"gameVC"];
//        gameVC.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:gameVC animated:YES];
//
//    }else if (indexPath.row == 3){  // 帐变记录
//
//        UIStoryboard *storyboard           = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        GPHistoryViewController *historyVC = [storyboard instantiateViewControllerWithIdentifier:@"historyVC"];
//        historyVC.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:historyVC animated:YES];
//
//    }else if (indexPath.row == 4){  // 游戏记录
//
//        UIStoryboard *storyboard             = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        GPGameListViewController *gameListVC = [storyboard instantiateViewControllerWithIdentifier:@"gameListVC"];
//        gameListVC.hidesBottomBarWhenPushed  = YES;
//        [self.navigationController pushViewController:gameListVC animated:YES];
//
//    }else if (indexPath.row == 5){  // VIP分享
//
//        UIStoryboard *storyboard         = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        GPShareViewController *shareVC   = [storyboard instantiateViewControllerWithIdentifier:@"shareVC"];
//        shareVC.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:shareVC animated:YES];
//
//    }else if (indexPath.row == 6){  //  代理开户
//
//        UIStoryboard *storyboard             = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        GPAgentOpenViewController *agentOpenVC = [storyboard instantiateViewControllerWithIdentifier:@"agentOpenVC"];
//        agentOpenVC.hidesBottomBarWhenPushed  = YES;
//        [self.navigationController pushViewController:agentOpenVC animated:YES];
//
//    }else if (indexPath.row == 7){  // 代理后台
//
//        UIStoryboard *storyboard         = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        GPAgentBgViewController *agentBgVC   = [storyboard instantiateViewControllerWithIdentifier:@"agentBgVC"];
//        agentBgVC.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:agentBgVC animated:YES];
//
//    }else if (indexPath.row == 8){  //  我的收益
//
//        UIStoryboard *storyboard             = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        GPEarningsViewController *earningsVC = [storyboard instantiateViewControllerWithIdentifier:@"earningsVC"];
//        earningsVC.hidesBottomBarWhenPushed  = YES;
//        [self.navigationController pushViewController:earningsVC animated:YES];
//
//    }else if (indexPath.row == 9){  //  设置
//
//        UIStoryboard *storyboard           = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        GPSettingViewController *settingVC = [storyboard instantiateViewControllerWithIdentifier:@"settingVC"];
//        settingVC.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:settingVC animated:YES];
//
//    }else if (indexPath.row == 10){  //  关于
//
//        UIStoryboard *storyboard         = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        GPAboutViewController *aboutVC   = [storyboard instantiateViewControllerWithIdentifier:@"aboutVC"];
//        aboutVC.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:aboutVC animated:YES];
//    }
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
