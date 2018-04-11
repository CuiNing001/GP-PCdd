//
//  GPAnalysisViewController.m
//  GPLottery
//
//  Created by cc on 2018/3/17.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPAnalysisViewController.h"
#import "GPAgentBenefitAnalysisModel.h"
#import "GPAgentBenefitAnalysisCell.h"

@interface GPAnalysisViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *settlementBtn;   // 已结算
@property (weak, nonatomic) IBOutlet UIButton *noSettlementBtn; // 未结算
@property (strong, nonatomic) GPInfoModel        *infoModel;       // 本地数据
@property (strong, nonatomic) NSString           *token;
@property (strong, nonatomic) MBProgressHUD      *progressHUD;
@property (assign, nonatomic) NSInteger page; // 页码
@property (assign, nonatomic) NSInteger rows; // 加载条数
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSMutableArray *dataSourceArray; // 收益数据

@end

@implementation GPAnalysisViewController

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
    
    // 初始化结算状态
    self.status = @"1";
    
    [self loadNetDataWithPage:@"1" rows:@"10" status:self.status];
}

- (void)loadSubView{
    
    // 初始化页码和条数
    self.page = 1;
    self.rows = 10;
    
    self.title = @"收益分析";
    
    // table view 代理
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    
    // tableView样式
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"GPAgentBenefitAnalysisCell" bundle:nil] forCellReuseIdentifier:@"agentBenefitAnalysisCell"];
    
    // 初始化加载框
    self.progressHUD = [[MBProgressHUD alloc]initWithFrame:CGRectMake(0, 0, kSize_width, kSize_height)];
    [self.view addSubview:_progressHUD];
    
    // 添加刷新
    __weak typeof(self)weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf.tableView.mj_footer resetNoMoreData];  // 消除尾部没有更多数据状态
        weakSelf.page = 1;
        [weakSelf loadNetDataWithPage:[NSString stringWithFormat:@"%ld",weakSelf.page] rows:[NSString stringWithFormat:@"%ld",weakSelf.rows] status:self.status];
        
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        
        weakSelf.page++;
        [weakSelf loadNetDataWithPage:[NSString stringWithFormat:@"%ld",weakSelf.page] rows:[NSString stringWithFormat:@"%ld",weakSelf.rows] status:self.status];
        if (weakSelf.page>5) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
    }];
}

#pragma mark - 加载数据
- (void)loadNetDataWithPage:(NSString *)page rows:(NSString *)rows status:(NSString *)status{
    
    [self.progressHUD showAnimated:YES];
    
    [self loadUserDefaultsData];
    
    NSString *profitLoc = [NSString stringWithFormat:@"%@agent/1/agentProfitAnalysis",kBaseLocation];
    
    NSDictionary *paramDic = @{@"page":page,@"rows":rows,@"status":status};
    
    // 请求登陆接口
    __weak typeof(self)weakSelf = self;
    [AFNetManager requestPOSTWithURLStr:profitLoc paramDic:paramDic token:self.token finish:^(id responserObject) {
        
        NSLog(@"|LOGIN-VC|success:%@",responserObject);
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        NSString *code = [responserObject objectForKey:@"code"];
        NSString *msg = [responserObject objectForKey:@"msg"];
        NSMutableArray *dataArr = [responserObject objectForKey:@"data"];
        
        if (code.integerValue == 9200) {
            
            if (page.integerValue == 1) {
                
                // 上拉刷新时清空数据
                [weakSelf.dataSourceArray removeAllObjects];
            }
            
//            [ToastView toastViewWithMessage:msg timer:1.5];
            
            for (NSDictionary *dataDic in dataArr) {
                
                GPAgentBenefitAnalysisModel *model = [GPAgentBenefitAnalysisModel new];
                
                [model setValuesForKeysWithDictionary:dataDic];
                
                [weakSelf.dataSourceArray addObject:model];
            }
            [weakSelf.tableView reloadData];
            
        }else{
            
            [ToastView toastViewWithMessage:msg timer:2.5];
        }
        
    } enError:^(NSError *error) {
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        [ToastView toastViewWithMessage:@"数据连接出错，请稍后再试" timer:3.0];
        
    }];
    
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

#pragma mark - 加载本地数据
- (void)loadUserDefaultsData{
    
    NSMutableDictionary *infoDic = [UserDefaults searchData];
    
    self.infoModel               = [[GPInfoModel alloc]init];
    
    [self.infoModel setValuesForKeysWithDictionary:infoDic];
    
    self.token = self.infoModel.token;
    
}

#pragma mark - 已结算
- (IBAction)hasBeenButton:(UIButton *)sender {
    
    [self.dataSourceArray removeAllObjects];
    self.status = @"1";
    // 修改点击状态
    self.settlementBtn.backgroundColor    = [UIColor colorWithRed:223/255.0 green:229/255.0 blue:233/255.0 alpha:1];
    self.noSettlementBtn.backgroundColor = [UIColor colorWithRed:193/255.0 green:193/255.0 blue:193/255.0 alpha:1];
    [self.settlementBtn setTitleColor:[UIColor colorWithRed:56/255.0 green:135/255.0 blue:234/255.0 alpha:1] forState:UIControlStateNormal];
    [self.noSettlementBtn setTitleColor:[UIColor colorWithRed:69/255.0 green:69/255.0 blue:69/255.0 alpha:1] forState:UIControlStateNormal];
    
    [self loadNetDataWithPage:@"1" rows:@"10" status:self.status];
}

#pragma mark - 未结算
- (IBAction)noSettlementButton:(UIButton *)sender {
    
    [self.dataSourceArray removeAllObjects];
    self.status = @"0";
    // 修改点击状态
    self.noSettlementBtn.backgroundColor    = [UIColor colorWithRed:223/255.0 green:229/255.0 blue:233/255.0 alpha:1];
    self.settlementBtn.backgroundColor = [UIColor colorWithRed:193/255.0 green:193/255.0 blue:193/255.0 alpha:1];
    [self.noSettlementBtn setTitleColor:[UIColor colorWithRed:56/255.0 green:135/255.0 blue:234/255.0 alpha:1] forState:UIControlStateNormal];
    [self.settlementBtn setTitleColor:[UIColor colorWithRed:69/255.0 green:69/255.0 blue:69/255.0 alpha:1] forState:UIControlStateNormal];
    
    [self loadNetDataWithPage:@"1" rows:@"10" status:self.status];
}

#pragma mark - tableview代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GPAgentBenefitAnalysisCell *agentBenefitAnalysisCell = [tableView dequeueReusableCellWithIdentifier:@"agentBenefitAnalysisCell" forIndexPath:indexPath];
    
    GPAgentBenefitAnalysisModel *model = self.dataSourceArray[indexPath.row];
    
    [agentBenefitAnalysisCell setDataWithModel:model];
    
    return agentBenefitAnalysisCell;
}

#pragma mark - 懒加载
- (NSMutableArray *)dataSourceArray{
    
    if (!_dataSourceArray) {
        
        self.dataSourceArray = [NSMutableArray array];
    }
    return _dataSourceArray;
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
