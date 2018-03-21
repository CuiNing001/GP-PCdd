//
//  GPLuckyListViewController.m
//  GPLottery
//
//  Created by cc on 2018/3/21.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPLuckyListViewController.h"
#import "GPLuckyModel.h"
#import "GPLuckyCell.h"

@interface GPLuckyListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) GPInfoModel        *infoModel;       // 本地数据
@property (strong, nonatomic) NSString           *token;
@property (strong, nonatomic) MBProgressHUD      *progressHUD;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray     *luckyDataArray;

@end

@implementation GPLuckyListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    [self loadSubView];
}

- (void)loadData{
    
    [self loadNetData];
}

- (void)loadSubView{
    
    self.title = @"抽奖记录";
    
    // table view 代理
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    
    // tableView样式
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled  = NO;
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"GPLuckyCell" bundle:nil] forCellReuseIdentifier:@"luckyCell"];
    
    // 初始化加载框
    self.progressHUD = [[MBProgressHUD alloc]initWithFrame:CGRectMake(0, 0, kSize_width, kSize_height)];
    [self.view addSubview:_progressHUD];
}

- (void)loadNetData{
    
    [self.progressHUD showAnimated:YES];
    
    [self loadUserDefaultsData];
    
    NSString *luckyListLoc = [NSString stringWithFormat:@"%@user/1/myLuckTurntableRecord",kBaseLocation];
    
    // 请求登陆接口
    __weak typeof(self)weakSelf = self;
    [AFNetManager requestPOSTWithURLStr:luckyListLoc paramDic:nil token:self.token finish:^(id responserObject) {
        
        NSLog(@"|LUCKYLIST-VC|success:%@",responserObject);
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        NSString *code = [NSString stringWithFormat:@"%@",[responserObject objectForKey:@"code"]];
        NSString *msg = [responserObject objectForKey:@"msg"];
        NSArray *luckyArr = [responserObject objectForKey:@"data"];
        
        if (code.integerValue == 9200) {
            
            [ToastView toastViewWithMessage:msg timer:3.0];
            
            for (NSDictionary *luckyDic in luckyArr) {
                
                GPLuckyModel *luckyModel = [GPLuckyModel new];
                
                [luckyModel setValuesForKeysWithDictionary:luckyDic];
                
                [self.luckyDataArray addObject:luckyModel];
            }
            [self.tableView reloadData];
        }else{
            
            [ToastView toastViewWithMessage:msg timer:3.0];
        }
        
    } enError:^(NSError *error) {
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        [ToastView toastViewWithMessage:@"数据连接出错，请稍后再试" timer:3.0];
        
    }];
}

#pragma mark - tableview代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.luckyDataArray.count>0) {
        
        return self.luckyDataArray.count;
    }else{
        
        return 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GPLuckyCell *luckyCell = [tableView dequeueReusableCellWithIdentifier:@"luckyCell" forIndexPath:indexPath];
    
    if (self.luckyDataArray.count>0) {
        
        GPLuckyModel *luckyModel = self.luckyDataArray[indexPath.row];
        
        [luckyCell setDataWithModel:luckyModel];
    }else{
        
        luckyCell.creatTimeLab.text      = @"2018-2-12 12:00";
        luckyCell.luckMoneyLevelLab.text = @"3";
        luckyCell.extractAmountLab.text  = @"55.00元宝";
    }
    
    return luckyCell;
}

#pragma mark - 加载本地数据
- (void)loadUserDefaultsData{
    
    NSMutableDictionary *infoDic = [UserDefaults searchData];
    
    self.infoModel               = [[GPInfoModel alloc]init];
    
    [self.infoModel setValuesForKeysWithDictionary:infoDic];
    
    self.token = self.infoModel.token;
    
}

#pragma mark - 懒加载
- (NSMutableArray *)luckyDataArray{
    
    if (!_luckyDataArray) {
        
        self.luckyDataArray = [NSMutableArray array];
    }
    return _luckyDataArray;
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