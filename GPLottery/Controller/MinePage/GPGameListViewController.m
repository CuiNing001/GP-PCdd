//
//  GPGameListViewController.m
//  GPLottery
//
//  Created by cc on 2018/3/14.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPGameListViewController.h"
#import "GPBetModel.h"
#import "GPBetCell.h"
#import "GPGameDetailViewController.h"

static int typeNum  = 0; // 游戏类型点击次数
static int startNum = 0; // 开始时间点击次数
static int endNum   = 0; // 结束时间点击次数
static int touchTag = 0; // 点击出现选择器的view的tag值
@interface GPGameListViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *typeTableView;
@property (strong, nonatomic) GPInfoModel    *infoModel;
@property (strong, nonatomic) NSString       *token;
@property (strong, nonatomic) NSMutableArray *dataArray;     // 玩法数据
@property (strong, nonatomic) MBProgressHUD  *progressHUD;
@property (weak, nonatomic) IBOutlet UILabel *typeLab;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLab;
@property (weak, nonatomic) IBOutlet UIDatePicker *dataPicker;  // 时间选择器
@property (weak, nonatomic) IBOutlet UIView   *dataPickerView;
@property (weak, nonatomic) IBOutlet UIButton *dataPickerBtn;
@property (strong, nonatomic) NSString        *typeID;

@end

@implementation GPGameListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadSubView];
    [self loadData];
    
}

- (void)loadData{
    
    [self.progressHUD showAnimated:YES];
    
    [self loadUserDefaultsData];
    
    NSString *enterRoomLoc = [NSString stringWithFormat:@"%@user/1/enterMyBet",kBaseLocation];
    
    // 请求登陆接口
    __weak typeof(self)weakSelf = self;
    [AFNetManager requestPOSTWithURLStr:enterRoomLoc paramDic:nil token:self.token finish:^(id responserObject) {
        
        NSLog(@"|GAMELIST-VC|success:%@",responserObject);
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        NSString *code = [NSString stringWithFormat:@"%@",[responserObject objectForKey:@"code"]];
        NSString *msg = [responserObject objectForKey:@"msg"];
        NSMutableArray *gameArray = [responserObject objectForKey:@"data"];
        
        if (code.integerValue == 9200) {
            
//            [ToastView toastViewWithMessage:msg timer:1.5];
            
            for (NSDictionary *dataDic in gameArray) {
                
                GPBetModel *betModel = [GPBetModel new];
                
                [betModel setValuesForKeysWithDictionary:dataDic];
                
                [weakSelf.dataArray addObject:betModel];
            }
            
            [weakSelf.typeTableView reloadData];
            
        }else{
            
            [ToastView toastViewWithMessage:msg timer:2.5];
        }
        
    } enError:^(NSError *error) {
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        [ToastView toastViewWithMessage:@"数据连接出错，请稍后再试" timer:3.0];
        
    }];
    
}

- (void)loadSubView{
    
    // 游戏类型默认为全部
    self.typeID = @"0";
    
    self.title = @"游戏记录";
    
    self.typeTableView.hidden        = YES;
    self.typeTableView.dataSource    = self;
    self.typeTableView.delegate      = self;
    self.typeTableView.scrollEnabled = NO;
    
    
    [self.typeTableView registerNib:[UINib nibWithNibName:@"GPBetCell" bundle:nil] forCellReuseIdentifier:@"enterRoomCell"];
    
    // 初始化加载框
    self.progressHUD = [[MBProgressHUD alloc]initWithFrame:CGRectMake(0, 0, kSize_width, kSize_height)];
    [self.view addSubview:_progressHUD];
    
    // 时间选择器
    [self.dataPicker setCalendar:[NSCalendar currentCalendar]];  // 默认为当天
    [self.dataPicker setTimeZone:[NSTimeZone systemTimeZone]];   // 设置时区
    self.dataPicker.datePickerMode = UIDatePickerModeDate;       // 设置显示模式
    [self.dataPicker setLocale:[NSLocale localeWithLocaleIdentifier:@"zh_Hans_CN"]]; // 日期模式为中文
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]; // 当前日历时间
    NSDate *currentDate = [NSDate date];    // 转换dete
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:1];//设置最大时间为：当前时间
    NSDate *maxDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    [comps setYear:-1];//设置最小时间为：当前时间前推3年
    NSDate *minDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    self.dataPicker.minimumDate = minDate;  // 设置最小时间
    self.dataPicker.maximumDate = maxDate;  // 设置最大时间
    self.dataPickerView.hidden = YES;  // 默认隐藏
}

