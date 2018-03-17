//
//  GPAgentOpenViewController.m
//  GPLottery
//
//  Created by cc on 2018/3/15.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPAgentOpenViewController.h"
#import "GPLinkOpenAccuoutView.h"
#import "GPShareModel.h"

@interface GPAgentOpenViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton    *accountBtn;        // 直接开户
@property (weak, nonatomic) IBOutlet UIButton    *linkAccountBtn;    // 链接开户
@property (weak, nonatomic) IBOutlet UITextField *usernameTF;        // 用户名
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;        // 用户密码
@property (weak, nonatomic) IBOutlet UITextField *verifyPasswordTF;  // 验证密码
@property (strong, nonatomic) MBProgressHUD      *progressHUD;
@property (strong, nonatomic) GPInfoModel        *infoModel;
@property (strong, nonatomic) NSString           *token;
@property (strong, nonatomic) NSMutableArray     *dataArray;     // 玩法数据
@property (strong, nonatomic) GPLinkOpenAccuoutView *linkView;   // 链接开户view

@end

@implementation GPAgentOpenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadData];
    [self loadSubView];
}

#pragma mark - 加载数据
- (void)loadData{
    
    self.title = @"代理开户";
    
    // 代理开户数据
    [self loadNetData];
}

#pragma mark - 加载子控件
- (void)loadSubView{

    // 初始化linkView
    self.linkView = [[GPLinkOpenAccuoutView alloc]initWithFrame:CGRectMake(0, 80+64, kSize_width, kSize_height-84)];
    [self.view addSubview:self.linkView];
    self.linkView.hidden = YES;
    
    // 实现linkView复制按钮点击事件
    __weak typeof(self)weakSelf = self;
    self.linkView.copyBlock = ^{
        
        // 复制二维码地址到剪切板
        [weakSelf copyQRCardBlock];
    };
    
    // linkView图片长按手势点击事件
    self.linkView.longPressBlock = ^{
        
        // 长按图片保存到相册
        [weakSelf saveQRImage];
    };
    
    // 输入框代理
    self.usernameTF.delegate       = self;
    self.passwordTF.delegate       = self;
    self.verifyPasswordTF.delegate = self;
    
    // 添加空白区域点击事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(returnKeyboard)];
    [self.view addGestureRecognizer:tap];
}


#pragma mark - 加载代理开户数据
- (void)loadNetData{
    
    [self.progressHUD showAnimated:YES];
    
    // 加载本地数据
    [self loadUserDefaultsData];
    
    // 获取地址
    NSString *linkAccountLoc = [NSString stringWithFormat:@"%@1/shareUser",kBaseLocation];
    
    // 请求登陆接口
    __weak typeof(self)weakSelf = self;
    [AFNetManager requestPOSTWithURLStr:linkAccountLoc paramDic:nil token:self.token finish:^(id responserObject) {
        
        NSLog(@"|LINKACUUENT-VC|success:%@",responserObject);
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        GPRespondModel *respondModel = [GPRespondModel new];
        
        [respondModel setValuesForKeysWithDictionary:responserObject];
        
        if (respondModel.code.integerValue == 9200) {
            
            [ToastView toastViewWithMessage:respondModel.msg timer:1.5];
            
            GPShareModel *shareModel = [GPShareModel new];
            
            [shareModel setValuesForKeysWithDictionary:respondModel.data];
            
            // 二维码赋值
            weakSelf.linkView.qrImageStr = shareModel.url;
            [weakSelf.linkView loadQRCardWithLoc];
            
        }else{
            
            [ToastView toastViewWithMessage:respondModel.msg timer:2.5];
        }
        
    } enError:^(NSError *error) {
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        [ToastView toastViewWithMessage:@"数据连接出错，请稍后再试" timer:3.0];
        
    }];
}


#pragma mark - 复制二维码地址
- (void)copyQRCardBlock{
    
    // 复制到剪切板
    UIPasteboard *pastboard = [UIPasteboard generalPasteboard];
    pastboard.string = self.linkView.urlLab.text;
    
    // 提醒框
    [ToastView toastViewWithMessage:@"已复制到剪切板" timer:3.0];
    
}

#pragma mark - 图片长按保存二维码
- (void)saveQRImage{
    
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"保存图片" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消保存图片");
    }];
    
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"确认保存图片");
        
        // 保存图片到相册
    UIImageWriteToSavedPhotosAlbum(self.linkView.qrCardImage.image,self,@selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:),nil); }];
    
    [alertControl addAction:cancel];
    [alertControl addAction:confirm];
    [self presentViewController:alertControl animated:YES completion:nil];
}

