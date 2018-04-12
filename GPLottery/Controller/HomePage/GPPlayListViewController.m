//
//  GPPlayListViewController.m
//  GPLottery
//
//  Created by cc on 2018/3/21.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPPlayListViewController.h"
#import "GPPlayListModel.h"
#import "GPPlayListCell.h"
#import "GPRoomListViewController.h"
#import "GPOddInstroctionViewController.h"

@interface GPPlayListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) GPInfoModel        *infoModel;            // 本地数据
@property (strong, nonatomic) MBProgressHUD      *progressHUD;
@property (strong, nonatomic) NSString           *token;
@property (strong, nonatomic) NSMutableArray     *dataArray;
@property (strong, nonatomic) NSString           *oddsExplain;  // 赔率说明
@property (strong, nonatomic) NSMutableArray     *imageArray;   // 背景图片数组

@end

@implementation GPPlayListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self loadData];
    [self loadSubView];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [self loadUserDefaultsData];
    
    // 未登陆状态返回首页界面
    if (![self.infoModel.islogin isEqualToString:@"1"]) {
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}

#pragma mark - 加载数据
- (void)loadData{
    
    self.title = self.productName;
    
    [self loadNetData];
    
    self.imageArray = @[@"room_list_one",@"room_list_two",@"room_list_three"].mutableCopy;
}

#pragma mark - 加载子控件
- (void)loadSubView{
    
    self.automaticallyAdjustsScrollViewInsets = false;
    
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    
    // tableView样式
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 初始化加载框
    self.progressHUD = [[MBProgressHUD alloc]initWithFrame:CGRectMake(0, 0, kSize_width, kSize_height)];
    [self.view addSubview:_progressHUD];
    
    //延迟加载VersionBtn - 避免wimdow还没出现就往上加控件造成的crash
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.progressHUD showAnimated:YES];
    });
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GPPlayListCell" bundle:nil] forCellReuseIdentifier:@"playListCell"];
}

#pragma mark - 加载网络数据
- (void)loadNetData{
    
    NSLog(@"|PLAYLIST-VC|ID=%@;NAME=%@",self.productID,self.productName);
    
    [self.progressHUD showAnimated:YES];
    
    [self loadUserDefaultsData];
    
    NSString *playListLoc = [NSString stringWithFormat:@"%@/index/1/playing",kPlayBaseLocation];
    NSDictionary *paramDic = @{@"productId":self.productID};
    
    // 请求登陆接口
    __weak typeof(self)weakSelf = self;
    [AFNetManager requestPOSTWithURLStr:playListLoc paramDic:paramDic token:self.token finish:^(id responserObject) {
        
        NSLog(@"|PLAYLISTVC-VC|success:%@",responserObject);
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        NSString *code = [NSString stringWithFormat:@"%@",[responserObject objectForKey:@"code"]];
        NSString *msg = [responserObject objectForKey:@"msg"];
        
        if (code.integerValue == 9200) {
            
//            [ToastView toastViewWithMessage:msg timer:3.0];
            
            NSArray *dataArray = [responserObject objectForKey:@"data"];
            
            for (NSDictionary *dataDic in dataArray) {
                
                GPPlayListModel *playListModel = [GPPlayListModel new];
                
                [playListModel setValuesForKeysWithDictionary:dataDic];
                
                [self.dataArray addObject:playListModel];
            }
            
            [self.tableView reloadData];
            
        }else if(code.integerValue == 9201){
            
            [self.progressHUD showAnimated:YES];
            
            // 未登陆状态返回主页
            UIAlertController *alert  = [UIAlertController alertControllerWithTitle:@"提醒"
                                                                            message:@"请先登陆"
                                                                     preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction     *action = [UIAlertAction actionWithTitle:@"确定"
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * _Nonnull action) {
                                                                   
                                                                   [JMSGUser logout:nil];
                                                                   // 删除本地数据
                                                                   [UserDefaults deleateData];
                                                                   [self.navigationController popViewControllerAnimated:YES];
                                                               }];
            
            [alert addAction:action];
            
            [self presentViewController:alert animated:YES completion:nil];
            
            
            
            
        }else{
            
            [ToastView toastViewWithMessage:msg timer:3.0];
        }
        
    } enError:^(NSError *error) {
        
        [weakSelf.progressHUD hideAnimated:YES];
        
//        [ToastView toastViewWithMessage:@"数据连接出错，请稍后再试" timer:3.0];
        // 数据出错
        UIAlertController *alert  = [UIAlertController alertControllerWithTitle:@"提醒"
                                                                        message:@"数据连接出错，请稍后再试"
                                                                 preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction     *action = [UIAlertAction actionWithTitle:@"确定"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * _Nonnull action) {
                                                               
                                                               [self.navigationController popViewControllerAnimated:YES];
                                                           }];
        
        [alert addAction:action];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }];
    
}

