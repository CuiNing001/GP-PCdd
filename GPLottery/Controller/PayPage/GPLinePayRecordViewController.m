//
//  GPLinePayRecordViewController.m
//  GPLottery
//
//  Created by cc on 2018/3/31.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPLinePayRecordViewController.h"
#import "GPLinePayRecordModel.h"
#import "GPLinePayRecoedCell.h"

@interface GPLinePayRecordViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) GPInfoModel *infoModel;            // 本地数据
@property (strong, nonatomic) MBProgressHUD *progressHUD;
@property (strong, nonatomic) NSString *token;
@property (assign, nonatomic) NSInteger page; // 页码
@property (assign, nonatomic) NSInteger rows; // 加载条数
@property (strong, nonatomic) NSMutableArray *datSourceArray;

@end

@implementation GPLinePayRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"转账记录";
    
    [self loadData];
    [self loadSubView];
}

- (void)loadData{
    
    [self loadNetDataWithPage:@"1" rows:@"10"];
}

- (void)loadSubView{
    
    // 初始化页码和条数
    self.page = 1;
    self.rows = 10;
    
    // 初始化加载框
    self.progressHUD = [[MBProgressHUD alloc]initWithFrame:CGRectMake(0, 0, kSize_width, kSize_height)];
    [self.view addSubview:_progressHUD];
    
    // table view 代理
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    
    // tableView样式
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"GPLinePayRecoedCell" bundle:nil] forCellReuseIdentifier:@"linePayRecordCell"];
    
    // 添加刷新
    __weak typeof(self)weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                
        [weakSelf.tableView.mj_footer resetNoMoreData];  // 消除尾部没有更多数据状态
        weakSelf.page = 1;
        [weakSelf loadNetDataWithPage:[NSString stringWithFormat:@"%ld",weakSelf.page] rows:[NSString stringWithFormat:@"%ld",weakSelf.rows]];
        
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        
        weakSelf.page++;
        [weakSelf loadNetDataWithPage:[NSString stringWithFormat:@"%ld",weakSelf.page] rows:[NSString stringWithFormat:@"%ld",weakSelf.rows]];
        if (weakSelf.page>5) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
    }];
}

#pragma mark - 加载数据
- (void)loadNetDataWithPage:(NSString *)page rows:(NSString *)rows{
    
    [self.progressHUD showAnimated:YES];
    
    [self loadUserDefaultsData];
    
    NSString *luckyListLoc = [NSString stringWithFormat:@"%@lineLowerRecharge/1/myLineLowerRecharge",kBaseLocation];
    
    NSDictionary *paramDic = @{@"page":page,@"rows":rows};
    
    // 请求登陆接口
    __weak typeof(self)weakSelf = self;
    [AFNetManager requestPOSTWithURLStr:luckyListLoc paramDic:paramDic token:self.token finish:^(id responserObject) {
        
        NSLog(@"|LINE-RECORD-VC|success:%@",responserObject);
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        NSString *code = [NSString stringWithFormat:@"%@",[responserObject objectForKey:@"code"]];
        NSString *msg = [responserObject objectForKey:@"msg"];
        NSMutableArray *recordArr = [responserObject objectForKey:@"data"];
        
        if (code.integerValue == 9200) {
            
            [ToastView toastViewWithMessage:msg timer:1.5];
            
            for (NSDictionary *dataDic in recordArr) {
                
                GPLinePayRecordModel *recordModel = [GPLinePayRecordModel new];
                
                [recordModel setValuesForKeysWithDictionary:dataDic];
                
                [weakSelf.datSourceArray addObject:recordModel];
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

#pragma mark - tableview代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.datSourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 320;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GPLinePayRecoedCell *linePayRecordCell = [tableView dequeueReusableCellWithIdentifier:@"linePayRecordCell" forIndexPath:indexPath];
    
    GPLinePayRecordModel *model = self.datSourceArray[indexPath.row];
    
    [linePayRecordCell setDataWithModel:model];
    
    return linePayRecordCell;
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
