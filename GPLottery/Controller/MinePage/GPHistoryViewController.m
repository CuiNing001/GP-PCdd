//
//  GPHistoryViewController.m
//  GPLottery
//
//  Created by cc on 2018/3/14.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPHistoryViewController.h"
#import "GPHistoryModel.h"
#import "GPHistoryCell.h"

@interface GPHistoryViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView  *emptyPage;
@property (strong, nonatomic) MBProgressHUD  *progressHUD;
@property (strong, nonatomic) GPInfoModel    *infoModel;
@property (strong, nonatomic) NSString       *token;
@property (strong, nonatomic) NSMutableArray *dataArray;     // 玩法数据
@property (strong, nonatomic) NSString       *historyLoc;    // 帐变记录地址

@end

@implementation GPHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self loadData];
    [self loadSubView];
}

- (void)loadData{
    
    [self loadNetData];
}

- (void)loadSubView{
    
    self.title = @"帐变记录";
    
    // 添加代理
    self.tableView.dataSource = self;
    self.tableView.delegate   = self;
    
    // 初始化加载框
    self.progressHUD = [[MBProgressHUD alloc]initWithFrame:CGRectMake(0, 0, kSize_width, kSize_height)];
    [self.view addSubview:_progressHUD];
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"GPHistoryCell" bundle:nil] forCellReuseIdentifier:@"historyCell"];
    
}

- (void)loadNetData{
    
    [self.progressHUD showAnimated:YES];
    
    [self loadUserDefaultsData];
    
    self.historyLoc = [NSString stringWithFormat:@"%@user/1/myMoneyChangeInfo",kBaseLocation];
    
    // 请求登陆接口
    __weak typeof(self)weakSelf = self;
    [AFNetManager requestPOSTWithURLStr:self.historyLoc paramDic:nil token:self.token finish:^(id responserObject) {
        
        NSLog(@"|HISTORY-VC|success:%@",responserObject);
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        NSString *code = [NSString stringWithFormat:@"%@",[responserObject objectForKey:@"code"]];
        NSString *msg = [responserObject objectForKey:@"msg"];
        NSMutableArray *gameArray = [responserObject objectForKey:@"data"];
        
        if (code.integerValue == 9200) {
            
            [ToastView toastViewWithMessage:msg timer:1.5];
            
            for (NSDictionary *dataDic in gameArray) {
                
                GPHistoryModel *historyModel = [GPHistoryModel new];
                
                [historyModel setValuesForKeysWithDictionary:dataDic];
                    
                [weakSelf.dataArray addObject:historyModel];
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
    
}

#pragma mark - tableView dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GPHistoryCell *historyCell = [tableView dequeueReusableCellWithIdentifier:@"historyCell" forIndexPath:indexPath];
    
    GPHistoryModel *historyModel = self.dataArray[indexPath.row];
    
    [historyCell setDateWithModel:historyModel];
    
    return historyCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    // 点击后取消cell的点击状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
}

#pragma mark - 加载本地数据
- (void)loadUserDefaultsData{
    
    NSMutableDictionary *infoDic = [UserDefaults searchData];
    
    self.infoModel               = [[GPInfoModel alloc]init];
    
    [self.infoModel setValuesForKeysWithDictionary:infoDic];
    
    self.token = self.infoModel.token;
    
}

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
