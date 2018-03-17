//
//  GPUserInfoViewController.m
//  GPLottery
//
//  Created by cc on 2018/3/17.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPUserInfoViewController.h"

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
    
    self.yearDataSource = @[@"2017年",@"2018年"].mutableCopy;
    self.monthDataSourcr = @[@"1月",@"2月",@"3月",@"4月",@"5月",@"6月",@"7月",@"8月",@"9月",@"10月",@"11月",@"12月"].mutableCopy;
    
}

- (void)loadSubView{
    
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
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@""];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView.tag == 3001) {
        
        return self.yearDataSource.count;
        
    }else if (tableView.tag == 3002){
        
        return self.monthDataSourcr.count;
    }else{
        
        return self.dataSource.count;
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
        
        return [[UITableViewCell alloc]init];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView.tag == 3001) {  // 选择年份cell点击事件
        
        self.yearLab.text = self.yearDataSource[indexPath.row];
        
        yearNum++;
        
        monthNum++;
        
        self.alertYearTableView.hidden = YES;
        
    }else if (tableView.tag == 3002){  // 选择月份cell点击事件
        
        self.mounthLab.text = self.monthDataSourcr[indexPath.row];
        
        monthNum++;
        
        yearNum++;
        
        self.alertMounthTableView.hidden = YES;
        
    }else{  // 正常cell点击事件
        
        
    }
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
