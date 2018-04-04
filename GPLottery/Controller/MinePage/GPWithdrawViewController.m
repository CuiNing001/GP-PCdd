//
//  GPWithdrawViewController.m
//  GPLottery
//
//  Created by cc on 2018/3/19.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPWithdrawViewController.h"
#import "GPWithdrawInfoModel.h"

@interface GPWithdrawViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) GPInfoModel        *infoModel;            // 本地数据
@property (strong, nonatomic) NSString           *token;
@property (strong, nonatomic) MBProgressHUD      *progressHUD;
@property (weak, nonatomic) IBOutlet UILabel     *accountNameLab;       // 开户名
@property (weak, nonatomic) IBOutlet UILabel     *bankCardAccountLab;   //卡号
@property (weak, nonatomic) IBOutlet UILabel     *bankNameLab;          // 银行名称
@property (weak, nonatomic) IBOutlet UIWebView   *remindWebView;        // 提醒
@property (weak, nonatomic) IBOutlet UIWebView   *instructionsWebView;  // 提现须知
@property (weak, nonatomic) IBOutlet UITextField *moneyTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;


@end

@implementation GPWithdrawViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadNetData];
    [self loadSubView];

}

- (void)loadSubView{
    
    self.title = @"提现";
    
    // 初始化加载框
    self.progressHUD = [[MBProgressHUD alloc]initWithFrame:CGRectMake(0, 0, kSize_width, kSize_height)];
    [self.view addSubview:_progressHUD];
    
    // 添加代理
    self.moneyTF.delegate    = self;
    self.passwordTF.delegate = self;
    
    // 添加空白区域点击事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(returnKeyboard)];
    [self.view addGestureRecognizer:tap];
}

#pragma mark - 提现数据
- (void)loadNetData{
    
    [self loadUserDefaultsData];
    
    NSString *withdrawLoc = [NSString stringWithFormat:@"%@user/1/enterWithdraw",kBaseLocation];
    
    // 请求登陆接口
    __weak typeof(self)weakSelf = self;
    [AFNetManager requestPOSTWithURLStr:withdrawLoc paramDic:nil token:self.token finish:^(id responserObject) {
        
        NSLog(@"|WITHDRAW-VC|success:%@",responserObject);
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        GPRespondModel *respondModel = [GPRespondModel new];
        
        [respondModel setValuesForKeysWithDictionary:responserObject];
        
        if (respondModel.code.integerValue == 9200) {
            
//            [ToastView toastViewWithMessage:respondModel.msg timer:1.5];
            
            GPWithdrawInfoModel *withdrawInfoModel = [GPWithdrawInfoModel new];
            
            [withdrawInfoModel setValuesForKeysWithDictionary:respondModel.data];
            
            // 设置提现信息
            [self setWithdrawInfoWithModel:withdrawInfoModel];
            
        }else{
            
            [ToastView toastViewWithMessage:respondModel.msg timer:2.5];
        }
        
    } enError:^(NSError *error) {
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        [ToastView toastViewWithMessage:@"数据连接出错，请稍后再试" timer:3.0];
        
    }];
}

#pragma mark - 确认提现
- (IBAction)makeSureButton:(UIButton *)sender {
    
    [self.progressHUD showAnimated:YES];
    
    NSString *makeSureWithdrawLoc = [NSString stringWithFormat:@"%@user/1/withdrawIng",kBaseLocation];
    NSDictionary *paramDic = @{@"exchangePassword":self.moneyTF.text,@"amount":self.passwordTF.text};
    
    // 请求登陆接口
    __weak typeof(self)weakSelf = self;
    [AFNetManager requestPOSTWithURLStr:makeSureWithdrawLoc paramDic:paramDic token:self.token finish:^(id responserObject) {
        
        NSLog(@"|WITHDRAW-VC|success:%@",responserObject);
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        GPRespondModel *respondModel = [GPRespondModel new];
        
        [respondModel setValuesForKeysWithDictionary:responserObject];
        
        if (respondModel.code.integerValue == 9200) {
            
//            [ToastView toastViewWithMessage:respondModel.msg timer:3.0];

            [self.navigationController popViewControllerAnimated:YES];
        }else{
            
            [ToastView toastViewWithMessage:respondModel.msg timer:3.0];
        }
        
    } enError:^(NSError *error) {
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        [ToastView toastViewWithMessage:@"数据连接出错，请稍后再试" timer:3.0];
        
    }];
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

#pragma mark - 回收键盘
- (void)returnKeyboard{
    
    // 点击空白区域回收键盘
    [self.moneyTF    resignFirstResponder];
    [self.passwordTF resignFirstResponder];
}

#pragma mark - 加载本地数据
- (void)loadUserDefaultsData{
    
    NSMutableDictionary *infoDic = [UserDefaults searchData];
    
    self.infoModel               = [[GPInfoModel alloc]init];
    
    [self.infoModel setValuesForKeysWithDictionary:infoDic];
    
    self.token = self.infoModel.token;
    
}

#pragma mark - 设置页面数据
- (void)setWithdrawInfoWithModel:(GPWithdrawInfoModel *)model{
    
    self.accountNameLab.text     = model.accountName;      // 开户姓名
    self.bankCardAccountLab.text = model.bankCardAccount;  // 银行卡号
    self.bankNameLab.text        = model.bankName;         // 银行名称
    [self.instructionsWebView loadHTMLString:model.withdrawExplain baseURL:nil]; // 提现须知
    [self.remindWebView loadHTMLString:model.withdrawRemind baseURL:nil];        // 提醒
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
