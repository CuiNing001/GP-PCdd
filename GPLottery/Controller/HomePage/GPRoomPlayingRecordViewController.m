//
//  GPRoomPlayingRecordViewController.m
//  GPLottery
//
//  Created by cc on 2018/4/9.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPRoomPlayingRecordViewController.h"
#import "GPBetDetailModel.h"
#import "GPBetDetailCell.h"

@interface GPRoomPlayingRecordViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) GPInfoModel        *infoModel;            // 本地数据
@property (strong, nonatomic) MBProgressHUD  *progressHUD;
@property (strong, nonatomic) NSString *token;
@property (assign, nonatomic) NSInteger page; // 页码
@property (assign, nonatomic) NSInteger rows; // 加载条数
@property (strong, nonatomic) NSMutableArray *dataArray;     // 玩法数据

@end

@implementation GPRoomPlayingRecordViewController

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

- (void)loadSubView{
    
    self.title = @"游戏记录";
    
    // 初始化页码和条数
    self.page = 1;
    self.rows = 10;
    
    self.automaticallyAdjustsScrollViewInsets = false;
    
    // tableView代理
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // tableView样式
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"GPBetDetailCell" bundle:nil] forCellReuseIdentifier:@"betDetailCell"];
    
    // 初始化加载框
    self.progressHUD = [[MBProgressHUD alloc]initWithFrame:CGRectMake(0, 0, kSize_width, kSize_height)];
    [self.view addSubview:_progressHUD];
    
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

- (void)loadData{
    
    // 加载第一页公告数据
    [self loadNetDataWithPage:@"1" rows:@"10"];
}

#pragma mark - 加载网络数据
- (void)loadNetDataWithPage:(NSString *)page rows:(NSString *)rows{
    
    [self.progressHUD showAnimated:YES];
    
    [self loadUserDefaultsData];
    
    NSString *gameDetailLoc = [NSString stringWithFormat:@"%@user/1/playingRecord",kBaseLocation];
    NSDictionary *paramDic = @{@"roomId":self.roomId,@"page":page,@"rows":rows};
    
    // 请求登陆接口
    __weak typeof(self)weakSelf = self;
    [AFNetManager requestPOSTWithURLStr:gameDetailLoc paramDic:paramDic token:self.token finish:^(id responserObject) {
        
        NSLog(@"|GAMEDETAIL-VC|success:%@",responserObject);
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        NSString *code = [NSString stringWithFormat:@"%@",[responserObject objectForKey:@"code"]];
        NSString *msg = [responserObject objectForKey:@"msg"];
        NSMutableArray *gameArray = [responserObject objectForKey:@"data"];
        
        if (code.integerValue == 9200) {
            
            if (page.integerValue == 1) {  // 上拉刷新前清空之前数据
                
                [weakSelf.dataArray removeAllObjects];
            }
            
            for (NSDictionary *dataDic in gameArray) {
                
                GPBetDetailModel *detaileModel = [[GPBetDetailModel alloc]init];
                [detaileModel setValuesForKeysWithDictionary:dataDic];
                [weakSelf.dataArray addObject:detaileModel];
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
    
    self.token   = self.infoModel.token;
    
}

#pragma mark - tableview 代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
    //    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 238;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GPBetDetailCell *betDetailCell = [tableView dequeueReusableCellWithIdentifier:@"betDetailCell" forIndexPath:indexPath];
    
    betDetailCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    GPBetDetailModel *detailModel = self.dataArray[indexPath.row];
    
    [betDetailCell setDataWithModel:detailModel];
    
    return betDetailCell;
}


#pragma mark -懒加载
- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
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
