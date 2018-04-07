//
//  GPNormalPayViewController.m
//  GPLottery
//
//  Created by cc on 2018/3/31.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPNormalPayViewController.h"
#import "GPNormalPayModel.h"
#import "GPNormalPayCell.h"
#import "GPBankInfomationViewController.h"

@interface GPNormalPayViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) GPInfoModel *infoModel;            // 本地数据
@property (strong, nonatomic) MBProgressHUD *progressHUD;
@property (strong, nonatomic) NSString *token;
@property (strong, nonatomic) NSMutableArray *datSourceArray;

@end

@implementation GPNormalPayViewController

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

- (void)loadData{
    
    self.title = @"选择银行账号";
    
    [self loadNetDat];
}

- (void)loadSubView{
    
    self.automaticallyAdjustsScrollViewInsets = false;
    
    // 初始化加载框
    self.progressHUD = [[MBProgressHUD alloc]initWithFrame:CGRectMake(0, 0, kSize_width, kSize_height)];
    [self.view addSubview:_progressHUD];
    
    // table view 代理
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    
    // tableView样式
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"GPNormalPayCell" bundle:nil] forCellReuseIdentifier:@"normalPayCell"];
    
}

- (void)loadNetDat{
    
    [self.progressHUD showAnimated:YES];
    
    [self loadUserDefaultsData];
    
    NSString *normalPayLoc = [NSString stringWithFormat:@"%@pay/1/enterBankPay",kBaseLocation];
    
    // 请求登陆接口
    __weak typeof(self)weakSelf = self;
    [AFNetManager requestPOSTWithURLStr:normalPayLoc paramDic:nil token:self.token finish:^(id responserObject) {
        
        NSLog(@"|NORMAL-PAY-VC|success:%@",responserObject);
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        GPRespondModel *respondModel = [GPRespondModel new];
        
        [respondModel setValuesForKeysWithDictionary:responserObject];
        
        if (respondModel.code.integerValue == 9200) {
            
//            [ToastView toastViewWithMessage:respondModel.msg timer:1.5];
            
            GPNormalPayModel *normalParModel = [GPNormalPayModel new];
            
            [normalParModel setValuesForKeysWithDictionary:respondModel.data];
            
            [weakSelf.datSourceArray addObject:normalParModel];
            
            [weakSelf.tableView reloadData];
            
        }else{
            
            [ToastView toastViewWithMessage:respondModel.msg timer:2.5];
        }
        
    } enError:^(NSError *error) {
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        [ToastView toastViewWithMessage:@"数据连接出错，请稍后再试" timer:3.0];
        
    }];
}


#pragma mark - tableview代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.datSourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 110;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GPNormalPayCell *normalPayCell = [tableView dequeueReusableCellWithIdentifier:@"normalPayCell" forIndexPath:indexPath];
    
    GPNormalPayModel *model = self.datSourceArray[indexPath.row];
    
    [normalPayCell setDataWithModel:model];
    
    return normalPayCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GPNormalPayModel *model = self.datSourceArray[indexPath.row];
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    GPBankInfomationViewController *bankInfoVC = [storyboard instantiateViewControllerWithIdentifier:@"bankInfomationVC"];
    
    bankInfoVC.accountName = model.accountName;
    bankInfoVC.bankName = model.bankName;
    bankInfoVC.mesg = model.mesg;
    bankInfoVC.bankCard = model.bankCard;
    
    [self.navigationController pushViewController:bankInfoVC animated:YES];
}

#pragma mark - 加载本地数据
- (void)loadUserDefaultsData{
    
    NSMutableDictionary *infoDic = [UserDefaults searchData];
    
    self.infoModel               = [[GPInfoModel alloc]init];
    
    [self.infoModel setValuesForKeysWithDictionary:infoDic];
    
    self.token   = self.infoModel.token;
    
}

#pragma mark - 懒加载
- (NSMutableArray *)datSourceArray{
    
    if (!_datSourceArray) {
        
        self.datSourceArray = [NSMutableArray array];
    }
    return _datSourceArray;
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
