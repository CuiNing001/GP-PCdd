//
//  GPTrendViewController.m
//  GPLottery
//
//  Created by cc on 2018/4/3.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPTrendViewController.h"
#import "GPTrendModel.h"
#import "GPTrendCell.h"

@interface GPTrendViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) GPInfoModel *infoModel;            // 本地数据
@property (strong, nonatomic) MBProgressHUD *progressHUD;
@property (strong, nonatomic) NSString *token;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray     *trendArray;
@property (assign, nonatomic) NSInteger page; // 页码
@property (assign, nonatomic) NSInteger rows; // 加载条数

@end

@implementation GPTrendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadData];
    [self loadSubView];
}

#pragma mark - 加载数据
- (void)loadData{
    
    self.title = @"走势图";
    
    // 加载第一页走势图
    [self loadNetDataWithPage:@"1" rows:@"20"];
}

#pragma mark - 加载子控件
- (void)loadSubView{
    
    self.automaticallyAdjustsScrollViewInsets = false;
    
    // 初始化页码和条数
    self.page = 1;
    self.rows = 10;
    
    // 初始化加载框
    self.progressHUD = [[MBProgressHUD alloc]initWithFrame:CGRectMake(0, 0, kSize_width, kSize_height)];
    [self.view addSubview:_progressHUD];
    
    // table view
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"GPTrendCell" bundle:nil] forCellReuseIdentifier:@"trendCell"];
    
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

- (void)loadNetDataWithPage:(NSString *)page rows:(NSString *)rows{
    
    [self.progressHUD showAnimated:YES];
    
    [self loadUserDefaultsData];
    
    NSString *trendLoc = [NSString stringWithFormat:@"%@/index/1/myTrendDiagram",kPlayBaseLocation];
    
    NSDictionary *paramDic = @{@"roomId":self.roomId,@"page":page,@"rows":rows};
    
    // 请求登陆接口
    __weak typeof(self)weakSelf = self;
    [AFNetManager requestPOSTWithURLStr:trendLoc paramDic:paramDic token:self.token finish:^(id responserObject) {
        
        NSLog(@"|TREND-VC|success:%@",responserObject);
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        NSString *code = [NSString stringWithFormat:@"%@",[responserObject objectForKey:@"code"]];
        NSString *msg = [responserObject objectForKey:@"msg"];
        NSArray *trendArr = [responserObject objectForKey:@"data"];
        
        if (code.integerValue == 9200) {
            
            if (page.integerValue == 1) {
                
                // 上拉刷新时清空数据
                [weakSelf.trendArray removeAllObjects];
            }
            
//            [ToastView toastViewWithMessage:msg timer:1.5];
            
            for (NSDictionary *dataArr in trendArr) {
                
                GPTrendModel *trendModel = [GPTrendModel new];
                
                [trendModel setValuesForKeysWithDictionary:dataArr];
                
                [weakSelf.trendArray addObject:trendModel];
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
    
    // 设置登陆状态
    self.token   = self.infoModel.token;

}

#pragma mark - tableview 代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.trendArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GPTrendCell *trendCell = [tableView dequeueReusableCellWithIdentifier:@"trendCell" forIndexPath:indexPath];
    
    trendCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    GPTrendModel *trendModel = self.trendArray[indexPath.row];
    
    if (indexPath.row%2==0) {
        
        trendCell.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    }else{
        
        trendCell.backgroundColor = [UIColor whiteColor];
    }
    
    [trendCell setDataWithModel:trendModel];
    
    return trendCell;
}

#pragma mark - 懒加载
- (NSMutableArray *)trendArray{
    
    if (!_trendArray) {
        
        self.trendArray = [NSMutableArray array];
    }
    return _trendArray;
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
