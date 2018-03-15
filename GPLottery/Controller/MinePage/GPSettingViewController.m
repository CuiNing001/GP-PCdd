//
//  GPSettingViewController.m
//  GPLottery
//
//  Created by cc on 2018/3/14.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPSettingViewController.h"
#import "GPMineListCell.h"
#import "GPHomeViewController.h"

@interface GPSettingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray     *listImageArray;  // 图标数据
@property (strong, nonatomic) NSMutableArray     *listTextArray;   // 文字数据
@property (strong, nonatomic) MBProgressHUD      *progressHUD;  // 加载框

@end

@implementation GPSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    [self loadSubView];
}

- (void)loadData{
    
    // 初始化list数据
    self.listImageArray = @[@"setting_card",@"setting_password_change",@"setting_withdraw_password",@"setting_clean",@"setting_phone"].mutableCopy;
    self.listTextArray  = @[@"绑定银行卡",@"修改密码",@"提现密码",@"清除缓存",@"绑定手机"].mutableCopy;
    
}

- (void)loadSubView{
    
    self.title = @"设置";
    
    // table view 代理
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    
    // tableView样式
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled  = NO;
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"GPMineListCell" bundle:nil] forCellReuseIdentifier:@"mineListCell"];
    
    // 初始化加载框
    self.progressHUD = [[MBProgressHUD alloc]initWithFrame:CGRectMake(0, 0, kSize_width, kSize_height)];
    [self.view addSubview:_progressHUD];
}

#pragma mark - 退出登陆
- (IBAction)singoutButton:(UIButton *)sender {
    
    [self.progressHUD showAnimated:YES];
    
    // 删除本地数据
    [UserDefaults deleateData];
    
    [self.progressHUD hideAnimated:YES];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

#pragma mark - tableView dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.listImageArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GPMineListCell *mineListCell = [tableView dequeueReusableCellWithIdentifier:@"mineListCell" forIndexPath:indexPath];
    
    [mineListCell setDataWithImage:self.listImageArray[indexPath.row] text:self.listTextArray[indexPath.row] money:nil];
    
    return mineListCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 点击后取消cell的点击状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
}


#pragma mark - 懒加载
- (NSMutableArray *)listImageArray{
    
    if (!_listImageArray) {
        
        self.listImageArray = [NSMutableArray array];
    }
    
    return _listImageArray;
}

- (NSMutableArray *)listTextArray{
    
    if (!_listTextArray) {
        
        self.listTextArray = [NSMutableArray array];
    }
    
    return _listTextArray;
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
