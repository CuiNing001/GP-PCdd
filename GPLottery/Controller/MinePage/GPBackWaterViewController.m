//
//  GPBackWaterViewController.m
//  GPLottery
//
//  Created by cc on 2018/3/14.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPBackWaterViewController.h"
#import "GPBackWaterModel.h"
#import "GPBackWaterCell.h"
#import "GPBackWaterRulesViewController.h"

@interface GPBackWaterViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton    *lowRoomBtn;    // 初级房
@property (weak, nonatomic) IBOutlet UIButton    *middleRoomBtn; // 中级房
@property (weak, nonatomic) IBOutlet UIButton    *highRoomBtn;   // 高级房
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) MBProgressHUD      *progressHUD;
@property (strong, nonatomic) NSString           *backWaterLoc;  // 回水数据地址
@property (strong, nonatomic) GPInfoModel        *infoModel;     // 本地数据
@property (strong, nonatomic) NSString           *token;
//@property (strong, nonatomic) NSMutableArray     *statusOneArray;       // 玩法二数据
//@property (strong, nonatomic) NSMutableArray     *statusTwoArray;       // 玩法二数据
//@property (strong, nonatomic) NSMutableArray     *statusThreeArray;     // 玩法三数据
@property (strong, nonatomic) NSMutableArray     *dataArray;  // 玩法数据
@property (strong, nonatomic) NSString           *playingMerchantId; // 玩法分类
@property (weak, nonatomic) IBOutlet UIView *emptyPage;
@property (assign, nonatomic) NSInteger page; // 页码
@property (assign, nonatomic) NSInteger rows; // 加载条数
@property (strong, nonatomic) NSString *agreementUrl;  // 回水规则地址


@end

@implementation GPBackWaterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    [self loadSubView];
    
}

#pragma mark - 加载数据
- (void)loadData{
    
    // 默认请求玩法一数据
    self.playingMerchantId = @"1";
    // 加载第一页公告数据
    [self loadNetDataWithPage:@"1" rows:@"10"];
    
}

#pragma mark - 加载子控件
- (void)loadSubView{
    
    self.title = @"我的回水";
    
    // 初始化页码和条数
    self.page = 1;
    self.rows = 10;
    
    // 添加代理
    self.tableView.dataSource = self;
    self.tableView.delegate   = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 初始化加载框
    self.progressHUD = [[MBProgressHUD alloc]initWithFrame:CGRectMake(0, 0, kSize_width, kSize_height)];
    [self.view addSubview:_progressHUD];
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"GPBackWaterCell" bundle:nil] forCellReuseIdentifier:@"backWaterCell"];
    
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

