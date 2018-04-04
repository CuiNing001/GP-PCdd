//
//  GPForgetPasswordViewController.m
//  GPLottery
//
//  Created by cc on 2018/3/30.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPForgetPasswordViewController.h"

@interface GPForgetPasswordViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *usernameTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTF;
@property (weak, nonatomic) IBOutlet UITextField *captchaTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *captchaNumBtn;
@property (strong, nonatomic) MBProgressHUD *progressHUD;  // 加载框


@end

@implementation GPForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    forgetPasswordVC
    
    [self loadSubView];
    [self loadData];
}

- (void)loadData{
    
    
}

- (void)loadSubView{
    
    // textfield代理
    [self setDelegateForTextfield];
    
    // 添加空白区域点击事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(returnKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    // 初始化加载框
    self.progressHUD = [[MBProgressHUD alloc]initWithFrame:CGRectMake(0, 0, kSize_width, kSize_height)];
    [self.view addSubview:_progressHUD];
    
}

#pragma mark - 获取验证码
- (IBAction)captchaNumButton:(UIButton *)sender {
    
    if (self.usernameTF.text.length>0 && self.phoneNumTF.text.length>0) {
        
        // 获取验证码
        [self receiveCaptchaNum];
        
    }else{
        
        [ToastView toastViewWithMessage:@"请输入用户名和手机号" timer:3.0];
    }
}

#pragma mark - 获取验证码数据
- (void)receiveCaptchaNum{
    
    [self.progressHUD showAnimated:YES];
    
    NSString *captchaLoc = [NSString stringWithFormat:@"%@1/sendCaptchaByResetPassWord",kBaseLocation];
    
    NSDictionary *paramDic = @{@"loginName":self.usernameTF.text,@"phone":self.phoneNumTF.text};
    
    // 请求登陆接口
    __weak typeof(self)weakSelf = self;
    [AFNetManager requestPOSTWithURLStr:captchaLoc paramDic:paramDic token:nil finish:^(id responserObject) {
        
        NSLog(@"|CAPTCHA-PHONE-NUMBER-VC|success:%@",responserObject);
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        GPRespondModel *respondModel = [GPRespondModel new];
        
        [respondModel setValuesForKeysWithDictionary:responserObject];
        
        NSLog(@"=============%@",respondModel.msg);
        
        if (respondModel.code.integerValue == 9200) {
            
//            [ToastView toastViewWithMessage:respondModel.msg timer:1.5];
            
        }else{
            
            [ToastView toastViewWithMessage:respondModel.msg timer:2.5];
        }
        
    } enError:^(NSError *error) {
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        [ToastView toastViewWithMessage:@"数据连接出错，请稍后再试" timer:3.0];
        
    }];
}


#pragma mark - 确定修改密码
- (IBAction)makeSureButton:(UIButton *)sender {
    
    if (self.usernameTF.text.length>0 && self.phoneNumTF.text.length>0 && self.captchaTF.text.length>0 && self.passwordTF.text.length>0) {
        
        [self makeSureChangePassword];
        
    }else{
        
        [ToastView toastViewWithMessage:@"请补全信息" timer:3.0];
    }
}

#pragma mark - 修改密码接口
- (void)makeSureChangePassword{
    
    [self.progressHUD showAnimated:YES];
    
    NSString *captchaLoc = [NSString stringWithFormat:@"%@user/1/resetPassWord",kBaseLocation];
    
    NSDictionary *paramDic = @{@"loginName":self.usernameTF.text,@"phone":self.phoneNumTF.text,@"captcha":self.captchaTF.text,@"passWord":self.passwordTF.text};
    
    // 请求登陆接口
    __weak typeof(self)weakSelf = self;
    [AFNetManager requestPOSTWithURLStr:captchaLoc paramDic:paramDic token:nil finish:^(id responserObject) {
        
        NSLog(@"|RESET-PASSWORD-VC|success:%@",responserObject);
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        GPRespondModel *respondModel = [GPRespondModel new];
        
        [respondModel setValuesForKeysWithDictionary:responserObject];
        
        if (respondModel.code.integerValue == 9200) {
            
//            [ToastView toastViewWithMessage:respondModel.msg timer:1.5];
            
        }else{
            
            [ToastView toastViewWithMessage:respondModel.msg timer:2.5];
        }
        
    } enError:^(NSError *error) {
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        [ToastView toastViewWithMessage:@"数据连接出错，请稍后再试" timer:3.0];
        
    }];
}

#pragma mark - 关闭页面
- (IBAction)dissmissButton:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - textfield代理
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
    
    if (textField.tag == 4001) {
        // 判断输入格式
        if ([RegexPattern validateUserName:self.usernameTF.text] == 0) {
            
            [ToastView toastViewWithMessage:@"用户名格式不正确" timer:2.0];
        }
    }else if (textField.tag == 4002){
        
        // （6-20个字符）
        if ([RegexPattern validatePassword:self.passwordTF.text] == 0) {
            
            [ToastView toastViewWithMessage:@"密码格式不正确" timer:2.0];
        }
    }
}

- (void)setDelegateForTextfield{
    
    self.usernameTF.delegate = self;
    self.phoneNumTF.delegate = self;
    self.captchaTF.delegate = self;
    self.passwordTF.delegate = self;
    
    self.usernameTF.tag = 4001;
    self.passwordTF.tag = 4002;

}

#pragma mark - 回收键盘
- (void)returnKeyboard{
    
    // 点击空白区域回收键盘
    [self.usernameTF resignFirstResponder];
    [self.passwordTF resignFirstResponder];
    [self.phoneNumTF resignFirstResponder];
    [self.captchaTF  resignFirstResponder];
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
