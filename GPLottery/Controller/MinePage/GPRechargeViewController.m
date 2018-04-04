//
//  GPRechargeViewController.m
//  GPLottery
//
//  Created by cc on 2018/3/19.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPRechargeViewController.h"
#import "GPRechargeModel.h"
#import "GPRechargeListCell.h"

@interface GPRechargeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) GPInfoModel        *infoModel;       // 本地数据
@property (strong, nonatomic) NSString           *token;
@property (strong, nonatomic) MBProgressHUD      *progressHUD;
@property (strong, nonatomic) NSMutableArray     *rechargeArray;   // 充值数据

@end

@implementation GPRechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadData];
    [self loadSubView];
}

- (void)loadData{
    
    [self.progressHUD showAnimated:YES];
    
    [self loadUserDefaultsData];
    
    NSString *rechargeLoc = [NSString stringWithFormat:@"%@user/1/rechargeLog",kBaseLocation];
    
    // 请求登陆接口
    __weak typeof(self)weakSelf = self;
    [AFNetManager requestPOSTWithURLStr:rechargeLoc paramDic:nil token:self.token finish:^(id responserObject) {
        
        NSLog(@"|RECHARGE-VC|success:%@",responserObject);
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        NSString *code = [NSString stringWithFormat:@"%@",[responserObject objectForKey:@"code"]];
        NSString *msg = [responserObject objectForKey:@"msg"];
        NSArray *gameArr = [responserObject objectForKey:@"data"];
        
        if (code.integerValue == 9200) {
            
//            [ToastView toastViewWithMessage:msg timer:1.5];
            
            for (NSDictionary *rechargeDic in gameArr) {
                
                GPRechargeModel *rechargeModel = [GPRechargeModel new];
                
                [rechargeModel setValuesForKeysWithDictionary:rechargeDic];
                
                [self.rechargeArray addObject:rechargeModel];
            }
            
            [self.tableView reloadData];
        }else{
            
            [ToastView toastViewWithMessage:msg timer:2.5];
        }
        
    } enError:^(NSError *error) {
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        [ToastView toastViewWithMessage:@"数据连接出错，请稍后再试" timer:3.0];
        
    }];
}

- (void)loadSubView{
    
    self.title = @"充值记录";
    
    // table view 代理
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    
    // tableView样式
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled  = NO;
    
    // 初始化加载框
    self.progressHUD = [[MBProgressHUD alloc]initWithFrame:CGRectMake(0, 0, kSize_width, kSize_height)];
    [self.view addSubview:_progressHUD];
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"GPRechargeListCell" bundle:nil] forCellReuseIdentifier:@"rechargeListCell"];
    
}

#pragma mark - 加载本地数据
- (void)loadUserDefaultsData{
    
    NSMutableDictionary *infoDic = [UserDefaults searchData];
    
    self.infoModel               = [[GPInfoModel alloc]init];
    
    [self.infoModel setValuesForKeysWithDictionary:infoDic];
    
    self.token = self.infoModel.token;
    
}

#pragma mark - tableview data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.rechargeArray.count>0) {
        
        return self.rechargeArray.count;
    }else{
        
        return 3;
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 35;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GPRechargeListCell *rechargeListCell = [tableView dequeueReusableCellWithIdentifier:@"rechargeListCell" forIndexPath:indexPath];
    
    if (self.rechargeArray.count>0) {
        
        GPRechargeModel *rechargeModel = self.rechargeArray[indexPath.row];
        
        [rechargeListCell setDataWithModel:rechargeModel];
    }else{
        
        rechargeListCell.amountLab.text = @"123.12";
        rechargeListCell.timeLab.text   = @"2018-2-21";
        rechargeListCell.typeLab.text   = @"线下充值";
    }
    
    return rechargeListCell;
}

#pragma mark - 懒加载
- (NSMutableArray *)rechargeArray{
    
    if (!_rechargeArray) {
        
        self.rechargeArray = [NSMutableArray array];
    }
    return _rechargeArray;
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
