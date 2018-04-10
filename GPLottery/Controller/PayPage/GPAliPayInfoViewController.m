//
//  GPAliPayInfoViewController.m
//  GPLottery
//
//  Created by cc on 2018/4/9.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPAliPayInfoViewController.h"
#import <SDCycleScrollView/SDCycleScrollView.h>

@interface GPAliPayInfoViewController ()<SDCycleScrollViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *accountLab;    // 收款账户
@property (weak, nonatomic) IBOutlet UILabel *accountNameLab; // 收款姓名
@property (weak, nonatomic) IBOutlet UIView *scrollImageView;  // 轮播图
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *userAccountTF;
@property (weak, nonatomic) IBOutlet UITextField *userMoneyTF;
@property (strong, nonatomic) GPInfoModel *infoModel;            // 本地数据
@property (strong, nonatomic) MBProgressHUD *progressHUD;
@property (strong, nonatomic) NSString *token;


@end

@implementation GPAliPayInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadSubView];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [self loadUserDefaultsData];
    
    // 未登陆状态返回首页界面
    if (![self.infoModel.islogin isEqualToString:@"1"]) {
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}

- (void)loadData{
    
    
}

- (void)loadSubView{
    
    self.title = @"支付宝转账";
    
    self.accountLab.text = self.bankCard;
    self.accountNameLab.text = self.accountName;
    
    self.automaticallyAdjustsScrollViewInsets = false;
    
    // 初始化加载框
    self.progressHUD = [[MBProgressHUD alloc]initWithFrame:CGRectMake(0, 0, kSize_width, kSize_height)];
    [self.view addSubview:_progressHUD];
    
    // 设置轮播图
    CGRect rect = CGRectMake(self.scrollImageView.bounds.origin.x, self.scrollImageView.bounds.origin.y, self.scrollImageView.bounds.size.width, self.scrollImageView.bounds.size.height);
    SDCycleScrollView *scrollView = [SDCycleScrollView cycleScrollViewWithFrame:rect
                                                                       delegate:self
                                                               placeholderImage:[UIImage imageNamed:@"ali_step_one.jpg"]];
    
    scrollView.localizationImageNamesGroup = @[@"ali_step_one.jpg",@"ali_step_two.jpg",@"ali_step_three.jpg"]; // 轮播图本地图片
    scrollView.scrollDirection             = UICollectionViewScrollDirectionHorizontal;; // 轮播图滚动方向（左右滚动）
    scrollView.autoScrollTimeInterval      = 5.0;                                        // 轮播图滚动时间间隔
    scrollView.contentMode = UIViewContentModeScaleAspectFit;                            // 设置图片模式
    [self.scrollImageView addSubview:scrollView];
    
    self.userNameTF.delegate = self;
    self.userAccountTF.delegate = self;
    self.userMoneyTF.delegate = self;
    
    // 添加空白区域点击事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(returnKeyboard)];
        [self.view addGestureRecognizer:tap];
}

#pragma mark - 加载本地数据
- (void)loadUserDefaultsData{
    
    NSMutableDictionary *infoDic = [UserDefaults searchData];
    
    self.infoModel               = [[GPInfoModel alloc]init];
    
    [self.infoModel setValuesForKeysWithDictionary:infoDic];
    
    self.token   = self.infoModel.token;
    
}

- (IBAction)makeSureButton:(UIButton *)sender {
    
    // 判断输入信息不为空
    if (self.userNameTF.text.length>0 && self.userAccountTF.text.length>0 && self.userMoneyTF.text.length>0) {
        
        [self.progressHUD showAnimated:YES];
        
        NSString *aliInfoLoc = [NSString stringWithFormat:@"%@pay/1/fillBankPayInfoSubmit",kBaseLocation];
        NSDictionary *paramDic = @{@"bankCardAccount":self.userAccountTF.text,@"accountName":self.userNameTF.text,@"amount":self.userMoneyTF.text,@"type":@"2",@"payId":self.bankID};
        
        // 请求登陆接口
        __weak typeof(self)weakSelf = self;
        [AFNetManager requestPOSTWithURLStr:aliInfoLoc paramDic:paramDic token:self.token finish:^(id responserObject) {
            
            NSLog(@"|ALIPAY-INFO-VC|success:%@",responserObject);
            
            [weakSelf.progressHUD hideAnimated:YES];
            
            GPRespondModel *respondModel = [GPRespondModel new];
            
            [respondModel setValuesForKeysWithDictionary:responserObject];
            
            if (respondModel.code.integerValue == 9200) {
                
                [weakSelf alertViewWithTitle:@"提醒" message:@"提交成功"];
                
            }else{
                
                [ToastView toastViewWithMessage:respondModel.msg timer:2.5];
            }
            
        } enError:^(NSError *error) {
            
            [weakSelf.progressHUD hideAnimated:YES];
            
            [ToastView toastViewWithMessage:@"数据连接出错，请稍后再试" timer:3.0];
            
        }];
        
    }else{
        
        [ToastView toastViewWithMessage:@"请补全信息" timer:3.0];
    }
}

#pragma mark - text field delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    // 修改return键显示内容
    textField.returnKeyType = UIReturnKeyDone;
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
    [self.userNameTF resignFirstResponder];
    [self.userAccountTF resignFirstResponder];
    [self.userMoneyTF resignFirstResponder];
}

#pragma mark - 提醒框
- (void)alertViewWithTitle:(NSString *)title message:(NSString *)message{
    
    UIAlertController *alert  = [UIAlertController alertControllerWithTitle:title
                                                                    message:message
                                                             preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction     *action = [UIAlertAction actionWithTitle:@"确定"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           
                                                           [self.navigationController popViewControllerAnimated:YES];
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