#pragma mark -游戏类型
- (IBAction)gameTypeTap:(UITapGestureRecognizer *)sender {
    
    typeNum++;
    
    if (typeNum%2==0) {
        
        self.typeTableView.hidden = YES;
    }else{
        self.typeTableView.hidden = NO;
    }
}

#pragma mark- 开始时间
- (IBAction)gameStartTimeTap:(UITapGestureRecognizer *)sender {
    
    touchTag = 1;
    
    startNum++;
    
    if (startNum%2==0) {
        
        self.dataPickerView.hidden = YES;
    }else{
        self.dataPickerView.hidden = NO;
    }
}

#pragma mark- 结束时间
- (IBAction)gameEndTimeTap:(UITapGestureRecognizer *)sender {
    
    touchTag = 2;
    
    endNum++;
    
    if (endNum%2==0) {
        
        self.dataPickerView.hidden = YES;
    }else{
        self.dataPickerView.hidden = NO;
    }
}

#pragma mark - 确定提交按钮
- (IBAction)makeSureButton:(UIButton *)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    GPGameDetailViewController *gameDetailVC = [storyboard instantiateViewControllerWithIdentifier:@"gameDetailVC"];
    gameDetailVC.productId = self.typeID;
    gameDetailVC.beginDate = self.startTimeLab.text;
    gameDetailVC.endDate   = self.endTimeLab.text;
    [self.navigationController pushViewController:gameDetailVC animated:YES];
}

#pragma mark -选择时间确定
- (IBAction)dataPickerButton:(UIButton *)sender {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *pickerStr = [formatter stringFromDate:self.dataPicker.date];
    NSDate *pickerDate = [[formatter dateFromString:pickerStr]dateByAddingTimeInterval:60*60*8]; // 修改时间偏差
    NSString *timeStr = [formatter stringFromDate:pickerDate];
    
    if (touchTag ==1 ) {
        
        startNum++;
        self.dataPickerView.hidden = YES;
        
        self.startTimeLab.text = timeStr;
        
    }else if(touchTag == 2){
        
        endNum++;
        self.dataPickerView.hidden = YES;
        
        self.endTimeLab.text = timeStr;
    }
}

#pragma mark - 加载本地数据
- (void)loadUserDefaultsData{
    
    NSMutableDictionary *infoDic = [UserDefaults searchData];
    
    self.infoModel               = [[GPInfoModel alloc]init];
    
    [self.infoModel setValuesForKeysWithDictionary:infoDic];
    
    self.token = self.infoModel.token;
    
}

#pragma mark - table view datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GPBetCell *betCell = [tableView dequeueReusableCellWithIdentifier:@"enterRoomCell" forIndexPath:indexPath];
    
    if (self.dataArray.count>0) {
        
        GPBetModel *betModel = self.dataArray[indexPath.row];
        
        [betCell setDateWithModel:betModel];
    }else{
        
        betCell.typeLab.text = @"暂无数据";
    }
 
    return betCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    typeNum++;
    self.typeTableView.hidden = YES;
    
    // 取消点击后状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.dataArray.count>0) {
        
        GPBetModel *betModel = self.dataArray[indexPath.row];
        
        self.typeLab.text    = betModel.name;
        
        self.typeID          = betModel.id;
    }
    
    
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
