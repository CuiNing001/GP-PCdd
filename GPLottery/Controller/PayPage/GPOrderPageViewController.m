//
//  GPOrderPageViewController.m
//  GPLottery
//
//  Created by cc on 2018/3/28.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPOrderPageViewController.h"

@interface GPOrderPageViewController ()

@property (weak, nonatomic) IBOutlet UILabel *orderTypeLab;
@property (weak, nonatomic) IBOutlet UILabel *orderIdLab;
@property (weak, nonatomic) IBOutlet UILabel *orderMonerLab;

@property (strong, nonatomic) GPInfoModel *infoModel;            // 本地数据
@property (strong, nonatomic) MBProgressHUD *progressHUD;
@property (strong, nonatomic) NSString *token;



@end

@implementation GPOrderPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadSubView];
 
    NSLog(@"^^^^^^^^url^^^^^^^%@",self.payUrl);
}



- (void)loadSubView{
    
    self.automaticallyAdjustsScrollViewInsets = false;
    
    self.title = self.titleStr;
    
    self.orderTypeLab.text = [NSString stringWithFormat:@"%@信息",self.titleStr];
    self.orderMonerLab.text = [NSString stringWithFormat:@"%@元",self.orderMoney];
    self.orderIdLab.text = self.orderID;
    
    // 初始化加载框
    self.progressHUD = [[MBProgressHUD alloc]initWithFrame:CGRectMake(0, 0, kSize_width, kSize_height)];
    [self.view addSubview:_progressHUD];
    
}

- (IBAction)makeSureOrderButton:(UIButton *)sender {
    
    // 跳转网页支付
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:self.payUrl] options:nil completionHandler:nil];
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
