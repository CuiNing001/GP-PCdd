//
//  GPRoomListViewController.m
//  GPLottery
//
//  Created by cc on 2018/3/21.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPRoomListViewController.h"
#import "GPRoonListModel.h"
#import "GPRoomListCell.h"
#import "GPRoomViewController.h"
#import "GPWalletModel.h"

@interface GPRoomListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) GPInfoModel        *infoModel;            // 本地数据
@property (strong, nonatomic) MBProgressHUD      *progressHUD;
@property (strong, nonatomic) NSString           *token;
@property (strong, nonatomic) NSMutableArray     *dataArray;
@property (strong, nonatomic) NSMutableArray     *imageArray;   // 背景图片数组
@property (strong, nonatomic) NSString           *userMoney;    // 用户余额

@end

@implementation GPRoomListViewController

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

- (void)loadData{
    
    self.title = @"房间列表";
    
    // 获取房间数据
    [self loadNetData];
    
    // 获取用户余额
    [self loadUserMoney];
    
    self.imageArray = @[@"room_cell_one",@"room_cell_two",@"room_cell_three",@"room_cell_four"].mutableCopy;

}

- (void)loadSubView{
    
    self.automaticallyAdjustsScrollViewInsets = false;
    
    // collection样式
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init]; // 初始化布局类
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];         // 滚动方向
    flowLayout.minimumLineSpacing = 25;        // 行间距
    flowLayout.minimumInteritemSpacing = 10;  // item间距
    flowLayout.itemSize = CGSizeMake((kSize_width-30)/2, 240);  // item大小
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10); // item位置
    self.collectionView.collectionViewLayout = flowLayout; // 绑定布局类
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    // 注册cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"GPRoomListCell" bundle:nil] forCellWithReuseIdentifier:@"roomListCell"];
    
    // 初始化加载框
    self.progressHUD = [[MBProgressHUD alloc]initWithFrame:CGRectMake(0, 0, kSize_width, kSize_height)];
    [self.view addSubview:_progressHUD];
    
    //延迟加载VersionBtn - 避免wimdow还没出现就往上加控件造成的crash
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.progressHUD showAnimated:YES];
    });
}

#pragma mark - 加载网络数据
- (void)loadNetData{
    
    [self.progressHUD showAnimated:YES];
    
    [self loadUserDefaultsData];
    
    NSString *playListLoc = [NSString stringWithFormat:@"%@/index/1/enterPlaying",kPlayBaseLocation];
    NSDictionary *paramDic = @{@"playingMerchantId":self.playID};
    
    // 请求登陆接口
    __weak typeof(self)weakSelf = self;
    [AFNetManager requestPOSTWithURLStr:playListLoc paramDic:paramDic token:self.token finish:^(id responserObject) {
        
        NSLog(@"|ROOMLIST-VC|success:%@",responserObject);
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        NSString *code = [NSString stringWithFormat:@"%@",[responserObject objectForKey:@"code"]];
        NSString *msg = [responserObject objectForKey:@"msg"];
        
        if (code.integerValue == 9200) {
            
//            [ToastView toastViewWithMessage:msg timer:3.0];
            
            NSArray *dataArray = [responserObject objectForKey:@"data"];
            
            for (NSDictionary *dataDic in dataArray) {
                
                GPRoonListModel *roomListModel = [GPRoonListModel new];
                
                [roomListModel setValuesForKeysWithDictionary:dataDic];
                
                [self.dataArray addObject:roomListModel];
            }
            
            [self.collectionView reloadData];
            
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

#pragma mark - 获取用户余额
- (void)loadUserMoney{
    
    [self.progressHUD showAnimated:YES];
    
    NSString *walletLoc = [NSString stringWithFormat:@"%@user/1/money",kBaseLocation];
    
    // 请求登陆接口
    __weak typeof(self)weakSelf = self;
    [AFNetManager requestPOSTWithURLStr:walletLoc paramDic:nil token:self.token finish:^(id responserObject) {
        
        NSLog(@"|MINE-VC-MONEY-REFSH|success:%@",responserObject);
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        GPRespondModel *respondModel = [GPRespondModel new];
        
        [respondModel setValuesForKeysWithDictionary:responserObject];
        
        if (respondModel.code.integerValue == 9200) {
            
            GPWalletModel *walletModel = [GPWalletModel new];
            
            [walletModel setValuesForKeysWithDictionary:respondModel.data];
            
            // 获取余额
            weakSelf.userMoney = walletModel.moneyNum;
            
        }else{
            
//            [ToastView toastViewWithMessage:respondModel.msg timer:2.5];
        }
    } enError:^(NSError *error) {
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        [ToastView toastViewWithMessage:@"数据连接出错，请稍后再试" timer:3.0];
        
    }];
    
}

#pragma mark - collection 代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
//    if (self.dataArray.count>0) {
//
//        return self.dataArray.count;
//    }
    
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    GPRoomListCell *roomListCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"roomListCell" forIndexPath:indexPath];
    
    NSString *image = self.imageArray[indexPath.row];
    
    roomListCell.bgImageView.image = [UIImage imageNamed:image];
    
    if (self.dataArray.count>0) {
        
        GPRoonListModel *roomListModel = self.dataArray[indexPath.row];
        
        [roomListCell setDataWithModel:roomListModel];
        
    }
    
    return roomListCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.dataArray.count>0) {
        
        if (self.userMoney.intValue<self.lowestMoneyNum.intValue) { // 用户余额小于房间最低金额
            
            NSString *msg = [NSString stringWithFormat:@"请保证余额不低于%@",self.lowestMoneyNum];
            
            [ToastView toastViewWithMessage:msg timer:3.0];
        }else{
            
            GPRoonListModel *roomListModel = self.dataArray[indexPath.row];
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            GPRoomViewController *roomVC = [storyboard instantiateViewControllerWithIdentifier:@"roomVC"];
            
            roomVC.roomIdStr = [NSString stringWithFormat:@"%@",roomListModel.roomId];
            
            roomVC.productIdStr = self.productIdStr;
            
            roomVC.playID = self.playID;
            
            [self.navigationController pushViewController:roomVC animated:YES];
        }
    }else{
        
        [ToastView toastViewWithMessage:@"数据加载中，请稍后再试" timer:3.0];
    }
    
    
    
//    // 加入聊天室
//    [JMSGChatRoom enterChatRoomWithRoomId:roomVC.roomIdStr completionHandler:^(id resultObject, NSError *error) {
//       
//        if (!error) {// 加入聊天室成功
//            
//            NSLog(@"|ROOMLIST-VC|-|ENTER-CHATROOM|-|SUCCESS|%@",resultObject);
//            
//            [self.navigationController pushViewController:roomVC animated:YES];
//            
//        }else{ // 加入聊天室失败
//            
//            NSLog(@"|ROOMLIST-VC|-|ENTER-CHATROOM|-|ERROR|%@",error);
//            
//            [ToastView toastViewWithMessage:@"加入聊天室失败，请稍后再试" timer:3.0];
//            
//            [JMSGChatRoom leaveChatRoomWithRoomId:roomVC.roomIdStr completionHandler:^(id resultObject, NSError *error) {
//                
//                if (!error) {
//                    
//                    NSLog(@"|ROOMLIST-VC|-|LEAVE-CHATROOM|-|SUCCESS|%@",resultObject);
//                    
//                }else{
//                    
//                    NSLog(@"|ROOMLIST-VC|-|LEAVE-CHATROOM|-|error|%@",error);
//                }
//            }];
//            
//        }
//        
//    }];

    
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