#pragma mark - 加载网络数据
- (void)loadNetDataWithPage:(NSString *)page rows:(NSString *)rows{
    
    [self.progressHUD showAnimated:YES];
    
    [self loadUserDefaultsData];
    
    self.backWaterLoc = [NSString stringWithFormat:@"%@user/1/backWater",kBaseLocation];
    
    NSDictionary *paramDic = @{@"page":page,@"rows":rows};
    
    // 请求登陆接口
    __weak typeof(self)weakSelf = self;
    [AFNetManager requestPOSTWithURLStr:self.backWaterLoc paramDic:paramDic token:self.token finish:^(id responserObject) {
        
        NSLog(@"|BACKWATER-VC|success:%@",responserObject);
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        NSString *code = [NSString stringWithFormat:@"%@",[responserObject objectForKey:@"code"]];
        NSString *msg = [responserObject objectForKey:@"msg"];
        NSDictionary *gameDic = [responserObject objectForKey:@"data"];
        
        if (code.integerValue == 9200) {
            
//            [ToastView toastViewWithMessage:msg timer:1.5];
            
            weakSelf.agreementUrl = [gameDic objectForKey:@"huiShuiUrl"];
            NSArray *statusOne   = [gameDic objectForKey:@"data1"];  // 玩法一
            NSArray *statusTwo   = [gameDic objectForKey:@"data2"];  // 玩法二
            NSArray *statusThree = [gameDic objectForKey:@"data3"];  // 玩法三
            
            if ([self.playingMerchantId isEqualToString:@"1"]) {
                
                for (NSDictionary *oneData in statusOne) {  // 玩法一数据
                    
                    GPBackWaterModel *backwaterModel = [GPBackWaterModel new];
                    
                    [backwaterModel setValuesForKeysWithDictionary:oneData];
                    
                    [self.dataArray addObject:backwaterModel];
                }
            }else if ([self.playingMerchantId isEqualToString:@"2"]){
                
                
                for (NSDictionary *twoData in statusTwo) {  // 玩法二数据
                    
                    GPBackWaterModel *backwaterModel = [GPBackWaterModel new];
                    
                    [backwaterModel setValuesForKeysWithDictionary:twoData];
                    
                    [self.dataArray addObject:backwaterModel];
                }
                
            }else if ([self.playingMerchantId isEqualToString:@"3"]){
                
                for (NSDictionary *threeData in statusThree) {  // 玩法三数据
                    
                    GPBackWaterModel *backwaterModel = [GPBackWaterModel new];
                    
                    [backwaterModel setValuesForKeysWithDictionary:threeData];
                    
                    [self.dataArray addObject:backwaterModel];
                }
                
            }
            // 空数据显示默认空页面
            if (weakSelf.dataArray.count>0) {

                self.emptyPage.hidden = YES;
            }else{
                self.emptyPage.hidden = NO;
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

#pragma mark - 回水规则
- (IBAction)rulesButton:(UIButton *)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    GPBackWaterRulesViewController *backWaterRulesVC = [storyboard instantiateViewControllerWithIdentifier:@"backWaterRulesVC"];
    
    backWaterRulesVC.agreementUrl = self.agreementUrl;
    
    [self.navigationController pushViewController:backWaterRulesVC animated:YES];
}

#pragma mark - 玩法一
- (IBAction)lowRoomBtn:(UIButton *)sender {
    
    [self.dataArray removeAllObjects];
    // 修改点击状态
    self.lowRoomBtn.backgroundColor    = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
    self.middleRoomBtn.backgroundColor = [UIColor colorWithRed:193/255.0 green:193/255.0 blue:193/255.0 alpha:1];
    self.highRoomBtn.backgroundColor   = [UIColor colorWithRed:193/255.0 green:193/255.0 blue:193/255.0 alpha:1];
    [self.lowRoomBtn setTitleColor:[UIColor colorWithRed:56/255.0 green:135/255.0 blue:234/255.0 alpha:1] forState:UIControlStateNormal];
    [self.middleRoomBtn setTitleColor:[UIColor colorWithRed:69/255.0 green:69/255.0 blue:69/255.0 alpha:1] forState:UIControlStateNormal];
    [self.highRoomBtn setTitleColor:[UIColor colorWithRed:69/255.0 green:69/255.0 blue:69/255.0 alpha:1] forState:UIControlStateNormal];
    
    // 刷新数据
    self.playingMerchantId = @"1";
    // 加载第一页公告数据
    [self loadNetDataWithPage:@"1" rows:@"10"];
    
}

#pragma mark - 玩法二
- (IBAction)middleRoomBtn:(UIButton *)sender {
    
    [self.dataArray removeAllObjects];
    
    // 修改点击状态
    self.middleRoomBtn.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
    self.lowRoomBtn.backgroundColor    = [UIColor colorWithRed:193/255.0 green:193/255.0 blue:193/255.0 alpha:1];
    self.highRoomBtn.backgroundColor   = [UIColor colorWithRed:193/255.0 green:193/255.0 blue:193/255.0 alpha:1];
    [self.middleRoomBtn setTitleColor:[UIColor colorWithRed:56/255.0 green:135/255.0 blue:234/255.0 alpha:1] forState:UIControlStateNormal];
    [self.highRoomBtn setTitleColor:[UIColor colorWithRed:69/255.0 green:69/255.0 blue:69/255.0 alpha:1] forState:UIControlStateNormal];
    [self.lowRoomBtn setTitleColor:[UIColor colorWithRed:69/255.0 green:69/255.0 blue:69/255.0 alpha:1] forState:UIControlStateNormal];
    
    // 刷新数据
    self.playingMerchantId = @"2";
    // 加载第一页公告数据
    [self loadNetDataWithPage:@"1" rows:@"10"];
   
}

#pragma mark - 玩法三
- (IBAction)highRoomBtn:(UIButton *)sender {
    
    [self.dataArray removeAllObjects];
    
    // 修改点击状态
    self.highRoomBtn.backgroundColor   = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
    self.middleRoomBtn.backgroundColor = [UIColor colorWithRed:193/255.0 green:193/255.0 blue:193/255.0 alpha:1];
    self.lowRoomBtn.backgroundColor    = [UIColor colorWithRed:193/255.0 green:193/255.0 blue:193/255.0 alpha:1];
    [self.highRoomBtn setTitleColor:[UIColor colorWithRed:56/255.0 green:135/255.0 blue:234/255.0 alpha:1] forState:UIControlStateNormal];
    [self.middleRoomBtn setTitleColor:[UIColor colorWithRed:69/255.0 green:69/255.0 blue:69/255.0 alpha:1] forState:UIControlStateNormal];
    [self.lowRoomBtn setTitleColor:[UIColor colorWithRed:69/255.0 green:69/255.0 blue:69/255.0 alpha:1] forState:UIControlStateNormal];
    
    // 刷新数据
    self.playingMerchantId = @"3";
    // 加载第一页公告数据
    [self loadNetDataWithPage:@"1" rows:@"10"];
    
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
    
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GPBackWaterCell *backWaterCell = [tableView dequeueReusableCellWithIdentifier:@"backWaterCell" forIndexPath:indexPath];
    
    backWaterCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    GPBackWaterModel *backWaterModel = self.dataArray[indexPath.row];
    
    [backWaterCell setDataWithModel:backWaterModel];
    
    return backWaterCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 点击后取消cell的点击状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
}

#pragma mark -懒加载
- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

//- (NSMutableArray *)statusOneArray{
//
//    if (!_statusOneArray) {
//
//        self.statusOneArray = [NSMutableArray array];
//    }
//    return _statusOneArray;
//}
//
//- (NSMutableArray *)statusTwoArray{
//
//    if (!_statusTwoArray) {
//
//        self.statusTwoArray = [NSMutableArray array];
//    }
//    return _statusTwoArray;
//}
//
//- (NSMutableArray *)statusThreeArray{
//
//    if (!_statusThreeArray) {
//
//        self.statusThreeArray = [NSMutableArray array];
//    }
//    return _statusThreeArray;
//}

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
