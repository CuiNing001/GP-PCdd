//
//  GPGameDetailViewController.m
//  GPLottery
//
//  Created by cc on 2018/3/16.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPGameDetailViewController.h"
#import "GPBetDetailModel.h"
#import "GPBetDetailCell.h"

@interface GPGameDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) MBProgressHUD *progressHUD;
@property (strong, nonatomic) GPInfoModel    *infoModel;
@property (strong, nonatomic) NSString       *token;
@property (strong, nonatomic) NSMutableArray *dataArray;     // 玩法数据

@end

@implementation GPGameDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    [self loadSubView];
}

#pragma mark - 加载数据
- (void)loadData{
    
    // 加载网络数据
    [self loadNetData];
}

#pragma mark - 加载子控件
- (void)loadSubView{
    
    self.title = @"游戏记录";
    
    // 初始化加载框
    self.progressHUD = [[MBProgressHUD alloc]initWithFrame:CGRectMake(0, 0, kSize_width, kSize_height)];
    [self.view addSubview:_progressHUD];
    
    // table view
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"GPBetDetailCell" bundle:nil] forCellReuseIdentifier:@"betDetailCell"];
}

#pragma mark - 加载网络数据
- (void)loadNetData{
    
    [self.progressHUD showAnimated:YES];
    
    [self loadUserDefaultsData];
    
    NSString *gameDetailLoc = [NSString stringWithFormat:@"%@user/1/enterBetDetail",kBaseLocation];
    NSDictionary *paramDic = @{@"productId":self.productId,@"beginDate":self.beginDate,@"endDate":self.endDate};
    
    // 请求登陆接口
    __weak typeof(self)weakSelf = self;
    [AFNetManager requestPOSTWithURLStr:gameDetailLoc paramDic:paramDic token:self.token finish:^(id responserObject) {
        
        NSLog(@"|GAMEDETAIL-VC|success:%@",responserObject);
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        NSString *code = [NSString stringWithFormat:@"%@",[responserObject objectForKey:@"code"]];
        NSString *msg = [responserObject objectForKey:@"msg"];
        NSMutableArray *gameArray = [responserObject objectForKey:@"data"];
        
        if (code.integerValue == 9200) {
            
            [ToastView toastViewWithMessage:msg timer:1.5];
            
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
    
}

#pragma mark - 加载本地数据
- (void)loadUserDefaultsData{
    
    NSMutableDictionary *infoDic = [UserDefaults searchData];
    
    self.infoModel               = [[GPInfoModel alloc]init];
    
    [self.infoModel setValuesForKeysWithDictionary:infoDic];
    
    self.token = self.infoModel.token;
    
}

#pragma mark - tableview 代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
//    return self.dataArray.count;
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 238;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GPBetDetailCell *betDetailCell = [tableView dequeueReusableCellWithIdentifier:@"betDetailCell" forIndexPath:indexPath];
    
    betDetailCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
//    GPBetDetailModel *detailModel = self.dataArray[indexPath.row];
//
//    [betDetailCell setDataWithModel:detailModel];
    
    betDetailCell.titleLab.text        = @"北京28--123566期";
    betDetailCell.openCodeLab.text     = @"6+0+1";;
    betDetailCell.playingTypeLab.text  = @"大小单双";
    betDetailCell.openTypeLab.text     = @"大小单双";
    betDetailCell.betAmoutLab.text     = @"200元宝";
    betDetailCell.rewardNumLAb.text    = @"200元宝";
    betDetailCell.openTimeLab.text     = @"2018-2-12 12:12:12";
    betDetailCell.topRewardNumLab.text = @"200元宝";
    
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