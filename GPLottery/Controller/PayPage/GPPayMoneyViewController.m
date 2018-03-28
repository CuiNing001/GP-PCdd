//
//  GPPayMoneyViewController.m
//  GPLottery
//
//  Created by cc on 2018/3/28.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPPayMoneyViewController.h"
#import "GPEnterPayModel.h"
#import "GPOrderPageViewController.h"

@interface GPPayMoneyViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *loginNameLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UIButton *refreshBtn;
@property (weak, nonatomic) IBOutlet UITextField *moneyTF;
@property (weak, nonatomic) IBOutlet UILabel *remindTextLab;

@property (strong, nonatomic) GPInfoModel *infoModel;            // 本地数据
@property (strong, nonatomic) MBProgressHUD *progressHUD;
@property (strong, nonatomic) NSString *token;


@end

@implementation GPPayMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self loadData];
    [self loadSubView];
}

#pragma mark - 加载数据
- (void)loadData{
    
    // 获取页面数据
    [self loadNetData];
}

#pragma mark - 加载子控件
- (void)loadSubView{
    
    self.title = self.titleStr;
    
    // 初始化加载框
    self.progressHUD = [[MBProgressHUD alloc]initWithFrame:CGRectMake(0, 0, kSize_width, kSize_height)];
    [self.view addSubview:_progressHUD];
    
    // textField代理
    self.moneyTF.delegate = self;
    
    // 添加空白区域点击事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(returnKeyboard)];
    [self.view addGestureRecognizer:tap];
}

#pragma mark - 加载网络数据
- (void)loadNetData{
    
    [self.progressHUD showAnimated:YES];
    
    [self loadUserDefaultsData];
    
    NSString *enterPayLoc = [NSString stringWithFormat:@"%@pay/1/enterPay",kBaseLocation];
    
    // 请求登陆接口
    __weak typeof(self)weakSelf = self;
    [AFNetManager requestPOSTWithURLStr:enterPayLoc paramDic:nil token:self.token finish:^(id responserObject) {
        
        NSLog(@"|PAYMONEY-VC|success:%@",responserObject);
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        GPRespondModel *respondModel = [GPRespondModel new];
        
        [respondModel setValuesForKeysWithDictionary:responserObject];
        
        if (respondModel.code.integerValue == 9200) {
            
            [ToastView toastViewWithMessage:respondModel.msg timer:1.5];
            
            GPEnterPayModel *enterPayModel = [GPEnterPayModel new];
            
            [enterPayModel setValuesForKeysWithDictionary:respondModel.data];
            
            [weakSelf setDataWithEnterPayModel:enterPayModel];
            
        }else{
            
            [ToastView toastViewWithMessage:respondModel.msg timer:2.5];
        }
        
    } enError:^(NSError *error) {
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        [ToastView toastViewWithMessage:@"数据连接出错，请稍后再试" timer:3.0];
        
    }];
}

#pragma mark - 页面数据赋值
- (void)setDataWithEnterPayModel:(GPEnterPayModel *)enterPayModel{
    
    self.loginNameLab.text = enterPayModel.loginName;
    self.moneyLab.text = enterPayModel.money;
    self.remindTextLab.text = enterPayModel.remindText;
}

#pragma mark - 下一步
- (IBAction)goToNextPageButton:(UIButton *)sender {
    
    [self loadOrderNetData];
    
    
    
    
}
- (void)loadOrderNetData{
    
    [self.progressHUD showAnimated:YES];
    
    [self loadUserDefaultsData];
    
    NSString *orderLoc = [NSString stringWithFormat:@"%@pay/1/payMoney",kBaseLocation];
    
    NSDictionary *paramDic = @{@"money":self.moneyTF.text,@"type":self.typeStr};
    
    // 请求登陆接口
    __weak typeof(self)weakSelf = self;
    [AFNetManager requestPOSTWithURLStr:orderLoc paramDic:paramDic token:self.token finish:^(id responserObject) {
        
        NSLog(@"|ORDERPAGE-VC|success:%@",responserObject);
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        GPRespondModel *respondModel = [GPRespondModel new];
        
        [respondModel setValuesForKeysWithDictionary:responserObject];
        
        if (respondModel.code.integerValue == 9200) {
            
            [ToastView toastViewWithMessage:respondModel.msg timer:1.5];
            
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary:respondModel.data];
     
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            GPOrderPageViewController *orderPageVC = [storyboard instantiateViewControllerWithIdentifier:@"orderPageVC"];
            
            if (weakSelf.moneyTF.text.length>0) {
                
                if (weakSelf.moneyTF.text.integerValue>9&&weakSelf.moneyTF.text.integerValue<2000) {
                    
                    orderPageVC.orderID = [dic objectForKey:@"orderId"];
                    orderPageVC.titleStr = weakSelf.titleStr;
                    orderPageVC.orderMoney = weakSelf.moneyTF.text;
                    orderPageVC.payUrl = [dic objectForKey:@"payUrl"];
                    orderPageVC.orderType = weakSelf.typeStr;
                    
                    [weakSelf.navigationController pushViewController:orderPageVC animated:YES];
                }else{
                    
                    [ToastView toastViewWithMessage:@"请输入规定金额" timer:3.0];
                }
            }else{
                
                [ToastView toastViewWithMessage:@"请输入金额" timer:3.0];
            }
            
        }else{
            
            [ToastView toastViewWithMessage:respondModel.msg timer:2.5];
        }
        
    } enError:^(NSError *error) {
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        [ToastView toastViewWithMessage:@"数据连接出错，请稍后再试" timer:3.0];
        
    }];
    
}

#pragma mark - 刷新
- (IBAction)refreshButton:(UIButton *)sender {
    
    // 刷新页面数据
    [self loadNetData];
}

#pragma mark - 加载本地数据
- (void)loadUserDefaultsData{
    
    NSMutableDictionary *infoDic = [UserDefaults searchData];
    
    self.infoModel               = [[GPInfoModel alloc]init];
    
    [self.infoModel setValuesForKeysWithDictionary:infoDic];
    
    self.token   = self.infoModel.token;
    
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

#pragma mark - 回收键盘
- (void)returnKeyboard{
    
    // 点击空白区域回收键盘
    [self.moneyTF resignFirstResponder];
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
