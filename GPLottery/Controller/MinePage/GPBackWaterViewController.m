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

@interface GPBackWaterViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton    *lowRoomBtn;    // 初级房
@property (weak, nonatomic) IBOutlet UIButton    *middleRoomBtn; // 中级房
@property (weak, nonatomic) IBOutlet UIButton    *highRoomBtn;   // 高级房
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) MBProgressHUD      *progressHUD;
@property (strong, nonatomic) NSString           *backWaterLoc;  // 回水数据地址
@property (strong, nonatomic) GPInfoModel        *infoModel;     // 本地数据
@property (strong, nonatomic) NSString           *token;
@property (strong, nonatomic) NSMutableArray     *dataArray;     // 玩法数据
@property (strong, nonatomic) NSString           *playingMerchantId; // 玩法分类
@property (weak, nonatomic) IBOutlet UIView *emptyPage;


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
    [self loadNetData];
    
    if (self.dataArray.count==0) {
        
        self.emptyPage.hidden = NO;
    }else{
        
        self.emptyPage.hidden = YES;
    }
    
}

#pragma mark - 加载子控件
- (void)loadSubView{
    
    self.title = @"我的回水";
    
    // 添加代理
    self.tableView.dataSource = self;
    self.tableView.delegate   = self;
    
    // 初始化加载框
    self.progressHUD = [[MBProgressHUD alloc]initWithFrame:CGRectMake(0, 0, kSize_width, kSize_height)];
    [self.view addSubview:_progressHUD];
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"GPBackWaterCell" bundle:nil] forCellReuseIdentifier:@"backWaterCell"];
    
}

#pragma mark - 加载网络数据
- (void)loadNetData{
    
    [self.dataArray removeAllObjects];
    
    [self.progressHUD showAnimated:YES];
    
    [self loadUserDefaultsData];
    
    self.backWaterLoc = [NSString stringWithFormat:@"%@user/1/backWater",kBaseLocation];
    
    // 请求登陆接口
    __weak typeof(self)weakSelf = self;
    [AFNetManager requestPOSTWithURLStr:self.backWaterLoc paramDic:nil token:self.token finish:^(id responserObject) {
        
        NSLog(@"|BACKWATER-VC|success:%@",responserObject);
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        NSString *code = [NSString stringWithFormat:@"%@",[responserObject objectForKey:@"code"]];
        NSString *msg = [responserObject objectForKey:@"msg"];
        NSMutableArray *gameArray = [responserObject objectForKey:@"data"];
        
        if (code.integerValue == 9200) {
            
            [ToastView toastViewWithMessage:msg timer:1.5];
            
            for (NSDictionary *dataDic in gameArray) {
                
                GPBackWaterModel *backWaterModel = [GPBackWaterModel new];
                
                [backWaterModel setValuesForKeysWithDictionary:dataDic];
                
                if ([backWaterModel.playingMerchantId isEqualToString:self.playingMerchantId]) {
                    
                    [weakSelf.dataArray addObject:backWaterModel];
                }
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

#pragma mark - 回水规则
- (IBAction)rulesButton:(UIButton *)sender {
    
    
}

#pragma mark - 玩法一
- (IBAction)lowRoomBtn:(UIButton *)sender {
    
    // 修改点击状态
    self.lowRoomBtn.backgroundColor    = [UIColor colorWithRed:223/255.0 green:229/255.0 blue:233/255.0 alpha:1];
    self.middleRoomBtn.backgroundColor = [UIColor colorWithRed:193/255.0 green:193/255.0 blue:193/255.0 alpha:1];
    self.highRoomBtn.backgroundColor   = [UIColor colorWithRed:193/255.0 green:193/255.0 blue:193/255.0 alpha:1];
    [self.lowRoomBtn setTitleColor:[UIColor colorWithRed:26/255.0 green:198/255.0 blue:133/255.0 alpha:1] forState:UIControlStateNormal];
    [self.middleRoomBtn setTitleColor:[UIColor colorWithRed:69/255.0 green:69/255.0 blue:69/255.0 alpha:1] forState:UIControlStateNormal];
    [self.highRoomBtn setTitleColor:[UIColor colorWithRed:69/255.0 green:69/255.0 blue:69/255.0 alpha:1] forState:UIControlStateNormal];
    
    // 刷新数据
    self.playingMerchantId = @"1";
    [self loadNetData];
    if (self.dataArray.count==0) {
        
        self.emptyPage.hidden = NO;
    }else{
        
        self.emptyPage.hidden = YES;
    }
}

#pragma mark - 玩法二
- (IBAction)middleRoomBtn:(UIButton *)sender {
    
    // 修改点击状态
    self.middleRoomBtn.backgroundColor = [UIColor colorWithRed:223/255.0 green:229/255.0 blue:233/255.0 alpha:1];
    self.lowRoomBtn.backgroundColor    = [UIColor colorWithRed:193/255.0 green:193/255.0 blue:193/255.0 alpha:1];
    self.highRoomBtn.backgroundColor   = [UIColor colorWithRed:193/255.0 green:193/255.0 blue:193/255.0 alpha:1];
    [self.middleRoomBtn setTitleColor:[UIColor colorWithRed:26/255.0 green:198/255.0 blue:133/255.0 alpha:1] forState:UIControlStateNormal];
    [self.highRoomBtn setTitleColor:[UIColor colorWithRed:69/255.0 green:69/255.0 blue:69/255.0 alpha:1] forState:UIControlStateNormal];
    [self.lowRoomBtn setTitleColor:[UIColor colorWithRed:69/255.0 green:69/255.0 blue:69/255.0 alpha:1] forState:UIControlStateNormal];
    
    // 刷新数据
    self.playingMerchantId = @"1";
    [self loadNetData];
    if (self.dataArray.count==0) {
        
        self.emptyPage.hidden = NO;
    }else{
        
        self.emptyPage.hidden = YES;
    }
}

#pragma mark - 玩法三
- (IBAction)highRoomBtn:(UIButton *)sender {
    
    // 修改点击状态
    self.highRoomBtn.backgroundColor   = [UIColor colorWithRed:223/255.0 green:229/255.0 blue:233/255.0 alpha:1];
    self.middleRoomBtn.backgroundColor = [UIColor colorWithRed:193/255.0 green:193/255.0 blue:193/255.0 alpha:1];
    self.lowRoomBtn.backgroundColor    = [UIColor colorWithRed:193/255.0 green:193/255.0 blue:193/255.0 alpha:1];
    [self.highRoomBtn setTitleColor:[UIColor colorWithRed:26/255.0 green:198/255.0 blue:133/255.0 alpha:1] forState:UIControlStateNormal];
    [self.middleRoomBtn setTitleColor:[UIColor colorWithRed:69/255.0 green:69/255.0 blue:69/255.0 alpha:1] forState:UIControlStateNormal];
    [self.lowRoomBtn setTitleColor:[UIColor colorWithRed:69/255.0 green:69/255.0 blue:69/255.0 alpha:1] forState:UIControlStateNormal];
    
    // 刷新数据
    self.playingMerchantId = @"1";
    [self loadNetData];
    if (self.dataArray.count==0) {
        
        self.emptyPage.hidden = NO;
    }else{
        
        self.emptyPage.hidden = YES;
    }
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
