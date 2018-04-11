//
//  GPMyMessageViewController.m
//  GPLottery
//
//  Created by cc on 2018/4/7.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPMyMessageViewController.h"
#import "GPNoticeModel.h"
#import "GPNoticeCell.h"
#import "GPNoticeDetailViewController.h"

@interface GPMyMessageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *myMsgDataArr;    // 我的消息
@property (assign, nonatomic) NSInteger page; // 页码
@property (assign, nonatomic) NSInteger rows; // 加载条数
@property (strong, nonatomic) GPInfoModel *infoModel;            // 本地数据
@property (strong, nonatomic) MBProgressHUD *progressHUD;
@property (strong, nonatomic) NSString *token;


@end

@implementation GPMyMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadSubView];
    [self loadData];
}

- (void)loadData{
    
    self.title = @"我的消息";
    
    // 加载第一页公告数据
    [self loadMyMsgDataWithPage:@"1" rows:@"10"];
}

- (void)loadSubView{
    
    self.automaticallyAdjustsScrollViewInsets = false;
    
    // 初始化页码和条数
    self.page = 1;
    self.rows = 10;
    
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
        

        [weakSelf.tableView.mj_footer resetNoMoreData];  // 消除尾部没有更多数据状态
        weakSelf.page = 1;
        [weakSelf loadMyMsgDataWithPage:[NSString stringWithFormat:@"%ld",weakSelf.page] rows:[NSString stringWithFormat:@"%ld",weakSelf.rows]];

        
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        weakSelf.page++;
        [weakSelf loadMyMsgDataWithPage:[NSString stringWithFormat:@"%ld",weakSelf.page] rows:[NSString stringWithFormat:@"%ld",weakSelf.rows]];
        if (weakSelf.page>5) {
            
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            
        }
     
    }];
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
            
            if (page.integerValue == 1) {
                
                // 上拉刷新时清空数据
                [weakSelf.myMsgDataArr removeAllObjects];
            }
            
            //            [ToastView toastViewWithMessage:msg timer:3.0];
            
            NSMutableArray *dataArr = [responserObject objectForKey:@"data"];
            
            for (NSDictionary *dataDic in dataArr) {
                
                GPNoticeModel *noticeModel = [GPNoticeModel new];
                
                [noticeModel setValuesForKeysWithDictionary:dataDic];
                
                [weakSelf.myMsgDataArr addObject:noticeModel];
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

#pragma mark - 加载本地数据
- (void)loadUserDefaultsData{
    
    NSMutableDictionary *infoDic = [UserDefaults searchData];
    
    self.infoModel               = [[GPInfoModel alloc]init];
    
    [self.infoModel setValuesForKeysWithDictionary:infoDic];
    
    self.token   = self.infoModel.token;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.myMsgDataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 38;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GPNoticeCell *noticeCell = [tableView dequeueReusableCellWithIdentifier:@"noticeCell" forIndexPath:indexPath];
    
    GPNoticeModel *noticeModel = self.myMsgDataArr[indexPath.row];
    
    [noticeCell setDataWithModel:noticeModel];
    
    return noticeCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 取消cell点击后的状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GPNoticeModel *noticeModel = self.myMsgDataArr[indexPath.row];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    GPNoticeDetailViewController *noticeDetailVC = [storyboard instantiateViewControllerWithIdentifier:@"noticeDetailVC"];
    
    noticeDetailVC.titleStr = noticeModel.title;
    
    noticeDetailVC.timeStr = noticeModel.createDate;
    
    noticeDetailVC.contentStr = @"message/1/messageDetail";
    
    noticeDetailVC.contentId = [NSString stringWithFormat:@"%@",noticeModel.id];
    
    noticeDetailVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:noticeDetailVC animated:YES];
}

#pragma mark - 懒加载
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
