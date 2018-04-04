//
//  GPUserInfoViewController.m
//  GPLottery
//
//  Created by cc on 2018/3/17.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPUserInfoViewController.h"
#import "GPAgentUserInfoModel.h"
#import "GPAgentUserInfoCell.h"

static int yearNum  = 0;  // 选择年份
static int monthNum = 0;  // 选择月份
@interface GPUserInfoViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITableView *alertYearTableView;
@property (weak, nonatomic) IBOutlet UITableView *alertMounthTableView;
@property (weak, nonatomic) IBOutlet UILabel *yearLab;
@property (weak, nonatomic) IBOutlet UILabel *mounthLab;
@property (strong, nonatomic) NSMutableArray *yearDataSource;
@property (strong, nonatomic) NSMutableArray *monthDataSourcr;
@property (strong, nonatomic) NSMutableArray *dataSource;

@property (strong, nonatomic) GPInfoModel *infoModel;            // 本地数据
@property (strong, nonatomic) MBProgressHUD *progressHUD;
@property (strong, nonatomic) NSString *token;

@property (assign, nonatomic) NSInteger page; // 页码
@property (assign, nonatomic) NSInteger rows; // 加载条数

@end

@implementation GPUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"用户信息";
    
    [self loadSubView];
    [self loadData];
}

- (void)loadData{
    
    self.yearDataSource = @[@"2017",@"2018"].mutableCopy;
    self.monthDataSourcr = @[@"全部",@"1月",@"2月",@"3月",@"4月",@"5月",@"6月",@"7月",@"8月",@"9月",@"10月",@"11月",@"12月"].mutableCopy;
    
    [self loadNetDataWithPage:@"1" rows:@"10" year:self.yearLab.text month:@"0"];
}

- (void)loadSubView{
    
    // 初始化页码和条数
    self.page = 1;
    self.rows = 10;
    
    // 初始化加载框
    self.progressHUD = [[MBProgressHUD alloc]initWithFrame:CGRectMake(0, 0, kSize_width, kSize_height)];
    [self.view addSubview:_progressHUD];
    
    self.alertYearTableView.delegate   = self;
    self.alertYearTableView.dataSource = self;
    self.alertYearTableView.tag = 3001;
    [self.alertYearTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"yearCell"];
    
    self.alertMounthTableView.delegate   = self;
    self.alertMounthTableView.dataSource = self;
    self.alertMounthTableView.tag = 3002;
    [self.alertMounthTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"monthCell"];
    
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    self.tableView.tag = 3003;
    [self.tableView registerNib:[UINib nibWithNibName:@"GPAgentUserInfoCell" bundle:nil] forCellReuseIdentifier:@"agentUserInfoCell"];
    
    // 添加刷新
    __weak typeof(self)weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf.tableView.mj_footer resetNoMoreData];  // 消除尾部没有更多数据状态
        weakSelf.page = 1;
        [weakSelf loadNetDataWithPage:[NSString stringWithFormat:@"%ld",weakSelf.page] rows:[NSString stringWithFormat:@"%ld",weakSelf.rows] year:weakSelf.yearLab.text month:@"0"];
        
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        
        weakSelf.page++;
        [weakSelf loadNetDataWithPage:[NSString stringWithFormat:@"%ld",weakSelf.page] rows:[NSString stringWithFormat:@"%ld",weakSelf.rows] year:weakSelf.yearLab.text month:@"0"];
        if (weakSelf.page>5) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
    }];
}

#pragma mark - 加载本地数据
- (void)loadUserDefaultsData{
    
    NSMutableDictionary *infoDic = [UserDefaults searchData];
    
    self.infoModel               = [[GPInfoModel alloc]init];
    
    [self.infoModel setValuesForKeysWithDictionary:infoDic];
    
    self.token   = self.infoModel.token;
    
}

#pragma mark - 选择年份
- (IBAction)gameTypeTap:(UITapGestureRecognizer *)sender {
    
    monthNum++;
    
    self.alertMounthTableView.hidden = YES;
    
    yearNum++;
    
    if (yearNum%2==0) {
        
        self.alertYearTableView.hidden = YES;
    }else{
        
        self.alertYearTableView.hidden = NO;
    }
}

#pragma mark - 选择月份
- (IBAction)startTimeTap:(UITapGestureRecognizer *)sender {
    
    yearNum++;
    
    self.alertYearTableView.hidden = YES;
    
    monthNum++;
    
    if (monthNum%2==0) {
        
        self.alertMounthTableView.hidden = YES;
    }else{
        
        self.alertMounthTableView.hidden = NO;
    }
}

