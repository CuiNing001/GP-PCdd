//
//  GPNormalAliPayViewController.m
//  GPLottery
//
//  Created by cc on 2018/4/9.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPNormalAliPayViewController.h"
#import "GPNormalAliPayCell.h"
#import "GPNormalPayModel.h"
#import "GPAliPayInfoViewController.h"

@interface GPNormalAliPayViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) GPInfoModel *infoModel;            // 本地数据
@property (strong, nonatomic) MBProgressHUD *progressHUD;
@property (strong, nonatomic) NSString *token;
@property (strong, nonatomic) NSMutableArray *datSourceArray;

@end

@implementation GPNormalAliPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    normalAliPayVC
    
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
    
    [self loadNetDat];
}

- (void)loadNetDat{
    
    [self.progressHUD showAnimated:YES];
    
    [self loadUserDefaultsData];
    
    NSString *normalPayLoc = [NSString stringWithFormat:@"%@pay/1/enterBankPay",kBaseLocation];
    
    NSDictionary *paramDic = @{@"type":@"2"};
    
    // 请求登陆接口
    __weak typeof(self)weakSelf = self;
    [AFNetManager requestPOSTWithURLStr:normalPayLoc paramDic:paramDic token:self.token finish:^(id responserObject) {
        
        NSLog(@"|NORMAL-AliPay-VC|success:%@",responserObject);
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        NSString *code = [NSString stringWithFormat:@"%@",[responserObject objectForKey:@"code"]];
        NSString *msg = [responserObject objectForKey:@"msg"];
        
        if (code.integerValue == 9200) {
            
            NSArray *dataArray = [responserObject objectForKey:@"data"];
            
            for (NSDictionary *dataDic in dataArray) {
                
                GPNormalPayModel *normalParModel = [GPNormalPayModel new];
                
                [normalParModel setValuesForKeysWithDictionary:dataDic];
                
                [weakSelf.datSourceArray addObject:normalParModel];
            }
            
            [weakSelf.tableView reloadData];
            
        }else{
            
            [ToastView toastViewWithMessage:msg timer:2.5];
        }
        
    } enError:^(NSError *error) {
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        [ToastView toastViewWithMessage:@"数据连接出错，请稍后再试" timer:3.0];
        
    }];
}

- (void)loadSubView{
    
    self.title = @"选择银行卡";
    
    self.automaticallyAdjustsScrollViewInsets = false;
    
    // 初始化加载框
    self.progressHUD = [[MBProgressHUD alloc]initWithFrame:CGRectMake(0, 0, kSize_width, kSize_height)];
    [self.view addSubview:_progressHUD];
    
    // table view 代理
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    
    // tableView样式
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"GPNormalAliPayCell" bundle:nil] forCellReuseIdentifier:@"normalAliPayCell"];
}

#pragma mark - 加载本地数据
- (void)loadUserDefaultsData{
    
    NSMutableDictionary *infoDic = [UserDefaults searchData];
    
    self.infoModel               = [[GPInfoModel alloc]init];
    
    [self.infoModel setValuesForKeysWithDictionary:infoDic];
    
    self.token   = self.infoModel.token;
    
}

#pragma mark - tableview代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.datSourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GPNormalAliPayCell *normalAliPayCell = [tableView dequeueReusableCellWithIdentifier:@"normalAliPayCell" forIndexPath:indexPath];
    
    GPNormalPayModel *model = self.datSourceArray[indexPath.row];
    
    [normalAliPayCell setDataWithModel:model];
    
    return normalAliPayCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GPNormalPayModel *model = self.datSourceArray[indexPath.row];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    GPAliPayInfoViewController *aliPayInfoVC = [storyboard instantiateViewControllerWithIdentifier:@"aliPayInfoVC"];
    
    aliPayInfoVC.accountName = model.accountName;
    aliPayInfoVC.bankCard = model.bankCard;
    aliPayInfoVC.bankID = model.id;
    
    [self.navigationController pushViewController:aliPayInfoVC animated:YES];
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
