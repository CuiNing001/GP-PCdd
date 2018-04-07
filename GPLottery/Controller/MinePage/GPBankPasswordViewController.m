//
//  GPBankPasswordViewController.m
//  GPLottery
//
//  Created by cc on 2018/3/19.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPBankPasswordViewController.h"
#import "GPUserStatusModel.h"

@interface GPBankPasswordViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lastPasswordLab;
@property (weak, nonatomic) IBOutlet UIView *lastPasswordView;
@property (weak, nonatomic) IBOutlet UITextField *lastPasswordTF;
@property (weak, nonatomic) IBOutlet UIButton *setPasswordBtn;


@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordAgainTF;
@property (strong, nonatomic) MBProgressHUD      *progressHUD;
@property (strong, nonatomic) GPInfoModel        *infoModel;
@property (strong, nonatomic) NSString           *token;
@property (strong, nonatomic) GPUserStatusModel  *userStatusModel;  // 用户公共信息

@end

@implementation GPBankPasswordViewController

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
    }else{
        
        // 获取用户状态
        [self loadUserStatus];
    }
    
}

- (void)loadData{
    
    
}

- (void)loadSubView{
    
    self.title = @"提现密码";
    
    self.passwordTF.delegate      = self;
    self.passwordAgainTF.delegate = self;
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(returnKeyboard)];
    [self.view addGestureRecognizer:tap];
    
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
        
        NSLog(@"|BANKPASSWORD-VC|success:%@",responserObject);
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        GPRespondModel *respondModel = [GPRespondModel new];
        
        [respondModel setValuesForKeysWithDictionary:responserObject];
        
        if (respondModel.code.integerValue == 9200) {
            
//            [ToastView toastViewWithMessage:respondModel.msg timer:1.5];
            
            self.userStatusModel = [GPUserStatusModel new];
            
            [self.userStatusModel setValuesForKeysWithDictionary:respondModel.data];
            
            // 根据用户设置提现密码状态修改UI
            if (self.userStatusModel.userExchange.integerValue == 0) {
                // 提现密码未绑定
                self.lastPasswordLab.hidden  = YES;
                self.lastPasswordView.hidden = YES;
                [self.setPasswordBtn setTitle:@"设置" forState:UIControlStateNormal];
                
            }else{
                // 提现密码已绑定
                self.lastPasswordLab.hidden  = NO;
                self.lastPasswordView.hidden = NO;
                [self.setPasswordBtn setTitle:@"修改" forState:UIControlStateNormal];
            }
            
        }else{
            
            [ToastView toastViewWithMessage:respondModel.msg timer:2.5];
        }
        
    } enError:^(NSError *error) {
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        [ToastView toastViewWithMessage:@"数据连接出错，请稍后再试" timer:3.0];
        
    }];
}


#pragma mark - 确认设置
- (IBAction)makeSureButton:(UIButton *)sender {
    
    [self.progressHUD showAnimated:YES];
    
    [self loadUserDefaultsData];
    
    if (self.userStatusModel.userExchange.integerValue == 0) {
        // 提现密码未绑定设置提现密码
        NSString *withdrawalLoc = [NSString stringWithFormat:@"%@user/1/setupPassword",kBaseLocation];
        NSDictionary *paramDic = @{@"exchangePassword":self.passwordTF.text};
        
        // 请求登陆接口
        __weak typeof(self)weakSelf = self;
        [AFNetManager requestPOSTWithURLStr:withdrawalLoc paramDic:paramDic token:self.token finish:^(id responserObject) {
            
            NSLog(@"|BANKPASSWORD-VC|success:%@",responserObject);
            
            [weakSelf.progressHUD hideAnimated:YES];
            
            GPRespondModel *respondModel = [GPRespondModel new];
            
            [respondModel setValuesForKeysWithDictionary:responserObject];
            
            if (respondModel.code.integerValue == 9200) {
                
//                [ToastView toastViewWithMessage:respondModel.msg timer:3.0];
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }else{
                
                [ToastView toastViewWithMessage:respondModel.msg timer:3.0];
            }
            
        } enError:^(NSError *error) {
            
            [weakSelf.progressHUD hideAnimated:YES];
            
            [ToastView toastViewWithMessage:@"数据连接出错，请稍后再试" timer:3.0];
            
        }];
        
    }else{
        // 提现密码已绑定修改提现密码
        NSString *updatePasswordLoc = [NSString stringWithFormat:@"%@user/1/updateWithdrawalsPassword",kBaseLocation];
        NSDictionary *paramDic = @{@"oldWithdrawalsPassword":self.lastPasswordTF.text,@"newWithdrawalsPassword":self.passwordTF.text};
        
        // 请求登陆接口
        __weak typeof(self)weakSelf = self;
        [AFNetManager requestPOSTWithURLStr:updatePasswordLoc paramDic:paramDic token:self.token finish:^(id responserObject) {
            
            NSLog(@"|BANKPASSWORD-VC|success:%@",responserObject);
            
            [weakSelf.progressHUD hideAnimated:YES];
            
            GPRespondModel *respondModel = [GPRespondModel new];
            
            [respondModel setValuesForKeysWithDictionary:responserObject];
            
            if (respondModel.code.integerValue == 9200) {
                
//                [ToastView toastViewWithMessage:respondModel.msg timer:3.0];
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }else{
                
                [ToastView toastViewWithMessage:respondModel.msg timer:3.0];
            }
            
        } enError:^(NSError *error) {
            
            [weakSelf.progressHUD hideAnimated:YES];
            
            [ToastView toastViewWithMessage:@"数据连接出错，请稍后再试" timer:3.0];
            
        }];
        
    }

}

#pragma mark - text field delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    // 输入结束回收键盘
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - 回收键盘
- (void)returnKeyboard{
    
    // 点击空白区域回收键盘
    [self.passwordTF resignFirstResponder];
    [self.passwordAgainTF resignFirstResponder];
    [self.lastPasswordTF resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    // 禁止输入空格
    NSString *tem = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]componentsJoinedByString:@""];
    if (![string isEqualToString:tem]) {
        return NO;
    }
    return YES;
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
