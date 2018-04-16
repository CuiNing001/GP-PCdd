//
//  GPNoticeViewController.m
//  GPLottery
//
//  Created by cc on 2018/3/11.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPNoticeViewController.h"
#import <SDCycleScrollView/SDCycleScrollView.h>
#import "GPNoticeModel.h"
#import "GPNoticeCell.h"
#import "GPNoticeDetailViewController.h"
#import "UITabBar+RedCircle.h"

static int touch = 0;  //  标记不同的tableview数据源
@interface GPNoticeViewController ()<SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *headerView;     // 轮播图
@property (weak, nonatomic) IBOutlet UIView *noticeBtnView;  // 公告底部view
@property (weak, nonatomic) IBOutlet UIView *msgBtnView;     // 消息底部view
@property (weak, nonatomic) IBOutlet UIButton *noticeBtn;    // 公告按钮
@property (weak, nonatomic) IBOutlet UIButton *msgBtn;       // 消息按钮
@property (weak, nonatomic) IBOutlet UITableView *tableView; // 消息列表

@property (strong, nonatomic) GPInfoModel *infoModel;            // 本地数据
@property (strong, nonatomic) MBProgressHUD *progressHUD;
@property (strong, nonatomic) NSString *token;

@property (strong, nonatomic) NSMutableArray *noticeDataArr;   // 公告数据
@property (strong, nonatomic) NSMutableArray *myMsgDataArr;    // 我的消息
@property (assign, nonatomic) NSInteger page; // 页码
@property (assign, nonatomic) NSInteger rows; // 加载条数


@end

@implementation GPNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadSubView];
    [self loadData];

}

- (void)viewWillAppear:(BOOL)animated{
    
    [self loadUserDefaultsData];
    
    // 未登陆状态返回首页界面
    if (![self.infoModel.islogin isEqualToString:@"1"]) {
        
        self.tabBarController.selectedIndex = 0;
    }
}

#pragma mark - 加载子控件
- (void)loadSubView{
    
    self.automaticallyAdjustsScrollViewInsets = false;
    
    // 初始化页码和条数
    self.page = 1;
    self.rows = 10;
    
    // 轮播图view添加边框
//    self.headerView.layer.borderColor = [UIColor orangeColor].CGColor;
//    self.headerView.layer.borderWidth = 1;

    // 设置轮播图
    CGRect rect = CGRectMake(self.headerView.bounds.origin.x, self.headerView.bounds.origin.y, self.headerView.bounds.size.width+38, self.headerView.bounds.size.height);
    SDCycleScrollView *scrollView = [SDCycleScrollView cycleScrollViewWithFrame:rect
                                                                       delegate:self
                                                               placeholderImage:[UIImage imageNamed:@"home_banner_placehorder.jpg"]];
    scrollView.localizationImageNamesGroup = @[@"notice_scroll_img_one.jpg",@"notice_scroll_img_two.jpg",@"notice_scroll_img_three.jpg",@"notice_scroll_img_four.jpg",@"notice_scroll_img_five.jpg",@"notice_scroll_img_six.jpg"];                       // 轮播图本地图片
    scrollView.scrollDirection             = UICollectionViewScrollDirectionHorizontal;; // 轮播图滚动方向（左右滚动）
    scrollView.autoScrollTimeInterval      = 3.0;                                        // 轮播图滚动时间间隔
    scrollView.contentMode = UIViewContentModeScaleAspectFit;                            // 设置图片模式
    [self.headerView addSubview:scrollView];
    
    // 初始化加载框
    self.progressHUD = [[MBProgressHUD alloc]initWithFrame:CGRectMake(0, 0, kSize_width, kSize_height)];
    [self.view addSubview:_progressHUD];
    
    // tableview代理
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"GPNoticeCell" bundle:nil] forCellReuseIdentifier:@"noticeCell"];
    
    // 添加刷新
    __weak typeof(self)weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        if (touch == 0 || touch == 1) {
            
            [weakSelf.tableView.mj_footer resetNoMoreData];  // 消除尾部没有更多数据状态
            weakSelf.page = 1;
            [weakSelf loadNetDataWithPage:[NSString stringWithFormat:@"%ld",weakSelf.page] rows:[NSString stringWithFormat:@"%ld",weakSelf.rows]];
            
        }else{
            
            [weakSelf.tableView.mj_footer resetNoMoreData];  // 消除尾部没有更多数据状态
            weakSelf.page = 1;
            [weakSelf loadMyMsgDataWithPage:[NSString stringWithFormat:@"%ld",weakSelf.page] rows:[NSString stringWithFormat:@"%ld",weakSelf.rows]];
        }
        
        
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        if (touch == 0 || touch == 1) {
            
            weakSelf.page++;
            [weakSelf loadNetDataWithPage:[NSString stringWithFormat:@"%ld",weakSelf.page] rows:[NSString stringWithFormat:@"%ld",weakSelf.rows]];
            if (weakSelf.page>5) {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }else{
            
            weakSelf.page++;
            [weakSelf loadMyMsgDataWithPage:[NSString stringWithFormat:@"%ld",weakSelf.page] rows:[NSString stringWithFormat:@"%ld",weakSelf.rows]];
            if (weakSelf.page>5) {
                
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                
            }
            
        }
    }];
    
    
}