#pragma mark - tableview 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView.tag == 3001) {
        
        return self.yearDataSource.count;
        
    }else if (tableView.tag == 3002){
        
        return self.monthDataSourcr.count;
    }else{
        
        return self.dataSource.count;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag == 3001) {
        
        return 50;
        
    }else if (tableView.tag == 3002){
        
        return 50;
    }else{
        
        return 80;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag == 3001) {
        
        UITableViewCell *yearCell = [tableView dequeueReusableCellWithIdentifier:@"yearCell" forIndexPath:indexPath];
        
        yearCell.textLabel.text = self.yearDataSource[indexPath.row];
        
        return yearCell;
        
    }else if (tableView.tag == 3002){
        
        UITableViewCell *monthCell = [tableView dequeueReusableCellWithIdentifier:@"monthCell" forIndexPath:indexPath];
        
        monthCell.textLabel.text = self.monthDataSourcr[indexPath.row];
        
        return monthCell;
        
    }else{
        
        GPAgentUserInfoCell *agentUserInfoCell = [tableView dequeueReusableCellWithIdentifier:@"agentUserInfoCell" forIndexPath:indexPath];
        
        agentUserInfoCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        GPAgentUserInfoModel *agentUserInfoModel = self.dataSource[indexPath.row];
        
        [agentUserInfoCell setDataWithModel:agentUserInfoModel];
        
        return agentUserInfoCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
 
    if (tableView.tag == 3001) {  // 选择年份cell点击事件
        
        NSString *monthStr = [NSString stringWithFormat:@"%@",indexPath];
        
        self.yearLab.text = self.yearDataSource[indexPath.row];
        
        yearNum++;
        
        monthNum++;
        
        self.alertYearTableView.hidden = YES;
        
        [self loadNetDataWithPage:@"1" rows:@"10" year:self.yearLab.text month:monthStr];
        
        
    }else if (tableView.tag == 3002){  // 选择月份cell点击事件
        
        NSString *monthStr = [NSString stringWithFormat:@"%@",indexPath];
        
        self.mounthLab.text = self.monthDataSourcr[indexPath.row];
        
        monthNum++;
        
        yearNum++;
        
        self.alertMounthTableView.hidden = YES;
        
        [self loadNetDataWithPage:@"1" rows:@"10" year:self.yearLab.text month:monthStr];
    }else{  // 正常cell点击事件
        
        
    }
}

#pragma mark - 加载用户信息
- (void)loadNetDataWithPage:(NSString *)page rows:(NSString *)rows year:(NSString *)year month:(NSString *)month{
    
    [self.progressHUD showAnimated:YES];
    
    [self loadUserDefaultsData];
    
    NSString *userInfoLoc = [NSString stringWithFormat:@"%@agent/1/agentUserInfo",kBaseLocation];
    
    NSDictionary *paramDic = @{@"page":page,@"rows":rows,@"year":year,@"month":month};
    
    // 请求登陆接口
    __weak typeof(self)weakSelf = self;
    [AFNetManager requestPOSTWithURLStr:userInfoLoc paramDic:paramDic token:self.token finish:^(id responserObject) {
        
        NSLog(@"|AGENTUSERINFO-VC|success:%@",responserObject);
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        NSString *code = [responserObject objectForKey:@"code"];
        NSString *msg = [responserObject objectForKey:@"msg"];
        NSMutableArray *dataArr = [responserObject objectForKey:@"data"];
        
        if (code.integerValue == 9200) {
            
//            [ToastView toastViewWithMessage:msg timer:1.5];
            
            for (NSDictionary *dataDic in dataArr) {
                
                GPAgentUserInfoModel *agentInfoModel = [GPAgentUserInfoModel new];
                
                [agentInfoModel setValuesForKeysWithDictionary:dataDic];
                
                [weakSelf.dataSource addObject:agentInfoModel];
            }
            [self.tableView reloadData];
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

#pragma mark - 懒加载
- (NSMutableArray *)yearDataSource{
    
    if (!_yearDataSource) {
        
        self.yearDataSource = [NSMutableArray array];
    }
    return _yearDataSource;
}

- (NSMutableArray *)monthDataSourcr{
    
    if (!_monthDataSourcr) {
        
        self.monthDataSourcr = [NSMutableArray array];
    }
    return _monthDataSourcr;
}

- (NSMutableArray *)dataSource{
    
    if (!_dataSource) {
        
        self.dataSource = [NSMutableArray array];
    }
    return _dataSource;
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
