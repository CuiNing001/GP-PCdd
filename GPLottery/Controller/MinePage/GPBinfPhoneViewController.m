//
//  GPBinfPhoneViewController.m
//  GPLottery
//
//  Created by cc on 2018/3/19.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPBinfPhoneViewController.h"

static int timer = 60;
@interface GPBinfPhoneViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneNumTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (strong, nonatomic) MBProgressHUD *progressHUD;
@property (strong, nonatomic) GPInfoModel    *infoModel;
@property (strong, nonatomic) NSString       *token;
@property (strong, nonatomic) NSTimer *timer;  // 获取验证码倒计时

@end

@implementation GPBinfPhoneViewController

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

#pragma mark - 加载数据
- (void)loadData{
    
    
}

#pragma mark - 加载子控件
- (void)loadSubView{
    
    self.title = @"绑定手机号";
    
    self.phoneNumTF.delegate = self;
    self.codeTF.delegate     = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(returnKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    // 初始化加载框
    self.progressHUD = [[MBProgressHUD alloc]initWithFrame:CGRectMake(0, 0, kSize_width, kSize_height)];
    [self.view addSubview:_progressHUD];
    
    // 获取验证码按钮默认不可用
//    [self.getCodeBtn setEnabled:NO];
    self.getCodeBtn.backgroundColor = [UIColor colorWithRed:26/255.0 green:198/255.0 blue:133/255.0 alpha:1];
    
    self.timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(countdown) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:self.timer forMode:NSDefaultRunLoopMode];
    // 关闭定时器
    [self.timer setFireDate:[NSDate distantFuture]];
}

#pragma mark - 加载网络数据
- (void)loadNetData{
    
    
}

#pragma mark - 倒计时
- (void)countdown{
    
    timer--;
    
    [self.getCodeBtn setTitle:[NSString stringWithFormat:@"%d秒",timer] forState:UIControlStateNormal];
    
    if (timer == 0) {
        [self.getCodeBtn setTitle:[NSString stringWithFormat:@"获取验证码"] forState:UIControlStateNormal];
        // 关闭定时器
        [self.timer setFireDate:[NSDate distantFuture]];
        timer = 60;
        [self.getCodeBtn setEnabled:YES];
        self.getCodeBtn.backgroundColor = [UIColor colorWithRed:26/255.0 green:198/255.0 blue:133/255.0 alpha:1];
    }
}

#pragma mark - 确定绑定手机号
- (IBAction)makeSureButton:(UIButton *)sender {
    
    if (self.phoneNumTF.text.length==11&&self.codeTF.text.length>0) {
        
        [self.progressHUD showAnimated:YES];
        
        [self loadUserDefaultsData];
        
        NSString *getCodeStr = [NSString stringWithFormat:@"%@user/1/bindPhone",kBaseLocation];
        NSDictionary *paramDic = @{@"phone":self.phoneNumTF.text,@"captcha":self.codeTF.text};
        
        // 请求登陆接口
        __weak typeof(self)weakSelf = self;
        [AFNetManager requestPOSTWithURLStr:getCodeStr paramDic:paramDic token:self.token finish:^(id responserObject) {
            
            NSLog(@"|BINDPHONE-VC|success:%@",responserObject);
            
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
        
        [ToastView toastViewWithMessage:@"请输入手机号" timer:3.0];
    }
    
    
    
}


#pragma mark - 获取验证码
- (IBAction)getCodeButton:(UIButton *)sender {
    
    if (self.phoneNumTF.text.length == 11) {
        
        [self.progressHUD showAnimated:YES];
        
        [self loadUserDefaultsData];
        
        NSString *getCodeStr = [NSString stringWithFormat:@"%@user/1/sendCaptcha",kBaseLocation];
        NSDictionary *paramDic = @{@"phone":self.phoneNumTF.text};
        
        // 请求登陆接口
        __weak typeof(self)weakSelf = self;
        [AFNetManager requestPOSTWithURLStr:getCodeStr paramDic:paramDic token:self.token finish:^(id responserObject) {
            
            NSLog(@"|BINDPHONE-VC|success:%@",responserObject);
            
            [weakSelf.progressHUD hideAnimated:YES];
            
            GPRespondModel *respondModel = [GPRespondModel new];
            
            [respondModel setValuesForKeysWithDictionary:responserObject];
            
            if (respondModel.code.integerValue == 9200) {
                
                // 开启定时器
                [weakSelf.timer setFireDate:[NSDate distantPast]];
                self.getCodeBtn.backgroundColor = [UIColor lightGrayColor];
                [weakSelf.getCodeBtn setEnabled:NO];
            }else{
                
                [ToastView toastViewWithMessage:respondModel.msg timer:3.0];
            }
            
        } enError:^(NSError *error) {
            
            [weakSelf.progressHUD hideAnimated:YES];
            
            [ToastView toastViewWithMessage:@"数据连接出错，请稍后再试" timer:3.0];
            
        }];
        
    }else{
        
        [ToastView toastViewWithMessage:@"请添加手机号" timer:3.0];
    }
    
    
    
}


#pragma mark - 回收键盘
- (void)returnKeyboard{
    
    // 点击空白区域回收键盘
    [self.phoneNumTF resignFirstResponder];
    [self.codeTF     resignFirstResponder];
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

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
//    if (textField.tag == 4001 ) {
//
//        self.getCodeBtn.backgroundColor = [UIColor lightGrayColor];
//
////        [self.getCodeBtn setEnabled:NO];
//    }
    
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField;{
    
//    if (![self.phoneNumTF.text isEqualToString:@""]&&self.phoneNumTF.text.length == 11) {
//
//        self.getCodeBtn.backgroundColor = [UIColor colorWithRed:26/255.0 green:198/255.0 blue:133/255.0 alpha:1];
//
////        [self.getCodeBtn setEnabled:YES];
//
//    }else{
//
//        self.getCodeBtn.backgroundColor = [UIColor lightGrayColor];
//
//        [self.getCodeBtn setEnabled:NO];
//    }
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
