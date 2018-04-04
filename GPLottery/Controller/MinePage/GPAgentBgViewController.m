//
//  GPAgentBgViewController.m
//  GPLottery
//
//  Created by cc on 2018/3/15.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPAgentBgViewController.h"
#import "GPProtocolViewController.h"

@interface GPAgentBgViewController ()

@property (weak, nonatomic) IBOutlet UILabel *totalNumberLab;  // 会员总数
@property (weak, nonatomic) IBOutlet UILabel *addNewNumberLab; // 今日新增

@property (strong, nonatomic) GPInfoModel *infoModel;            // 本地数据
@property (strong, nonatomic) MBProgressHUD *progressHUD;
@property (strong, nonatomic) NSString *token;
@property (strong, nonatomic) NSString *agreementUrl;    // 代理协议

@end

@implementation GPAgentBgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadData];
    [self loadSubView];
}

#pragma mark - 加载数据
- (void)loadData{
    
    self.title = @"代理后台";
    
    [self loadNetData];
    
}

#pragma mark - 加载子控件
- (void)loadSubView{
    
    // 初始化加载框
    self.progressHUD = [[MBProgressHUD alloc]initWithFrame:CGRectMake(0, 0, kSize_width, kSize_height)];
    [self.view addSubview:_progressHUD];
}

#pragma mark - 加载网络数据
- (void)loadNetData{
    
    [self.progressHUD showAnimated:YES];
    
    [self loadUserDefaultsData];
    
    NSString *agentBgLoc = [NSString stringWithFormat:@"%@agent/1/enterAgent",kBaseLocation];
    
    // 请求登陆接口
    __weak typeof(self)weakSelf = self;
    [AFNetManager requestPOSTWithURLStr:agentBgLoc paramDic:nil token:self.token finish:^(id responserObject) {
        
        NSLog(@"|AGENTBG-VC|success:%@",responserObject);
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        GPRespondModel *respondModel = [GPRespondModel new];
        
        [respondModel setValuesForKeysWithDictionary:responserObject];
        
        if (respondModel.code.integerValue == 9200) {
            
//            [ToastView toastViewWithMessage:respondModel.msg timer:1.5];
            
            // 基本数据赋值
            weakSelf.totalNumberLab.text = [NSString stringWithFormat:@"%@",[respondModel.data objectForKey:@"memberUserSum"]];
            weakSelf.addNewNumberLab.text = [NSString stringWithFormat:@"%@",[respondModel.data objectForKey:@"toDayMemberNumber"]];
            weakSelf.agreementUrl = [NSString stringWithFormat:@"%@",[respondModel.data objectForKey:@"agreementUrl"]];
            
        }else{
            
            [ToastView toastViewWithMessage:respondModel.msg timer:2.5];
        }
        
    } enError:^(NSError *error) {
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        [ToastView toastViewWithMessage:@"数据连接出错，请稍后再试" timer:3.0];
        
    }];
}

#pragma mark - 收益分析
- (IBAction)analysisButton:(UIButton *)sender {
    
    
}

#pragma mark - 用户信息
- (IBAction)userInfoButton:(UIButton *)sender {
    
    
}

#pragma mark - 代理协议
- (IBAction)protocolButton:(UIButton *)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    GPProtocolViewController *protocolVC = [storyboard instantiateViewControllerWithIdentifier:@"protocolVC"];
    protocolVC.agreementUrl = self.agreementUrl;
    [self.navigationController pushViewController:protocolVC animated:YES];
}

#pragma mark - 加载本地数据
- (void)loadUserDefaultsData{
    
    NSMutableDictionary *infoDic = [UserDefaults searchData];
    
    self.infoModel               = [[GPInfoModel alloc]init];
    
    [self.infoModel setValuesForKeysWithDictionary:infoDic];
    
    self.token   = self.infoModel.token;
    
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
