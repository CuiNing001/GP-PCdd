//
//  GPRegistViewController.m
//  GPLottery
//
//  Created by cc on 2018/3/13.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPRegistViewController.h"
#import "GPRegistModel.h"

@interface GPRegistViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *usernameTF;      // 用户名
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;      // 密码
@property (weak, nonatomic) IBOutlet UITextField *passwordAgainTF; // 密码again
@property (weak, nonatomic) IBOutlet UITextField *refereeTF;       // 推荐人
@property (strong, nonatomic) MBProgressHUD      *progressHUD;     // 加载框

@property (strong, nonatomic) NSString     *registerUrl;     // 注册地址
@property (strong, nonatomic) NSString     *token;           // token
@property (strong, nonatomic) NSDictionary *paramDic;        // 参数
@property (strong, nonatomic) NSString     *username;        // 用户名
@property (strong, nonatomic) NSString     *password;        // 密码
@property (strong, nonatomic) NSString     *passwordAgain;   // 确认密码
@property (strong, nonatomic) NSString     *reference;       // 介绍人

@end

@implementation GPRegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadSubView];
}

#pragma mark - 添加子控件
- (void)loadSubView{
    
    [self setTextFieldDelegate];
    
    // 添加加载框
    self.progressHUD = [[MBProgressHUD alloc]initWithFrame:CGRectMake(0, 0, kSize_width, kSize_height)];
    
    [self.view addSubview:self.progressHUD];
    
    // 添加空白区域点击事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(returnKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    // 添加键盘状态监听
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(changeViewFrame:)
                                                name:UIKeyboardWillShowNotification
                                              object:nil];
}

#pragma mark - 添加数据
- (void)loadData{
    
    self.registerUrl   = [NSString stringWithFormat:@"%@1/register",kBaseLocation];
    self.token         = @"";
    self.username      = self.usernameTF.text;
    self.password      = self.passwordTF.text;
    self.passwordAgain = self.passwordAgainTF.text;
    self.reference     = self.refereeTF.text;
    
    // 根据介绍人是否为空初始化参数
    if (self.reference!=nil) {
        
        self.paramDic = @{@"loginName":self.username,
                          @"password":self.password,
                          @"pid":self.reference
                          };
        
    }else{
        
        self.paramDic = @{@"loginName":self.username,
                          @"password":self.password,
                          };
        
    }
}

#pragma mark - 返回界面
- (IBAction)backToLoginPage:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 注册按钮
- (IBAction)registButton:(UIButton *)sender {
    
    [self.progressHUD showAnimated:YES];
    
    [self loadData];
    
    if ([self.password isEqualToString:self.passwordAgain]) {
        
        // 请求注册数据
        __weak typeof(self)weakSelf = self;
        [AFNetManager requestPOSTWithURLStr:self.registerUrl paramDic:self.paramDic token:self.token finish:^(id responserObject) {
            
            NSLog(@"|REGIST-VC|success:%@",responserObject);
            
            [weakSelf.progressHUD hideAnimated:YES];
            
            GPRespondModel *respondModel = [GPRespondModel new];
            
            [respondModel setValuesForKeysWithDictionary:responserObject];
            
            if (respondModel.code.integerValue == 9200) {
                
                [ToastView toastViewWithMessage:respondModel.msg timer:2.5];
                
                GPRegistModel *registModel = [GPRegistModel new];
                
                [registModel setValuesForKeysWithDictionary:respondModel.data];
                
                NSLog(@"|REGIST-VC|-[ID]:%@-[TOKEN]:%@",registModel.id,registModel.token);
                
                [weakSelf dismissViewControllerAnimated:YES completion:nil];     // 注册成功返回登陆页面
                
            }else{
                
                [ToastView toastViewWithMessage:respondModel.msg timer:3.0];
            }
            
            
        } enError:^(NSError *error) {
            
            [weakSelf.progressHUD hideAnimated:YES];
            
            [ToastView toastViewWithMessage:@"数据连接出错，请稍后再试" timer:3.0];
            
        }];
        
        
    }else{
        
        [self.progressHUD hideAnimated:YES];
        
        [self alertViewWithTitle:@"" message:@"两次密码输入不一致"];
    }
}

#pragma mark - text field delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    // 输入结束回收键盘
    [textField resignFirstResponder];
    
    // 取消键盘后还原view的frame
    [UIView animateWithDuration:0.5 animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, 0);
    }];
    
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
    
    if (textField.tag == 2003) {
        // （数字或英文字母4-20个字符）
        if ([RegexPattern validateUserName:self.usernameTF.text]==0) {
            
            [ToastView toastViewWithMessage:@"用户名格式不正确" timer:1.5];
        }
    }else if (textField.tag == 2004){
        // （6-20个字符）
        if ([RegexPattern validatePassword:self.passwordTF.text]==0) {
            
            [ToastView toastViewWithMessage:@"密码格式不正确" timer:1.5];
        }
    }else if (textField.tag == 2005){
        // （6-20个字符）
        if ([RegexPattern validatePassword:self.passwordAgainTF.text]==0) {
            
            [ToastView toastViewWithMessage:@"密码格式不正确" timer:1.5];
            
        }else {
            
            if (self.passwordTF.text!=self.passwordAgainTF.text){
                
                [ToastView toastViewWithMessage:@"两次密码不一致" timer:1.5];
            }
        }
    }else if (textField.tag == 2006){
        // （非必填）
        
    }
}

#pragma mark - 回收键盘
- (void)returnKeyboard{
    
    [self.usernameTF      resignFirstResponder];
    [self.passwordTF      resignFirstResponder];
    [self.passwordAgainTF resignFirstResponder];
    [self.refereeTF       resignFirstResponder];
    
    // 取消键盘后还原view的frame
    [UIView animateWithDuration:0.5 animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, 0);
    }];
}

#pragma mark - 添加输入框代理
- (void)setTextFieldDelegate{
    
    self.usernameTF.delegate      = self;
    self.passwordTF.delegate      = self;
    self.passwordAgainTF.delegate = self;
    self.refereeTF.delegate       = self;
}

#pragma mark - 键盘弹出时界面上移
-(void)changeViewFrame:(NSNotification *) notification{
    
    //获取处于焦点中的view
    NSArray *textFields = @[self.usernameTF,self.passwordTF,self.passwordAgainTF,self.refereeTF];
    
    UIView *focusView   = nil;
    
    for (UITextField *view in textFields) {
        
        if ([view isFirstResponder]) {
            focusView = view;
            break;
        }
    }
    if (focusView) {
        
        //获取键盘上端Y坐标
        CGFloat keyboardY = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
        
        //获取输入框下端相对于window的Y坐标
        CGRect rect       = [focusView convertRect:focusView.bounds toView:[[[UIApplication sharedApplication] delegate] window]];
        CGPoint tmp       = rect.origin;
        CGFloat inputBoxY = tmp.y + focusView.frame.size.height;
        
        //计算二者差值
        CGFloat ty        = keyboardY - inputBoxY;
        
        //差值小于0，做平移变换
        [UIView animateWithDuration:0.5 animations:^{
            if (ty < 0) {
                self.view.transform = CGAffineTransformMakeTranslation(0, ty);
                
                
            }
        }];
    }
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

#pragma mark - 移除通知
- (void)dealloc{
    
    // 移除所有通知
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
    NSLog(@"|REGISTER-VC|移除所有通知");
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