#pragma mark - 加载本地数据
- (void)loadUserDefaultsData{
    
    
    
    NSMutableDictionary *infoDic = [UserDefaults searchData];
    
    self.infoModel               = [[GPInfoModel alloc]init];
    
    [self.infoModel setValuesForKeysWithDictionary:infoDic];

    self.token   = self.infoModel.token;
    
}

#pragma mark - 赔率说明
- (void)loadOddInstrotionDataWithID:(NSString *)oddID{
    
    [self.progressHUD showAnimated:YES];
    
    [self loadUserDefaultsData];
    
    NSString *oddInstrotionLoc = [NSString stringWithFormat:@"%@playingMerchant/1/oddsDetail",kBaseLocation];
    
    NSDictionary *paramDic = @{@"id":oddID};
    
    // 请求登陆接口
    __weak typeof(self)weakSelf = self;
    [AFNetManager requestPOSTWithURLStr:oddInstrotionLoc paramDic:paramDic token:self.token finish:^(id responserObject) {
        
        NSLog(@"|PLAYLIST-VC-ODD|success:%@",responserObject);
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        GPRespondModel *respondModel = [GPRespondModel new];
        
        [respondModel setValuesForKeysWithDictionary:responserObject];
        
        if (respondModel.code.integerValue == 9200) {
            
//            [ToastView toastViewWithMessage:respondModel.msg timer:1.5];
            
            weakSelf.oddsExplain = [respondModel.data objectForKey:@"oddsExplain"];
            
            // 跳转赔率说明
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            GPOddInstroctionViewController *oddInstrotionVC = [storyboard instantiateViewControllerWithIdentifier:@"oddInstroctionVC"];
            oddInstrotionVC.webViewLoc = weakSelf.oddsExplain;
            [weakSelf.navigationController pushViewController:oddInstrotionVC animated:YES];
            
        }else{
            
            [ToastView toastViewWithMessage:respondModel.msg timer:2.5];
        }
        
    } enError:^(NSError *error) {
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        [ToastView toastViewWithMessage:@"数据连接出错，请稍后再试" timer:3.0];
        
    }];
}

#pragma mark - tableview 代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
//    if (self.dataArray.count>0) {
//
//        return self.dataArray.count;
//    }else{
    
         return 3;
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 180;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GPPlayListCell *playListCell = [tableView dequeueReusableCellWithIdentifier:@"playListCell" forIndexPath:indexPath];

    playListCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString *image = self.imageArray[indexPath.row];
    
    playListCell.bgImage.image = [UIImage imageNamed:image];
    
    if (self.dataArray.count>0) {
        
        GPPlayListModel *playListModel = self.dataArray[indexPath.row];
        
        [playListCell setDataWithModel:playListModel];
        
        playListCell.oddInstroctionBlock = ^{
            
            NSLog(@"======^^^玩法ID^^^=====%@",playListModel.id);
            
            [self loadOddInstrotionDataWithID:[NSString stringWithFormat:@"%@",playListModel.id]];
        };
    }
    
    return playListCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (self.dataArray.count>0) {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        GPRoomListViewController *roomListVC = [storyboard instantiateViewControllerWithIdentifier:@"roomListVC"];
        
        GPPlayListModel *playListModel = self.dataArray[indexPath.row];
        
        roomListVC.playID = [NSString stringWithFormat:@"%@",playListModel.id];
        
        roomListVC.productIdStr = self.productID;
        
        roomListVC.lowestMoneyNum = [NSString stringWithFormat:@"%@",playListModel.lowestMoneyNum];
        
        [self.navigationController pushViewController:roomListVC animated:YES];
    }else{
        
        [ToastView toastViewWithMessage:@"数据加载中，请稍后再试" timer:3.0];
    }
}

#pragma mark - 懒加载
- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)imageArray{
    
    if (!_imageArray) {
        
        self.imageArray = [NSMutableArray array];
    }
    return _imageArray;
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