#pragma mark - 加载数据
- (void)loadData{
    
    // 加载第一页公告数据
    [self loadNetDataWithPage:@"1" rows:@"10"];
}

#pragma mark - 获取notice读取状态
- (void)loadNoticeStautsWithString:(NSString *)idStr model:(GPNoticeModel *)model{
    
    NSArray *idArray = [UserDefaults searchNoticeStauts];
    NSLog(@"%@",idArray);
    if (idArray.count==0) {  // 未存储数据所有消息为未读
        
        // 未存储过的消息为未读
        [model setValue:@"0" forKey:@"status"];
    }else{
        // 判断idArray是否包含消息id
        if ([idArray containsObject:idStr]) {
            
//            NSLog(@"包含%@",idStr);
                // 已经存储过的消息为已读
                [model setValue:@"1" forKey:@"status"];
            }else{
//            NSLog(@"不包含%@",idStr);
                // 未存储过的消息为未读
                [model setValue:@"0" forKey:@"status"];
            }
        
        
    }
    
    
}

#pragma mark - 加载公告数据
- (void)loadNetDataWithPage:(NSString *)page rows:(NSString *)rows{
    
    [self.progressHUD showAnimated:YES];
    
    [self loadUserDefaultsData];
    
    NSString *noticeLoc = [NSString stringWithFormat:@"%@notice/1/allNotice",kBaseLocation];
    
    NSDictionary *paramDic = @{@"page":page,@"rows":rows};
    
    // 请求登陆接口
    __weak typeof(self)weakSelf = self;
    [AFNetManager requestPOSTWithURLStr:noticeLoc paramDic:paramDic token:self.token finish:^(id responserObject) {
        
        NSLog(@"|NOTICE-VC|success:%@",responserObject);
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        NSString *code = [NSString stringWithFormat:@"%@",[responserObject objectForKey:@"code"]];
        NSString *msg = [responserObject objectForKey:@"msg"];
        
        if (code.integerValue == 9200) {
            
//            [ToastView toastViewWithMessage:msg timer:3.0];
            
            if (page.integerValue == 1) {
                
                // 上拉刷新时清空数据
                [weakSelf.noticeDataArr removeAllObjects];
            }
            
            NSMutableArray *dataArr = [responserObject objectForKey:@"data"];
            
            for (NSDictionary *dataDic in dataArr) {
                
                GPNoticeModel *noticeModel = [GPNoticeModel new];
                
                [noticeModel setValuesForKeysWithDictionary:dataDic];
                
                [weakSelf loadNoticeStautsWithString:[NSString stringWithFormat:@"%@",noticeModel.id] model:noticeModel];
             
                [weakSelf.noticeDataArr addObject:noticeModel];
            }
            [self.tableView reloadData];
            
        }else{
            
            [ToastView toastViewWithMessage:msg timer:3.0];
        }
        
    } enError:^(NSError *error) {
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        [ToastView toastViewWithMessage:@"数据连接出错，请稍后再试" timer:3.0];
        
    }];
    
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

#pragma mark - 加载我的消息
- (void)loadMyMsgDataWithPage:(NSString *)page rows:(NSString *)rows{

    [self.progressHUD showAnimated:YES];
    
    [self loadUserDefaultsData];
    
    NSString *myMsgLoc = [NSString stringWithFormat:@"%@message/1/allMessage",kBaseLocation];
    
    NSDictionary *paramDic = @{@"page":page,@"rows":rows};
    
    // 请求登陆接口
    __weak typeof(self)weakSelf = self;
    [AFNetManager requestPOSTWithURLStr:myMsgLoc paramDic:paramDic token:self.token finish:^(id responserObject) {
        
        NSLog(@"|NOTICE-VC|-MSG|success:%@",responserObject);
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        NSString *code = [NSString stringWithFormat:@"%@",[responserObject objectForKey:@"code"]];
        NSString *msg = [responserObject objectForKey:@"msg"];
        
        if (code.integerValue == 9200) {
            
//            [ToastView toastViewWithMessage:msg timer:3.0];
            
            NSMutableArray *dataArr = [responserObject objectForKey:@"data"];
            
            for (NSDictionary *dataDic in dataArr) {
                
                GPNoticeModel *noticeModel = [GPNoticeModel new];
                
                [noticeModel setValuesForKeysWithDictionary:dataDic];
                
                [weakSelf.noticeDataArr addObject:noticeModel];
            }
            [self.tableView reloadData];
            
        }else{
            
            [ToastView toastViewWithMessage:msg timer:3.0];
        }
        
    } enError:^(NSError *error) {
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        [ToastView toastViewWithMessage:@"数据连接出错，请稍后再试" timer:3.0];
        
    }];
    
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

#pragma mark - 通知公告按钮
- (IBAction)noticeButton:(UIButton *)sender {
    
    touch = 1;
    
    [self.noticeDataArr removeAllObjects];
    
    // 点击按钮切换选中颜色，底部view颜色修改
    self.noticeBtnView.backgroundColor = [UIColor colorWithRed:35/255.0 green:198/255.0 blue:164/255.0 alpha:1];
     [self.noticeBtn setTitleColor:[UIColor colorWithRed:35/255.0 green:198/255.0 blue:164/255.0 alpha:1] forState:UIControlStateNormal];
    
    self.msgBtnView.backgroundColor = [UIColor whiteColor];
    [self.msgBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    // 加载第一页公告数据
    [self loadNetDataWithPage:@"1" rows:@"10"];
    
}

#pragma mark - 我的消息按钮
- (IBAction)messageButton:(UIButton *)sender {
    
    touch = 2;
    
    [self.noticeDataArr removeAllObjects];
    
    // 点击按钮切换选中颜色，底部view颜色修改
    self.noticeBtnView.backgroundColor = [UIColor whiteColor];
    [self.noticeBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    self.msgBtnView.backgroundColor = [UIColor colorWithRed:35/255.0 green:198/255.0 blue:164/255.0 alpha:1];
    [self.msgBtn setTitleColor:[UIColor colorWithRed:35/255.0 green:198/255.0 blue:164/255.0 alpha:1] forState:UIControlStateNormal];
    
    [self loadMyMsgDataWithPage:@"1" rows:@"10"];
    
}

#pragma mark - 轮播图点击事件
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
}


#pragma mark - 加载本地数据
- (void)loadUserDefaultsData{
    
    NSMutableDictionary *infoDic = [UserDefaults searchData];
    
    self.infoModel               = [[GPInfoModel alloc]init];
    
    [self.infoModel setValuesForKeysWithDictionary:infoDic];
    
    self.token   = self.infoModel.token;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.noticeDataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 38;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GPNoticeCell *noticeCell = [tableView dequeueReusableCellWithIdentifier:@"noticeCell" forIndexPath:indexPath];
    
    GPNoticeModel *noticeModel = self.noticeDataArr[indexPath.row];
    
    [noticeCell setDataWithModel:noticeModel];
    
    return noticeCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 取消cell点击后的状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GPNoticeModel *noticeModel = self.noticeDataArr[indexPath.row];
    
    // 点击后修改读取状态
    [noticeModel setValue:@"1" forKey:@"status"];
    
    // 存储读取状态
    [UserDefaults upDataNoticeStautsWithMsgId:[NSString stringWithFormat:@"%@",noticeModel.id]];
    
    [self.tableView reloadData];
    
    // 通知公告消息提醒
    if (touch == 0) {
        
        // 已读消息数量和所有公告消息数量相等时关闭小红点
        NSArray *locaArr = [UserDefaults searchNoticeStauts];
        if (locaArr.count == self.noticeDataArr.count) {
            
            // 隐藏小红点
            [self.tabBarController.tabBar hideBadgeOnItemIndex:2];
        }
    }
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    GPNoticeDetailViewController *noticeDetailVC = [storyboard instantiateViewControllerWithIdentifier:@"noticeDetailVC"];
    
    noticeDetailVC.titleStr = noticeModel.title;
    
    noticeDetailVC.timeStr = noticeModel.createDate;
    
    if (touch == 0 ||touch == 1) {  // 公告详情
        
        noticeDetailVC.contentStr = @"notice/1/noticeDetail";
        
    }else{   // 消息详情
        
        noticeDetailVC.contentStr = @"message/1/messageDetail";
    }
    
    noticeDetailVC.contentId = [NSString stringWithFormat:@"%@",noticeModel.id];
    
    noticeDetailVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:noticeDetailVC animated:YES];
}

#pragma mark - 懒加载
- (NSMutableArray *)noticeDataArr{
    
    if (!_noticeDataArr) {
        
        self.noticeDataArr = [NSMutableArray array];
    }
    return _noticeDataArr;
}

- (NSMutableArray *)myMsgDataArr{
    
    if (!_myMsgDataArr) {
        
        self.myMsgDataArr = [NSMutableArray array];
    }
    return _myMsgDataArr;
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
