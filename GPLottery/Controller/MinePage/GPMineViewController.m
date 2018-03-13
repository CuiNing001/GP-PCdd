//
//  GPMineViewController.m
//  GPLottery
//
//  Created by cc on 2018/3/11.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPMineViewController.h"
#import "GPMineListCell.h"

@interface GPMineViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView      *headerView;      // headerView
@property (weak, nonatomic) IBOutlet UITableView *tableView;       // tableView
@property (weak, nonatomic) IBOutlet UIButton    *userImageBtn;    // 头像按钮
@property (weak, nonatomic) IBOutlet UIView      *nickView;        // 昵称、签名view
@property (weak, nonatomic) IBOutlet UILabel     *nickNameLab;     // 昵称lable
@property (weak, nonatomic) IBOutlet UILabel     *signatureLabel;  // 签名label
@property (strong, nonatomic) NSMutableArray     *listImageArray;  // 图标数据
@property (strong, nonatomic) NSMutableArray     *listTextArray;   // 文字数据
@property (strong, nonatomic) NSString           *money;           // 元宝金额



@end

@implementation GPMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    [self loadSubView];

}

#pragma mark - 加载子控件
- (void)loadSubView{
    
    // 修改资料view添加点击事件
    UITapGestureRecognizer *dataTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeData)];
    [self.nickView addGestureRecognizer:dataTap];
    
    // table view 代理
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    
    // tableView样式
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled  = NO;
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"GPMineListCell" bundle:nil] forCellReuseIdentifier:@"mineListCell"];
}

#pragma mark - 加载数据
- (void)loadData{
    
    // 初始化list数据
    self.listImageArray = @[@"mine_wallet",@"mine_backwater",@"mine_game",@"mine_history",@"mine_game_list",@"mine_share",@"mine_get",@"mine_setting",@"mine_about"].mutableCopy;
    self.listTextArray  = @[@"钱包",@"我的回水",@"幸运抽奖",@"帐变记录",@"游戏记录",@"VIP分享",@"我的收益",@"设置",@"关于"].mutableCopy;
    
    // 初始化钱包金额
    self.money = @"123.12";
    
    
}

#pragma mark - 修改头像
- (IBAction)changeUserImageBtn:(UIButton *)sender {
    
}

#pragma mark - 修改资料
- (void)changeData{
    
    
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
    
    // 赋值cell
    if (indexPath.row==0) {
        
        [mineListCell setDataWithImage:self.listImageArray[indexPath.row] text:self.listTextArray[indexPath.row] money:self.money];
        
    }else{
        
        [mineListCell setDataWithImage:self.listImageArray[indexPath.row] text:self.listTextArray[indexPath.row] money:nil];
    }
    
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
