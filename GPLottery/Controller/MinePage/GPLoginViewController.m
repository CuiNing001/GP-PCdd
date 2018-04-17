//
//  GPLoginViewController.m
//  GPLottery
//
//  Created by cc on 2018/3/13.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPLoginViewController.h"
#import "GPRegistViewController.h"
#import "GPLoginModel.h"
#import "GPForgetPasswordViewController.h"

@interface GPLoginViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *usernameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

@property (strong, nonatomic) MBProgressHUD      *progressHUD;  // 加载框
@property (strong, nonatomic) NSString           *loginUrl;     // 登录地址
@property (strong, nonatomic) NSString           *username;     // 用户名
@property (strong, nonatomic) NSString           *password;     // 密码
@property (strong, nonatomic) NSString           *token;        // token
@property (strong, nonatomic) NSDictionary       *paramDic;     // 参数

@end

@implementation GPLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self loadSubView];
    
}

#pragma mark - 添加子控件
- (void)loadSubView{
    
    // 填写默认用户名
    NSString *locationLoginName = [UserDefaults searchLoginName];
    
    if (locationLoginName.length>0) {
        
        self.usernameTF.text = locationLoginName;
    }
    
    self.automaticallyAdjustsScrollViewInsets = false;
    
    [self setTextFieldDelegate];
    
    // 添加空白区域点击事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(returnKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    // 初始化加载框
    self.progressHUD = [[MBProgressHUD alloc]initWithFrame:CGRectMake(0, 0, kSize_width, kSize_height)];
    [self.view addSubview:_progressHUD];
}

#pragma mark - 添加数据
- (void)loadData{
    
    self.loginUrl = [NSString stringWithFormat:@"%@1/login",kBaseLocation];
    self.username = self.usernameTF.text;
    self.password = self.passwordTF.text;
    self.token    = @"";
    self.paramDic = @{@"loginName" :self.username,
                      @"password"  :self.password};
}

#pragma mark - 关闭按钮
- (IBAction)dissmissButton:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 返回按钮
- (IBAction)backTohomePage:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 登录按钮
- (IBAction)loginButton:(UIButton *)sender {
    
    [self.progressHUD showAnimated:YES];
    
    [self loadData];
    
    if (self.username.length>0 && self.password.length>0) {
        
        // 请求登陆接口
        __weak typeof(self)weakSelf = self;
        [AFNetManager requestPOSTWithURLStr:self.loginUrl paramDic:self.paramDic token:self.token finish:^(id responserObject) {
            
            NSLog(@"|LOGIN-VC|success:%@",responserObject);
            
            [weakSelf.progressHUD hideAnimated:YES];
            
            GPRespondModel *respondModel = [GPRespondModel new];
            
            [respondModel setValuesForKeysWithDictionary:responserObject];
            
            if (respondModel.code.integerValue == 9200) {
                
                GPLoginModel *loginModel = [GPLoginModel new];
                
                [loginModel setValuesForKeysWithDictionary:respondModel.data];
                
                if (loginModel.nickname == nil) {
                    
                    loginModel.nickname = @"用户昵称";
                }
                
                if (loginModel.autograph == nil) {
                    
                    loginModel.autograph = @"请添加个性签名...";
                }
                
                
                
                // 登录极光
                [JMSGUser loginWithUsername:loginModel.id password:kJMPassword completionHandler:^(id resultObject, NSError *error) {
                    
                    if (!error) {  // 登录成功
                        
                        NSLog(@"|LOGIN-VC|-|JM-LOGIN-resultObject|%@",resultObject);
                        
                        // 关闭登陆界面
                        [weakSelf dismissViewControllerAnimated:YES completion:nil];
                        
//                        [ToastView toastViewWithMessage:respondModel.msg timer:3.0];
                        
                        // 存储数据
                        [UserDefaults addDataWithUsername:self.username
                                                 password:self.password
                                                    token:loginModel.token
                                                 nickname:loginModel.nickname
                                                  islogin:@"1"
                                                 moneyNum:loginModel.moneyNum
                                                   userID:loginModel.id
                                                    level:loginModel.level
                                                autograph:loginModel.autograph];
                        
                        
                        
                    }else{  // 登录失败
                        
                        NSLog(@"|LOGIN-VC|-|JM-LOGIN-ERROR|%@",error);
                    }
                }];
                
            }else{
                
                [ToastView toastViewWithMessage:respondModel.msg timer:3.0];
            }
            
        } enError:^(NSError *error) {
            
            [weakSelf.progressHUD hideAnimated:YES];
            
            [ToastView toastViewWithMessage:@"数据连接出错，请稍后再试" timer:3.0];
            
            NSLog(@"|LOGIN-VC|-|login-error|%@",error);
            
        }];
    }else{
        
        [self.progressHUD hideAnimated:YES];
        [ToastView toastViewWithMessage:@"请补全登录信息" timer:3.0];
    }
    
    
}

#pragma mark - 注册按钮
- (IBAction)goToRegistPage:(UIButton *)sender {
    
    GPRegistViewController *registVC;
    
    [self getControllerFromStoryboardWithIdentifier:@"registVC" myVC:(GPRegistViewController *)registVC];
}

#pragma mark - 忘记密码
- (IBAction)forgetPassword:(UIButton *)sender {
    
    GPForgetPasswordViewController *forgetPasswordVC;
    
    [self getControllerFromStoryboardWithIdentifier:@"forgetPasswordVC" myVC:forgetPasswordVC];
}

#pragma mark - 三方登录
- (IBAction)loginByQQ:(UIButton *)sender {
    
    
}

- (IBAction)loginByWeChat:(UIButton *)sender {
    
    
}

#pragma mark - text field delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    // 输入结束回收键盘
    [textField resignFirstResponder];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // 禁止输入空格
    NSString *tem = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]componentsJoinedByString:@""];
    if (![string isEqualToString:tem]) {
        return NO;
    }
    return YES;
}

// 检测输入格式
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (textField.tag == 2001) {
        // 判断输入格式
        if ([RegexPattern validateUserName:self.usernameTF.text] == 0) {
            
            [ToastView toastViewWithMessage:@"用户名格式不正确" timer:2.0];
        }
    }else if (textField.tag == 2002){
        
        // （6-20个字符）
        if ([RegexPattern validatePassword:self.passwordTF.text] == 0) {
            
            [ToastView toastViewWithMessage:@"密码格式不正确" timer:2.0];
        }
    }
}

#pragma mark - 回收键盘
- (void)returnKeyboard{
    
    // 点击空白区域回收键盘
    [self.usernameTF resignFirstResponder];
    [self.passwordTF resignFirstResponder];
}

#pragma mark - 添加输入框代理
- (void)setTextFieldDelegate{
    
    self.usernameTF.delegate = self;
    self.passwordTF.delegate = self;
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
