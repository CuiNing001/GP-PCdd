//
//  GPWalletViewController.m
//  GPLottery
//
//  Created by cc on 2018/3/14.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPWalletViewController.h"
#import "GPMineListCell.h"
#import "GPWalletModel.h"

@interface GPWalletViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel     *myMoneyLab;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) MBProgressHUD      *progressHUD;
@property (strong, nonatomic) NSMutableArray     *listImageArray;  // 图标数据
@property (strong, nonatomic) NSMutableArray     *listTextArray;   // 文字数据
@property (strong, nonatomic) NSString           *walletLoc;       // 钱包数据地址
@property (strong, nonatomic) GPInfoModel        *infoModel;       // 本地数据
@property (strong, nonatomic) NSString           *token;

@end

@implementation GPWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的钱包";
    
    [self loadSubView];
    [self loadData];
}

- (void)loadData{
    
    // 初始化list数据
    self.listImageArray = @[@"setting_card",@"setting_password_change",@"setting_withdraw_password",@"setting_clean",@"setting_phone"].mutableCopy;
    self.listTextArray  = @[@"我的银行卡",@"充值",@"提现",@"充值记录",@"提现记录"].mutableCopy;
    
    // 请求数据
    [self loadNetData];
}

- (void)loadSubView{
    
    // table view 代理
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    
    // tableView样式
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled  = NO;
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"GPMineListCell" bundle:nil] forCellReuseIdentifier:@"mineListCell"];
    
    // 初始化加载框
    self.progressHUD = [[MBProgressHUD alloc]initWithFrame:CGRectMake(0, 0, kSize_width, kSize_height)];
    [self.view addSubview:_progressHUD];
    
}

#pragma mark - 请求数据
- (void)loadNetData{
    
    [self.progressHUD showAnimated:YES];
    
    [self loadUserDefaultsData];
    
    self.walletLoc = [NSString stringWithFormat:@"%@user/1/money",kBaseLocation];
    
    // 请求登陆接口
    __weak typeof(self)weakSelf = self;
    [AFNetManager requestPOSTWithURLStr:self.walletLoc paramDic:nil token:self.token finish:^(id responserObject) {
        
        NSLog(@"|WALLET-VC|success:%@",responserObject);
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        GPRespondModel *respondModel = [GPRespondModel new];
        
        [respondModel setValuesForKeysWithDictionary:responserObject];
        
        if (respondModel.code.integerValue == 9200) {
            
            [ToastView toastViewWithMessage:respondModel.msg timer:1.5];
            
            GPWalletModel *walletModel = [GPWalletModel new];
            
            [walletModel setValuesForKeysWithDictionary:respondModel.data];
            
            // 设置钱包金额
            self.myMoneyLab.text = walletModel.moneyNum;
            
        }else{
            
            [ToastView toastViewWithMessage:respondModel.msg timer:2.5];
        }
        
    } enError:^(NSError *error) {
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        [ToastView toastViewWithMessage:@"数据连接出错，请稍后再试" timer:3.0];
        
    }];
    
}
#pragma mark - 加载本地数据
- (void)loadUserDefaultsData{
    
    NSMutableDictionary *infoDic = [UserDefaults searchData];
    
    self.infoModel               = [[GPInfoModel alloc]init];
    
    [self.infoModel setValuesForKeysWithDictionary:infoDic];
    
    self.token = self.infoModel.token;
    
}


#pragma mark - tableView dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.listImageArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GPMineListCell *mineListCell = [tableView dequeueReusableCellWithIdentifier:@"mineListCell" forIndexPath:indexPath];
    
    [mineListCell setDataWithImage:self.listImageArray[indexPath.row] text:self.listTextArray[indexPath.row] money:nil];
    
    return mineListCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 点击后取消cell的点击状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
}

#pragma mark - 懒加载
- (NSMutableArray *)listImageArray{
    
    if (!_listImageArray) {
        
        self.listImageArray = [NSMutableArray array];
    }
    
    return _listImageArray;
}

- (NSMutableArray *)listTextArray{
    
    if (!_listTextArray) {
        
        self.listTextArray = [NSMutableArray array];
    }
    
    return _listTextArray;
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