#pragma mark 保存图片后的回调
- (void)imageSavedToPhotosAlbum:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(id)contextInfo
{
    NSString*message =@"提示";
    if(!error) {
        message =@"成功保存到相册";
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {  }];
        
        [alertControl addAction:action];
        
        [self presentViewController:alertControl animated:YES completion:nil];
        
    }else
        
    {
        message = [error description];
        
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {   }];
        
        [alertControl addAction:action];
        
        [self presentViewController:alertControl animated:YES completion:nil];
        
    }
    
}


#pragma mark - 直接开户
- (IBAction)openAccuontButton:(UIButton *)sender {
    
    self.linkView.hidden = YES;
    self.accountBtn.backgroundColor = [UIColor whiteColor];
    [self.accountBtn setTitleColor:[UIColor colorWithRed:26/255.0 green:198/255.0 blue:133/255.0 alpha:1] forState:UIControlStateNormal];
    self.linkAccountBtn.backgroundColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1];
    [self.linkAccountBtn setTitleColor:[UIColor colorWithRed:69/255.0 green:69/255.0 blue:69/255.0 alpha:1] forState:UIControlStateNormal];
    
}

#pragma mark - 链接开户
- (IBAction)linkAccuontButton:(UIButton *)sender {
    
    self.linkView.hidden = NO;
    self.linkAccountBtn.backgroundColor = [UIColor whiteColor];
    [self.linkAccountBtn setTitleColor:[UIColor colorWithRed:26/255.0 green:198/255.0 blue:133/255.0 alpha:1] forState:UIControlStateNormal];
    self.accountBtn.backgroundColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1];
    [self.accountBtn setTitleColor:[UIColor colorWithRed:69/255.0 green:69/255.0 blue:69/255.0 alpha:1] forState:UIControlStateNormal];
}


#pragma mark - 确定按钮
- (IBAction)makeSureButton:(UIButton *)sender {
    
    // 加载本地数据
    [self loadUserDefaultsData];
    
    // 直接开户数据
    NSString *openAcuuentLoc = [NSString stringWithFormat:@"%@1/directUser",kBaseLocation];
    NSDictionary *paramDic = @{@"userLoginName":self.usernameTF.text,@"passWord":self.passwordTF.text};
    
    // 请求登陆接口
    __weak typeof(self)weakSelf = self;
    [AFNetManager requestPOSTWithURLStr:openAcuuentLoc paramDic:paramDic token:self.token finish:^(id responserObject) {
        
        NSLog(@"|OPENACCUENT-VC|success:%@",responserObject);
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        GPRespondModel *respondModel = [GPRespondModel new];
        
        [respondModel setValuesForKeysWithDictionary:responserObject];
        
        if (respondModel.code.integerValue == 9200) {
            
            [ToastView toastViewWithMessage:respondModel.msg timer:1.5];
            
        }else{
            
            [ToastView toastViewWithMessage:respondModel.msg timer:2.5];
        }
        
    } enError:^(NSError *error) {
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        [ToastView toastViewWithMessage:@"数据连接出错，请稍后再试" timer:3.0];
        
    }];
    
    [self returnKeyboard];
}

#pragma mark - 输入框代理方法
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
    
    if (textField.tag == 2010) {
        // 判断输入格式
        if ([RegexPattern validateUserName:self.usernameTF.text] == 0) {
            
            [ToastView toastViewWithMessage:@"用户名格式不正确" timer:2.0];
        }
    }else if (textField.tag == 2011){
        
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
    [self.verifyPasswordTF resignFirstResponder];
}

#pragma mark - 加载本地数据
- (void)loadUserDefaultsData{
    
    NSMutableDictionary *infoDic = [UserDefaults searchData];
    
    self.infoModel               = [[GPInfoModel alloc]init];
    
    [self.infoModel setValuesForKeysWithDictionary:infoDic];
    
    self.token = self.infoModel.token;
    
}

#pragma mark - 提醒框
- (void)alertViewWithTitle:(NSString *)title message:(NSString *)message{
    
    UIAlertController *alert  = [UIAlertController alertControllerWithTitle:title
                                                                    message:message
                                                             preferredStyle:UIAlertControllerStyleActionSheet];
    
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

#pragma mark -懒加载
- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
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
