//
//  GPSettingViewController.m
//  GPLottery
//
//  Created by cc on 2018/3/14.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPSettingViewController.h"
#import "GPMineListCell.h"
#import "GPHomeViewController.h"
#import "GPBinfPhoneViewController.h"
#import "GPBindBancCardViewController.h"
#import "GPUpdatePasswordViewController.h"
#import "GPBankPasswordViewController.h"
#import "GPCleanDataViewController.h"
#import "GPUserStatusModel.h"

@interface GPSettingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray     *listImageArray;  // 图标数据
@property (strong, nonatomic) NSMutableArray     *listTextArray;   // 文字数据
@property (strong, nonatomic) MBProgressHUD      *progressHUD;  // 加载框
@property (strong, nonatomic) GPInfoModel        *infoModel;
@property (strong, nonatomic) NSString           *token;
@property (strong, nonatomic) GPUserStatusModel  *userStatusModel;


@end

@implementation GPSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    [self loadSubView];
}

- (void)viewWillAppear:(BOOL)animated{
    
    
}

- (void)loadData{
    
    // 初始化list数据
    self.listImageArray = @[@"setting_card",@"setting_password_change",@"setting_withdraw_password",@"setting_clean",@"setting_phone"].mutableCopy;
    self.listTextArray  = @[@"绑定银行卡",@"修改密码",@"提现密码",@"清除缓存",@"绑定手机"].mutableCopy;
    
    // 获取用户状态信息
    [self loadUserStatus];

}

- (void)loadSubView{
    
    self.automaticallyAdjustsScrollViewInsets = false;
    
    self.title = @"设置";
    
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
        
        NSLog(@"|SETTING-VC|success:%@",responserObject);
        
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

#pragma mark - 退出登陆
- (IBAction)singoutButton:(UIButton *)sender {
    
    [self.progressHUD showAnimated:YES];
    
    [JMSGUser logout:nil];
    
    // 删除本地数据
    [UserDefaults deleateData];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
//    [self.progressHUD hideAnimated:YES];
    
    
    
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
    
    // cell点击事件
    if (indexPath.row == 0) {       // 绑定银行卡
        
        if (self.userStatusModel.phoneStatus.integerValue == 0) {
            
            // 手机号未绑定跳转绑定手机号
            [self alertViewWithTitle:@"提醒" message:@"请先绑定手机号"];
 
        }else{
            
            // 未设置提现密码先设置提现密码
            if (self.userStatusModel.userExchange.integerValue == 0) {
                
                [self bankPasswordVCAlertViewWithTitle:@"提醒" message:@"请先设置提现密码"];
                
            }else{
                
                // 手机号已绑定跳转绑定银行卡
                UIStoryboard *storyboard              = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                GPBindBancCardViewController *bindBankCardVC      = [storyboard instantiateViewControllerWithIdentifier:@"bindBankCardVC"];
                bindBankCardVC.hidesBottomBarWhenPushed     = YES;
                [self.navigationController pushViewController:bindBankCardVC animated:YES];
                
            }
        }
    
    }else if (indexPath.row == 1){  // 修改密码
        
        UIStoryboard *storyboard                = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        GPUpdatePasswordViewController *updatePasswordVC  = [storyboard instantiateViewControllerWithIdentifier:@"updatePasswordVC"];
        updatePasswordVC.hidesBottomBarWhenPushed    = YES;
        [self.navigationController pushViewController:updatePasswordVC animated:YES];
        
    }else if (indexPath.row == 2){  // 提现密码
        
        if (self.userStatusModel.phoneStatus == false) {
            
            // 手机号未绑定跳转绑定手机号
            [self alertViewWithTitle:@"提醒" message:@"请先绑定手机号"];
            
        }else{
        
        UIStoryboard *storyboard        = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        GPBankPasswordViewController *bankPasswordVC    = [storyboard instantiateViewControllerWithIdentifier:@"bankPasswordVC"];
        bankPasswordVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:bankPasswordVC animated:YES];
            
        }
        
    }else if (indexPath.row == 3){  // 清除缓存
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error;
        NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
        __block NSInteger size = 0;
        NSArray *AllContents = [fileManager subpathsAtPath:cachePath];
        if (!error) {
            [AllContents enumerateObjectsUsingBlock:^(NSString *subPath, NSUInteger idx, BOOL * _Nonnull stop) {
                //注意属性必须通过全路径
                NSString *fullPath = [cachePath stringByAppendingPathComponent:subPath];
                
                BOOL isDirectory = NO;
                
                if (!isDirectory) {
                    //计算文件大小
                    NSInteger biteSize = [[fileManager attributesOfItemAtPath:fullPath error:nil][NSFileSize] integerValue];
                    size += biteSize;
                }
            }];
        }
        [fileManager removeItemAtPath:cachePath error:nil];
        NSString *msg = [NSString stringWithFormat:@"清除了%.2fMB",(float)size/(1000*1000)];
        [ToastView toastViewWithMessage:msg timer:3.0];
        
    }else if (indexPath.row == 4){  // 绑定手机
        
        UIStoryboard *storyboard             = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        GPBinfPhoneViewController *bindPhoneVC = [storyboard instantiateViewControllerWithIdentifier:@"bindPhoneVC"];
        bindPhoneVC.hidesBottomBarWhenPushed  = YES;
        [self.navigationController pushViewController:bindPhoneVC animated:YES];
        
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
