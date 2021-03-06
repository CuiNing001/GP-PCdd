//
//  GPRoomViewController.m
//  GPLottery
//
//  Created by cc on 2018/3/22.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPRoomViewController.h"
#import "sys/utsname.h"
#import "GPRoomBetView.h"
#import "GPOddsInfoModel.h"
#import "GPEnterRoomInfoModel.h"
#import "GPMsgEnterRoomCell.h"
#import "GPMessageModel.h"
#import "GPMsgSystemCell.h"
#import "GPMsgReceiveCell.h"
#import "GPMsgSenderCell.h"
#import "GPRoomHistoryModel.h"
#import "GPRoomHistoryCell.h"
#import "GPRoomCopyBetView.h"
#import "GPOddInstroctionViewController.h"
#import "GPRoomItemAlertView.h"
#import "GPGameInstroctionViewController.h"
#import "GPTrendViewController.h"
#import "GPGameListViewController.h"
#import "GPWalletModel.h"
#import "GPCoverView.h"
#import "GPMsgScoreCell.h"
#import "GPRoomPlayingRecordViewController.h"
#import "GPRefreshModel.h"
#import "GPMsgNoticeCell.h"
#import "GPBetDetailModel.h"

static int isShow = 0; // 历史开奖记录view
static int minute;     // 倒计时分钟
static int second;     // 倒计时秒
static int timerSecond;  // 倒计时秒数
static int itemAlertTouch = 0; // 更多按钮点击次数
static int scoreViewX; // 分数初始X值
static int scoreViewY; // 分数初始Y值
static int mathBetMoney;  // 当期投注输赢金额

@interface GPRoomViewController ()<UITextViewDelegate,JMSGConversationDelegate,JMessageDelegate,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chatViewBottom;  // chatview距离底部的距离
@property (weak, nonatomic) IBOutlet UILabel *topScoreLab;  // 开奖输赢金额
@property (weak, nonatomic) IBOutlet UIView *scoreView;     // 开奖输赢金额view


@property (weak, nonatomic) IBOutlet UILabel *expectLab;  // 当前期数
@property (weak, nonatomic) IBOutlet UILabel *timerLab;   // 倒计时
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;   // 账户余额
@property (weak, nonatomic) IBOutlet UILabel *historyExpectLab;    // 开奖记录期数
@property (weak, nonatomic) IBOutlet UILabel *historyCodeLab;      // 开奖记录
@property (weak, nonatomic) IBOutlet UILabel *historyCodeTextLab;  // 开奖记录（大小单双）
@property (weak, nonatomic) IBOutlet UIButton *historyMoreBtn;     // 开奖记录更多按钮
@property (weak, nonatomic) IBOutlet UITextView *inputTextView;    // 输入框
@property (weak, nonatomic) IBOutlet UIView *inputView;            // 底部输入view
@property (weak, nonatomic) IBOutlet UITableView *tableView;       // 聊天详情列表
@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;  // 取消（回收键盘）
@property (weak, nonatomic) IBOutlet UIView *chatView;     // 聊天view（列表+输入框view）
@property (assign, nonatomic) CGFloat keyBoardHeight;      // 键盘高度
@property (strong, nonatomic) GPRoomBetView *roomBetView;  // 下注view
@property (strong, nonatomic) GPInfoModel *infoModel;      // 本地数据
@property (strong, nonatomic) MBProgressHUD *progressHUD;
@property (strong, nonatomic) NSString *token;
@property (strong, nonatomic) GPEnterRoomInfoModel *roomInfoModel;  // 房间数据
@property (strong, nonatomic) NSMutableArray *pageOneDataArray;     // page1数据源
@property (strong, nonatomic) NSMutableArray *pageTwoDataArray;     // page2数据源
@property (strong, nonatomic) NSMutableArray *pageThreeDataArray;   // page3数据源

@property (strong, nonatomic) NSString *betAmountStr;  // 下注金额
@property (strong, nonatomic) NSString *playingType;   // 下注类型（大小单双）
@property (strong, nonatomic) NSString *playingId;     // 玩法id
@property (strong, nonatomic) NSString *minAmount;     // 最小下注金额
@property (strong, nonatomic) NSString *maxAmount;     // 最大下注金额
@property (strong, nonatomic) NSMutableArray *receiveMessageArray;  // 接收聊天室消息

@property (weak, nonatomic) IBOutlet UIView *historyView;            // 往期记录
@property (weak, nonatomic) IBOutlet UITableView *historyTableView;  // 往期记录
@property (strong, nonatomic) NSMutableArray *historyDataArray;      // 往期记录

@property (strong, nonatomic) NSString *openTime;   // 倒计时剩余时间
@property (strong, nonatomic) NSTimer *enterTimer;  // 进入房间定时器
@property (strong, nonatomic) NSTimer *normolTimer; // 房间内定时器

@property (strong, nonatomic) GPRoomCopyBetView *betCopyView;  // 跟投页面

// right navigation bar
@property (strong, nonatomic) UIView *itemView;
@property (strong, nonatomic) UIButton *itemBtn;

@property (strong, nonatomic) NSString           *oddsExplain;  // 赔率说明
@property (strong, nonatomic) GPRoomItemAlertView *itemAlertView; //

@property (strong, nonatomic) GPCoverView *coverView;  // 导航遮罩层
@property (strong, nonatomic) NSString *roomCoverCount; // 首页lunch次数
@property (strong, nonatomic) NSString *betCoverCount; // 首页lunch次数

@property (strong, nonatomic) NSString *msgMinAmount;  // 最小下注金额(进入房间提醒消息)
@property (strong, nonatomic) NSString *msgMaxAmount;  // 最大下注金额(进入房间提醒消息)
@property (strong, nonatomic) NSString *msgRoundBetAmount; // 总注(进入房间提醒消息)

@property (strong, nonatomic) NSString *flowBetViewExcept;  // 跟投期数

@end

@implementation GPRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"|ROOMVC|roomID:%@==productid:%@",_roomIdStr,_productIdStr);
    
    [self loadSubView];
    
    if (self.productIdStr.integerValue == 1) {
        
        self.title = @"北京28";
    }else{
        
        self.title = @"加拿大28";
    }
    
    NSLog(@"|ROOM-VC-^^^^^^玩法ID(1:北京28、2:加拿大28)^^^^^^|%@",self.productIdStr);
}

#pragma mark - 自定义navigation bar item
- (void)customNavigationBarItem{
    
    // 导航栏右侧按钮
    self.itemView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 50)];
    
    self.itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _itemBtn.frame = CGRectMake(0, 10, 40, 30);
    
    [_itemBtn setImage:[UIImage imageNamed:@"service_item"] forState:UIControlStateNormal];
    
    [_itemBtn addTarget:self action:@selector(turnToService:) forControlEvents:UIControlEventTouchUpInside];
    
    [_itemBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    
    [_itemView addSubview:_itemBtn];
    
    UIButton *webBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    webBtn.frame = CGRectMake(40, 10, 40, 30);
    
    [webBtn setImage:[UIImage imageNamed:@"more_item"] forState:UIControlStateNormal];
    
    [webBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    
    [webBtn addTarget:self action:@selector(turnToChooseView:) forControlEvents:UIControlEventTouchUpInside];
    
    [_itemView addSubview:webBtn];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:_itemView];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
}

#pragma mark - 跳转客服
- (void)turnToService:(UIBarButtonItem *)sender{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    GPServiceViewController *serviceVC = [storyboard instantiateViewControllerWithIdentifier:@"serviceVC"];

    serviceVC.hidesBottomBarWhenPushed = YES;

    [self presentViewController:serviceVC animated:YES completion:nil];
}

#pragma mark - 顶部走势图
- (void)turnToChooseView:(UIBarButtonItem *)sender{
    
    itemAlertTouch++;
    
    if (itemAlertTouch%2 == 0) {
        
        self.itemAlertView.hidden = YES;
    }else{
        
        self.itemAlertView.hidden = NO;
    }
    
}



#pragma mark - 页面即将出现进入聊天室
- (void)viewWillAppear:(BOOL)animated{
    
    
//    [self.progressHUD showAnimated:YES];
    
    [self loadUserDefaultsData];
    
    // 未登陆状态返回首页界面
    if (![self.infoModel.islogin isEqualToString:@"1"]) {
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        
//        [self enterChatRoom];
        // 加入聊天室（不判定是否加入成功）
        [self enterRoom];
    }
}

#pragma mark - 进入房间（无判定）
- (void)enterRoom{
    
    [JMSGChatRoom enterChatRoomWithRoomId:self.roomIdStr completionHandler:nil];
    
    // 获取大厅数据
    [self loadOddsContentData];
    
    if (self.receiveMessageArray.count>0) {
        
        [self.receiveMessageArray removeLastObject];
    }
}

#pragma mark - 进入房间
- (void)enterChatRoom{
    [self.progressHUD showAnimated:YES];
    // 加入聊天室
    __weak typeof(self)weakSelf = self;
    [JMSGChatRoom enterChatRoomWithRoomId:self.roomIdStr completionHandler:^(id resultObject, NSError *error) {
        
        if (!error) {// 加入聊天室成功
            
            NSLog(@"|ROOMLIST-VC|-|ENTER-CHATROOM|-|SUCCESS|%@",resultObject);
            
//            [ToastView toastViewWithMessage:@"加入房间成功" timer:3.0];
            
            // 获取数据
            [weakSelf loadOddsContentData];
            
//            if (self.receiveMessageArray.count>0) {
//
//                [self.receiveMessageArray removeLastObject];
//            }
            
        }else{ // 加入聊天室失败
            
            NSLog(@"|ROOMLIST-VC|-|ENTER-CHATROOM|-|ERROR|%@",error);
//            [self.progressHUD hideAnimated:YES];
//            [ToastView toastViewWithMessage:@"加入房间失败，请稍后再试" timer:3.0];
            
            
            
            
        }
        
    }];
}

#pragma mark - 关闭页面退出聊天室
- (void)viewDidDisappear:(BOOL)animated{

//    // 退出聊天室
//    [JMSGChatRoom leaveChatRoomWithRoomId:self.roomIdStr completionHandler:^(id resultObject, NSError *error) {
//
//        if (!error) {
//
//            NSLog(@"|ROOM-VC|-|LEAVE-CHATROOM|-|SUCCESS|%@",resultObject);
//
//        }else{
//
//            NSLog(@"|ROOM-VC|-|LEAVE-CHATROOM|-|error|%@",error);
//        }
//    }];

    // 销毁定时器
    [self.enterTimer invalidate];
    self.enterTimer = nil;

    // 清除聊天数据
//    [self.receiveMessageArray removeAllObjects];
}

#pragma mark - 加载子控件
- (void)loadSubView{
    
    // 分数label初始定位
    scoreViewX = self.scoreView.frame.origin.x;
    scoreViewY = self.scoreView.frame.origin.y;
    
    [self customNavigationBarItem];
    
    self.scoreView.hidden = YES;
    
    // 历史记录tableview
    self.historyTableView.delegate = self;
    self.historyTableView.dataSource = self;
    self.historyTableView.tag = 1200;
    [self.historyTableView registerNib:[UINib nibWithNibName:@"GPRoomHistoryCell" bundle:nil] forCellReuseIdentifier:@"historyCell"];
    
    // 添加极光监听事件通知
    [JMessage addDelegate:self withConversation:nil];
    
    // tableView代理
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tag = 1201;
    
    // tableView样式
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    // 注册进入房间cell
    [self.tableView registerNib:[UINib nibWithNibName:@"GPMsgEnterRoomCell" bundle:nil] forCellReuseIdentifier:@"enterRoomCell"];
    
    // 注册接收方cell
    [self.tableView registerNib:[UINib nibWithNibName:@"GPMsgReceiveCell" bundle:nil] forCellReuseIdentifier:@"receiveCell"];
    
    // 注册系统消息cell
    [self.tableView registerNib:[UINib nibWithNibName:@"GPMsgSystemCell" bundle:nil] forCellReuseIdentifier:@"systemCell"];
    
    // 注册接收方cell
    [self.tableView registerNib:[UINib nibWithNibName:@"GPMsgSenderCell" bundle:nil] forCellReuseIdentifier:@"secderCell"];
    
    // 开奖消息cell
    [self.tableView registerNib:[UINib nibWithNibName:@"GPMsgScoreCell" bundle:nil] forCellReuseIdentifier:@"scoreCell"];
    
    // 倒计时60秒提醒cell
    [self.tableView registerNib:[UINib nibWithNibName:@"GPMsgNoticeCell" bundle:nil] forCellReuseIdentifier:@"noticeCell"];
    
    // 初始化加载框
    self.progressHUD = [[MBProgressHUD alloc]initWithFrame:CGRectMake(0, 0, kSize_width, kSize_height)];
    [self.view addSubview:_progressHUD];
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
  
    self.inputTextView.delegate = self;
    
    // **********添加betView*********** //
    self.roomBetView = [[GPRoomBetView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:self.roomBetView];
    self.roomBetView.hidden = YES;
    
    // bet view 方法
    __weak typeof(self)weakSelf = self;
    // 关闭betview
    self.roomBetView.dissmissBtnBlock = ^{
      
        [weakSelf.roomBetView.betTextField resignFirstResponder];
        weakSelf.roomBetView.betBottom.constant = 10;
        weakSelf.roomBetView.hidden = YES;
        
        [weakSelf.inputTextView resignFirstResponder];
        weakSelf.chatViewBottom.constant = 0;
    };
    
    
    // 右切换页面
    self.roomBetView.pageRightBtnBlock = ^{
      
        NSLog(@"右切换页面");
    };
    
    // 左切换页面
    self.roomBetView.pageLeftBtnBlock = ^{
      
        NSLog(@"左切换页面");
    };
    
    // 双倍投注
    self.roomBetView.doubleBetBtnBlock = ^{
      
        NSLog(@"双倍投注");
        if (weakSelf.minAmount==nil) {  // minAmount 为空
            
            weakSelf.roomBetView.betTextField.text = @"0";
            
            [ToastView toastViewWithMessage:@"请先选择下注类型" timer:3.0];
        }else{
            
            weakSelf.roomBetView.betTextField.text = [NSString stringWithFormat:@"%ld",weakSelf.roomBetView.betTextField.text.integerValue*2];
        }
        
    };
    
    // 最小下注
    self.roomBetView.minBetBtnBlock = ^{
      
        NSLog(@"最小下注");
        
        if (weakSelf.minAmount==nil) {  // minAmount 为空
            
            weakSelf.roomBetView.betTextField.text = @"0";
            
            [ToastView toastViewWithMessage:@"请先选择下注类型" timer:3.0];
        }else{
            
            weakSelf.roomBetView.betTextField.text = [NSString stringWithFormat:@"%@",weakSelf.minAmount];
        }
    };
    
    // 赔率说明
    self.roomBetView.oddsBtnBlock = ^{
      
        NSLog(@"赔率说明");
        
        [weakSelf loadOddInstrotionDataWithID:weakSelf.playID];
    };
    
    // item点击事件
    self.roomBetView.selecetItemBlock = ^(NSString *playId,NSString *minAmount,NSString *maxAmount,NSString *playingType) {
      
        weakSelf.playingId = playId;    // 玩法id
        weakSelf.minAmount = minAmount; // 最小下注金额
        weakSelf.maxAmount = maxAmount; // 最大下注金额
        weakSelf.playingType = playingType;
    };
    
    // 确定投注
    self.roomBetView.betBtnBlock = ^(NSString *betAmountStr){
        
        weakSelf.betAmountStr = betAmountStr;  // 下注金额
        
        if (betAmountStr.integerValue>0) {
            
            if (betAmountStr.integerValue<weakSelf.minAmount.integerValue) {
                
                [ToastView toastViewWithMessage:@"不能小于最下下注金额" timer:3.0];
            }else{
                
                if (betAmountStr.integerValue>weakSelf.maxAmount.integerValue) {
                    
                    [ToastView toastViewWithMessage:@"超过最大下注金额" timer:3.0];
                }else{
                    
                    [weakSelf makeSureBetWithAmount:weakSelf.betAmountStr];
                }
            }
        }else{
            
            
            [ToastView toastViewWithMessage:@"请选择投注类型并填写下注金额" timer:3.0];
        }

    };
    
    // **********添加跟投页面*********** //
    self.betCopyView = [[GPRoomCopyBetView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:self.betCopyView];
    self.betCopyView.hidden = YES;
    
    // 确定跟投
    self.betCopyView.makeSuerBtnBlock = ^{
        
        if ([weakSelf.timerLab.text isEqualToString:@"封盘中"]) {
            // 判断当前是否封盘
            [ToastView toastViewWithMessage:@"当期已封盘，请重新投注" timer:3.0];
            
        }else{
            // 判断当前期数是否过期
            if (weakSelf.flowBetViewExcept.integerValue == self.expectLab.text.integerValue) {
                
                [weakSelf makeSureBetWithAmount:weakSelf.betAmountStr];
                
                weakSelf.betCopyView.hidden = YES;
            }else{
                
                [ToastView toastViewWithMessage:@"当前期数已过期" timer:3.0];
            }
        }
    };
    
    // 取消跟投
    self.betCopyView.cancelBtnBlock = ^{
      
        weakSelf.betCopyView.hidden = YES;
    };
    
    // *************顶部弹出框view**********//
    self.itemAlertView = [[GPRoomItemAlertView alloc]initWithFrame:CGRectMake(kSize_width-120, 84, 120, 120)];
    [self.view addSubview:self.itemAlertView];
    self.itemAlertView.hidden = YES;
    
    // 投注记录
    self.itemAlertView.recordBtnBlock = ^{
        
        NSLog(@"投注记录");
        
        itemAlertTouch++;
        weakSelf.itemAlertView.hidden = YES;
        
        [weakSelf turnToHistoryVC];
    };
    
    // 玩法说明
    self.itemAlertView.insBtnBlock = ^{
        NSLog(@"玩法说明");
        
        itemAlertTouch++;
        weakSelf.itemAlertView.hidden = YES;
        
        NSDictionary *paramDic = @{@"id":weakSelf.productIdStr};
        
        [weakSelf loadProductDetailDataWithParamDic:paramDic productName:weakSelf.title];
    };
    
    // 走势图
    self.itemAlertView.trendBtnBlock = ^{
        NSLog(@"走势图");
        
        itemAlertTouch++;
        weakSelf.itemAlertView.hidden = YES;
        
        [weakSelf turnToTrendVC];
    };
    
    // ^^^^^^^^^^^^^遮罩层^^^^^^^^^^
    [self loadUserDefaultsData];
    self.coverView = [[GPCoverView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [[UIApplication sharedApplication].keyWindow addSubview:self.coverView];
    self.coverView.coverImageView.image = [UIImage imageNamed:@"game_lunch"];
    if (self.roomCoverCount.integerValue == 1) {
        
        self.coverView.hidden = NO;
    }else{
        self.coverView.hidden = YES;
    }
    
    self.coverView.dissMissBlock = ^{
        
        weakSelf.coverView.hidden = YES;
        [UserDefaults upDataWithRoomLunchCount:@"2"];
    };
}

// 键盘出现时修改chatView底部约束
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    self.keyBoardHeight = keyboardRect.size.height;

    // 调整chatview高度
    [UIView animateWithDuration:1 animations:^{
        
        // 获取设备型号
        struct utsname systemInfo;
        uname(&systemInfo);
        NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
        
        if ([deviceString isEqualToString:@"iPhone10,3"]) {
            
            // iphone X 需减掉底部安全区高度34
            self.chatViewBottom.constant = keyboardRect.size.height-34;
        }else{
            
            self.chatViewBottom.constant = keyboardRect.size.height;
        }
        
        NSLog(@"%@",deviceString);
        
    }];

}

#pragma mark - 开奖历史记录
- (IBAction)showHistoryView:(UIButton *)sender {
    
    isShow++;
    
    if (isShow%2 == 0) {  // 偶数隐藏
        
        CATransition *transition = [CATransition animation];
        transition.duration      = 0.1;
        transition.type          = kCATransitionMoveIn;
        transition.subtype       = kCATransitionFromTop;
        self.historyView.hidden  = YES;
        [self.historyView.layer addAnimation:transition forKey:@"animation"];
        
    }else{  // 奇数
        
        CATransition *transition = [CATransition animation];
        transition.duration      = 0.1;
        transition.type          = kCATransitionFade;
        transition.subtype       = kCATransitionFromBottom;
        self.historyView.hidden  = NO;
        [self.historyView.layer addAnimation:transition forKey:@"animation"];
    }
}

#pragma mark - 回收键盘
- (IBAction)dissmissKeyBoardButton:(UIButton *)sender {
    
    [self.inputTextView resignFirstResponder];
    
    // 取消键盘后还原view的frame
    [UIView animateWithDuration:1 animations:^{
        
        self.chatViewBottom.constant = 0;
        
        self.roomBetView.betBottom.constant = 10;
    }];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        
        // 取消键盘后还原view的frame
        [UIView animateWithDuration:0.5 animations:^{

            self.chatViewBottom.constant = 0;
            self.roomBetView.betBottom.constant = 10;
        }];
        return NO;
    }
    return YES;
}

#pragma mark - 加载本地数据
- (void)loadUserDefaultsData{
    
    NSMutableDictionary *infoDic = [UserDefaults searchData];
    
    self.infoModel               = [[GPInfoModel alloc]init];
    
    [self.infoModel setValuesForKeysWithDictionary:infoDic];
    
    self.token   = self.infoModel.token;
    
    self.roomCoverCount = self.infoModel.roomLunchCount;
    
    self.betCoverCount  = self.infoModel.betLunchCount;
    
    NSLog(@"===:%@",self.token);
    
}


#pragma mark - 投注按钮
- (IBAction)betButton:(UIButton *)sender {
    
    if ([self.timerLab.text isEqualToString:@"封盘中"]) {
        
        [ToastView toastViewWithMessage:@"封盘中,暂停下注..." timer:3.0];
        
    }else if ([self.timerLab.text isEqualToString:@"关闭算账"]){
        
        [ToastView toastViewWithMessage:@"关闭算账,暂停下注..." timer:3.0];
    }else{
        
        [UIView animateWithDuration:1 animations:^{
            
            self.roomBetView.hidden = NO;
            
            if (self.betCoverCount.integerValue == 1) {
                
                self.coverView.hidden = NO;
                self.coverView.coverImageView.image = [UIImage imageNamed:@"game_bet_lunch"];
                [UserDefaults upDataWithBetLunchCount:@"2"];
            }
            
        }];
    }
}

#pragma mark - 获取游戏大厅数据
- (void)loadOddsContentData{
    
    [self.progressHUD showAnimated:YES];
    
    [self loadUserDefaultsData];
    
    NSString *enterRoomLoc = [NSString stringWithFormat:@"%@index/1/enterRoom",kPlayBaseLocation];
    
    NSDictionary *paramDic = @{@"roomId":self.roomIdStr};
    
    // 请求登陆接口
    __weak typeof(self)weakSelf = self;
    [AFNetManager requestPOSTWithURLStr:enterRoomLoc paramDic:paramDic token:self.token finish:^(id responserObject) {
        
        NSLog(@"|ROOM-VC|success:%@",responserObject);
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        NSString *code = [NSString stringWithFormat:@"%@",[responserObject objectForKey:@"code"]];
        NSString *msg = [responserObject objectForKey:@"msg"];
        
        if (code.integerValue == 9200) {
            
//            [ToastView toastViewWithMessage:msg timer:3.0];
            
            // 获取房间内数据
            NSDictionary *dataDic = [responserObject objectForKey:@"data"];
            
            self.roomInfoModel = [GPEnterRoomInfoModel new];
            
            [self.roomInfoModel setValuesForKeysWithDictionary:dataDic];
            
            // 房间数据赋值
            [self updataForRoomContent];
            
            // 投注数据赋值
            [self updataForBetContent];
            
        }else{
            
//            [ToastView toastViewWithMessage:msg timer:3.0];
            
            // 数据出错
            UIAlertController *alert  = [UIAlertController alertControllerWithTitle:@"提醒"
                                                                            message:msg
                                                                     preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction     *action = [UIAlertAction actionWithTitle:@"确定"
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * _Nonnull action) {
                                                                   
                                                                   [self.navigationController popToRootViewControllerAnimated:YES];
                                                               }];
            
            [alert addAction:action];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
        [weakSelf.historyTableView reloadData];
        // 刷新数据
        [weakSelf.roomBetView.leftCollectionView reloadData];
        [weakSelf.roomBetView.middleCollectionView reloadData];
        [weakSelf.roomBetView.rightCollectionView reloadData];
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
                                                               
                                                               [self.navigationController popToRootViewControllerAnimated:YES];
                                                           }];
        
        [alert addAction:action];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        NSLog(@"%@",error);
        
    }];
}

#pragma mark - 房间数据赋值
- (void)updataForRoomContent{
    
    self.moneyLab.text = [NSString stringWithFormat:@"%@.00",self.roomInfoModel.moneyNum];  // 用户元宝数
    NSDictionary *comingDic = [NSDictionary dictionaryWithDictionary:self.roomInfoModel.coming];  // 下期数据
    self.expectLab.text = [NSString stringWithFormat:@"%@",[comingDic objectForKey:@"expect"]]; // 即将开奖期数
    self.openTime = [NSString stringWithFormat:@"%@",[comingDic objectForKey:@"openTime"]];  // 倒计时秒数
    NSString *endTime = [NSString stringWithFormat:@"%@",[comingDic objectForKey:@"forbidBetAheadTime"]]; // 封盘时间
    
    NSLog(@"|ROOM-VC|-|openTime|:%@-|endTime|:%@",_openTime,endTime);
    
//    // 设置倒计时
//    if (self.openTime.intValue>60) {
//        minute = self.openTime.intValue/60;   // 获取分钟数
//        second = self.openTime.intValue%60;   // 获取秒数
//    }else{
//        minute = 0;
//        second = self.openTime.intValue;
//    }
    
    // 设置倒计时时间
    timerSecond = self.openTime.intValue;
    
    NSLog(@"|ENTERROOM-OPENTIME|^^^^^^opentime^^^^^|%@|^^^^^^^minute^^^^^^^|%d|^^^^^^second^^^^^^^|%d",self.openTime,minute,second);
    
    self.enterTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(countdown) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:self.enterTimer forMode:NSDefaultRunLoopMode];
  
    // 设置开奖历史数据
    NSMutableArray *historyArr = [NSMutableArray arrayWithArray:self.roomInfoModel.history];
    
    if (self.historyDataArray.count>0) {
        
        [self.historyDataArray removeAllObjects];
    }
    
    for (NSDictionary *codeDic in historyArr) {
        
        GPRoomHistoryModel *historyModel = [GPRoomHistoryModel new];
        
        [historyModel setValuesForKeysWithDictionary:codeDic];
        
        [self.historyDataArray addObject:historyModel];
    }
    
    GPRoomHistoryModel *expectModel = self.historyDataArray.firstObject;
    
    if ((self.expectLab.text.intValue - expectModel.expect.intValue) == 2) {
        
        self.historyExpectLab.text      = [NSString stringWithFormat:@"第%d期",self.expectLab.text.intValue-1];
        self.historyCodeLab.text        = [NSString stringWithFormat:@"?+?+?=?"];
        self.historyCodeTextLab.text    = [NSString stringWithFormat:@"(类型)"];
    }else{
        
        self.historyExpectLab.text      = expectModel.expect;
        self.historyCodeLab.text        = expectModel.code;
        self.historyCodeTextLab.text    = expectModel.codeText;
    }
    
    
    
    if (self.productIdStr.integerValue == 1) { // 北京28
        
        
        
        if (timerSecond>30) {
            
            // 获取房间最小最大下注金额发送提醒消息
            [self roomMinAndMaxAmount];
        }
        
    }else if (self.productIdStr.integerValue == 2){ // 加拿大28
    
        
        if (timerSecond>15) {
            
            // 获取房间最小最大下注金额发送提醒消息
            [self roomMinAndMaxAmount];
        }
    }
}

#pragma mark - 倒计时结束刷新数据
- (void)refreshEnterRoomAgain{
    
    NSString *refreshLoc = [NSString stringWithFormat:@"%@/index/1/enterRoomAgain",kPlayBaseLocation];
    NSDictionary *paramDic = @{@"roomId":self.roomIdStr};
    
    __weak typeof(self)weakSelf = self;
    [AFNetManager requestPOSTWithURLStr:refreshLoc paramDic:paramDic token:self.token finish:^(id responserObject) {
        
        NSLog(@"|INDEX-VC-REFRESH|%@",responserObject);
        
        NSString *code = [NSString stringWithFormat:@"%@",[responserObject objectForKey:@"code"]];
        NSString *msg = [responserObject objectForKey:@"msg"];
        
        if (code.integerValue == 9200) {
            
            NSDictionary *dataDic = [responserObject objectForKey:@"data"];
            GPRefreshModel *refreshModel = [GPRefreshModel new];
            [refreshModel setValuesForKeysWithDictionary:dataDic];
            
            // 刷新页面数据
            if (refreshModel.isCloseAccount.integerValue == 0) {
                
                // 刷新倒计时时间
                timerSecond = refreshModel.openTime.intValue;
                // 封盘结束修改开奖期数
                weakSelf.expectLab.text = [NSString stringWithFormat:@"%@",refreshModel.expect];
                weakSelf.historyExpectLab.text = [NSString stringWithFormat:@"%d",refreshModel.expect.intValue-1];
                weakSelf.historyCodeLab.text = [NSString stringWithFormat:@"?+?+?"];
                weakSelf.historyCodeTextLab.text = [NSString stringWithFormat:@"(类型)"];
                
                if (timerSecond>0) {
                    // 发送开盘提醒消息
                    [weakSelf roomMinAndMaxAmount];
                }
            }else{
                
                [weakSelf.enterTimer setFireDate:[NSDate distantFuture]]; // 封盘关闭定时器
                weakSelf.timerLab.text = @"关闭算账";
            }
            
        }else{
            
            NSLog(@"|INDEX-VC-REFRESH-CODE|%@",msg);
        }
        
    } enError:^(NSError *error) {
        
    }];
    
}

#pragma mark - 获取房间最小下注和最大下注金额
- (void)roomMinAndMaxAmount{
    
    [self.progressHUD showAnimated:YES];
    
    [self loadUserDefaultsData];
    
    NSString *betLowstMoneyLoc = [NSString stringWithFormat:@"%@/index/1/betLowestMoneyNum",kPlayBaseLocation];
    
    NSDictionary *paramDic = @{@"playingMerchantId":self.playID};
    
    // 请求登陆接口
    __weak typeof(self)weakSelf = self;
    [AFNetManager requestPOSTWithURLStr:betLowstMoneyLoc paramDic:paramDic token:self.token finish:^(id responserObject) {
        
        NSLog(@"|MIN-MAX-AMOUNT-ROOMVC|success:%@",responserObject);
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        GPRespondModel *respondModel = [GPRespondModel new];
        
        [respondModel setValuesForKeysWithDictionary:responserObject];
        
        if (respondModel.code.integerValue == 9200) {
            
            // 最大最小下注金额赋值
            weakSelf.msgMinAmount = [NSString stringWithFormat:@"%@",[respondModel.data objectForKey:@"minAmount"]];
            weakSelf.msgMaxAmount = [NSString stringWithFormat:@"%@",[respondModel.data objectForKey:@"maxAmount"]];
            weakSelf.msgRoundBetAmount = [NSString stringWithFormat:@"%@",[respondModel.data objectForKey:@"roundBetAmount"]];
                
            [weakSelf addBetingNoticeMessage];
            
        }else{
            
//            [ToastView toastViewWithMessage:respondModel.msg timer:2.5];
        }
        
    } enError:^(NSError *error) {
        
        [weakSelf.progressHUD hideAnimated:YES];
        
//        [ToastView toastViewWithMessage:@"数据连接出错，请稍后再试" timer:3.0];
        
    }];
}

#pragma mark - 倒计时60秒时添加提醒消息
- (void)addNoticeMessage{
    
    NSString *noticeStr = [NSString stringWithFormat:@" 【%@期】距封盘还有60秒，请抓紧时间下注  ",self.expectLab.text];
    NSDictionary *noticeDic = @{@"expect":noticeStr,@"type":@"9"};
    GPMessageModel *messageModel = [GPMessageModel new];
    [messageModel setValuesForKeysWithDictionary:noticeDic];
    [self.receiveMessageArray addObject:messageModel];
    [self.tableView reloadData];
    
    // 添加tableview向上滚动
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:self.receiveMessageArray.count-1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma mark - 封盘提醒消息
- (void)addEndMessage{
    
    NSString *noticeStr = [NSString stringWithFormat:@" 【%@期】已封盘，下注结果以系统开奖为准，如有异议请及时联系客服  ",self.expectLab.text];
    NSDictionary *noticeDic = @{@"expect":noticeStr,@"type":@"9"};
    GPMessageModel *messageModel = [GPMessageModel new];
    [messageModel setValuesForKeysWithDictionary:noticeDic];
    [self.receiveMessageArray addObject:messageModel];
    [self.tableView reloadData];
    
    // 添加tableview向上滚动
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:self.receiveMessageArray.count-1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma mark - 进入房间时和封盘结束时提醒消息
- (void)addBetingNoticeMessage{
    
    if (self.playID.integerValue == 1 || self.playID.integerValue == 4) {
        
        self.msgRoundBetAmount = @"80000";
        
    }else if (self.playID.integerValue == 2 || self.playID.integerValue == 5){
        
        self.msgRoundBetAmount = @"100000";
        
    }else if (self.playID.integerValue == 3 || self.playID.integerValue == 6){
        
        self.msgRoundBetAmount = @"100000";
    }
    
    NSString *noticeStr = [NSString stringWithFormat:@" 【%@期】单住%@起,%@封顶,总注%@封顶\n☆☆现在可以下注☆☆  ",self.expectLab.text,self.msgMinAmount,self.msgMaxAmount,self.msgRoundBetAmount];
    NSDictionary *noticeDic = @{@"expect":noticeStr,@"type":@"9"};
    GPMessageModel *messageModel = [GPMessageModel new];
    [messageModel setValuesForKeysWithDictionary:noticeDic];
    [self.receiveMessageArray addObject:messageModel];
    [self.tableView reloadData];
    
    // 添加tableview向上滚动
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:self.receiveMessageArray.count-1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma mark - 停售提醒消息
- (void)addEndBetMessage{
    
    if (self.productIdStr.integerValue == 1) { // 北京28
        
        NSString *noticeStr = [NSString stringWithFormat:@"各位老板，本游戏现在处于停售阶段，想要继续娱乐的老板请到隔壁加拿大28房间娱乐"];
        NSDictionary *noticeDic = @{@"expect":noticeStr,@"type":@"9"};
        GPMessageModel *messageModel = [GPMessageModel new];
        [messageModel setValuesForKeysWithDictionary:noticeDic];
        [self.receiveMessageArray addObject:messageModel];
        [self.tableView reloadData];
        
        // 添加tableview向上滚动
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:self.receiveMessageArray.count-1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        
    }else if (self.productIdStr.integerValue == 2){ // 加拿大28
        
        NSString *noticeStr = [NSString stringWithFormat:@"各位老板，本游戏现在处于停售阶段，想要继续娱乐的老板请到隔壁北京28房间娱乐"];
        NSDictionary *noticeDic = @{@"expect":noticeStr,@"type":@"9"};
        GPMessageModel *messageModel = [GPMessageModel new];
        [messageModel setValuesForKeysWithDictionary:noticeDic];
        [self.receiveMessageArray addObject:messageModel];
        [self.tableView reloadData];
        
        // 添加tableview向上滚动
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:self.receiveMessageArray.count-1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

#pragma mark - 倒计时
/*
 * @param openTime:进入房间获取剩余倒计时时间
 * @param 封盘时间:
                   加拿大28：15秒
                   北京28：30秒
          开盘时间:
                   加拿大28：3分30秒
                   北京28：5分0秒
 */

- (void)countdown{
    
//    NSLog(@"%d",timerSecond);
    
     // ^^^^^^^^^^^^北京28倒计时^^^^^^^^^^^^^
    if (self.productIdStr.integerValue == 1) {
        
        if (timerSecond >30) {   // 开盘
            
            timerSecond--;
            
            // 设置倒计时
            if ((timerSecond-30)>60) {
                minute = (timerSecond-30)/60;   // 获取分钟数
                second = (timerSecond-30)%60;   // 获取秒数
            }else{
                minute = 0;
                second = timerSecond-30;
            }
            
            self.timerLab.text = [NSString stringWithFormat:@"%d分%d秒",minute,second];
            
            // 倒计时60秒时添加提醒消息
            if (timerSecond == 90) {
                
                [self addNoticeMessage];
            }
            
        }else if (timerSecond<=30){  // 封盘
            
            self.timerLab.text = @"封盘中";
            
            if (timerSecond == 30) {
                
                // 添加封盘消息
                [self addEndMessage];
            }
            
            timerSecond--;
            
            if (timerSecond == 0 || timerSecond == -1) {
                
                // 刷新数据
                [self refreshEnterRoomAgain];
            }else{
                
                self.timerLab.text = @"封盘中";
            }
            
        }
        
        // ^^^^^^^^^^^^^^^加拿大28倒计时^^^^^^^^^^^^^^^^^
    }else if (self.productIdStr.integerValue == 2){
        
        if (timerSecond>15) {   // 开盘
            
            timerSecond--;
            
            // 设置倒计时
            if ((timerSecond-15)>60) {
                minute = (timerSecond-15)/60;   // 获取分钟数
                second = (timerSecond-15)%60;   // 获取秒数
            }else{
                minute = 0;
                second = timerSecond-15;
            }
            self.timerLab.text = [NSString stringWithFormat:@"%d分%d秒",minute,second];
            
            // 倒计时60秒时添加提醒消息
            if (timerSecond == 75) {
                
                [self addNoticeMessage];
            }
            
        }else if (timerSecond<=15){  // 封盘
            
            self.timerLab.text = @"封盘中";
            
            if (timerSecond == 15) {
                
                // 添加封盘消息
                [self addEndMessage];
            }
            
            timerSecond--;
            
            if (timerSecond == 0 || timerSecond == -1) {
                
                // 刷新数据
                [self refreshEnterRoomAgain];
            }else{
                
                self.timerLab.text = @"封盘中";
            }
    
        }
    }
}

#pragma mark - 投注数据赋值
- (void)updataForBetContent{
    
    NSDictionary *playListDic = self.roomInfoModel.playingList;
    
    NSMutableArray *dataThirdArr = [playListDic objectForKey:@"dateThird"];   // page1数据
    NSMutableArray *dateFirstArr = [playListDic objectForKey:@"dateFirst"];   // page2数据
    NSMutableArray *dateSecondArr = [playListDic objectForKey:@"dateSecond"]; // page3数据
    
    if (self.pageOneDataArray.count>0) {
        
        [self.pageOneDataArray removeAllObjects];
    }
    
    if (self.pageTwoDataArray.count>0) {
        
        [self.pageTwoDataArray removeAllObjects];
    }
    
    if (self.pageThreeDataArray.count>0) {
        
        [self.pageThreeDataArray removeAllObjects];
    }
    
    // page1
    for (NSDictionary *oddsDic in dateFirstArr) {
        
        GPOddsInfoModel *oddsInfoModel = [GPOddsInfoModel new];
        
        [oddsInfoModel setValuesForKeysWithDictionary:oddsDic];
        
        [self.pageOneDataArray addObject:oddsInfoModel];
    }
    // page2
    for (NSDictionary *oddsDic in dateSecondArr) {
        
        GPOddsInfoModel *oddsInfoModel = [GPOddsInfoModel new];
        
        [oddsInfoModel setValuesForKeysWithDictionary:oddsDic];
        
        [self.pageTwoDataArray addObject:oddsInfoModel];
    }
    // page3
    for (NSDictionary *oddsDic in dataThirdArr) {
        
        GPOddsInfoModel *oddsInfoModel = [GPOddsInfoModel new];
        
        [oddsInfoModel setValuesForKeysWithDictionary:oddsDic];
        
        [self.pageThreeDataArray addObject:oddsInfoModel];
    }
    
    // betView赋值
    self.roomBetView.pageOneDataArray   = self.pageOneDataArray;
    self.roomBetView.pageTwoDataArray   = self.pageTwoDataArray;
    self.roomBetView.pageThreeDataArray = self.pageThreeDataArray;
    
}

#pragma mark - 获取当前时间
- (NSString *)loadNowDate{
    
    NSDate *nowDate = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    
    NSString *nowDateStr = [dateFormatter stringFromDate:nowDate];
    
    NSLog(@"^^^^^^^当前时间^^^^^^^%@",nowDateStr);
    
    return nowDateStr;
}

#pragma mark - 确定投注
- (void)makeSureBetWithAmount:(NSString *)betAmount{
    
    if ([self.timerLab.text isEqualToString:@"封盘中"]) {
        
        [ToastView toastViewWithMessage:@"封盘中,暂停下注..." timer:3.0];
        
    }else if ([self.timerLab.text isEqualToString:@"关闭算账"]){
        
        [ToastView toastViewWithMessage:@"关闭算账,暂停下注..." timer:3.0];
    }else{
  
    NSString *nowDate = [self loadNowDate];
    
    NSDictionary *paramDic = @{@"roomId":self.roomIdStr,@"betAmount":betAmount,@"playingId":self.playingId,@"productId":self.productIdStr,@"expect":self.expectLab.text};
    
    [self.progressHUD showAnimated:YES];
    
    [self loadUserDefaultsData];
    
    NSString *betLoc = [NSString stringWithFormat:@"%@betting/1/do",kPlayBaseLocation];
    
    // 请求登陆接口
    __weak typeof(self)weakSelf = self;
    [AFNetManager requestPOSTWithURLStr:betLoc paramDic:paramDic token:self.token finish:^(id responserObject) {
        
        NSLog(@"|ROOM-VC-BETTING|success:%@",responserObject);
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        GPRespondModel *respondModel = [GPRespondModel new];
        
        [respondModel setValuesForKeysWithDictionary:responserObject];
        
        if (respondModel.code.integerValue == 9200) {
            
            [ToastView toastViewWithMessage:@"投注成功" timer:3.0];
            
            // 下注成功后修改余额
            self.moneyLab.text = [NSString stringWithFormat:@"%d.00",self.moneyLab.text.intValue-betAmount.intValue];
            
            /*
            // 添加动画
            self.scoreView.hidden = NO;
            CGPoint centerPoint = self.view.center;
            CGMutablePathRef path = CGPathCreateMutable(); // 可变路径
            CGPathMoveToPoint(path, nil, centerPoint.x, centerPoint.y);  // 设置起点
            CGPathAddQuadCurveToPoint(path, nil, centerPoint.x+100, centerPoint.y-100, scoreViewX, scoreViewY);// 添加弧度路径
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"]; // 设置动画
            animation.path = path;  // 添加路径
            animation.duration = 3.0; // 动画时长
            [self.scoreView.layer addAnimation:animation forKey:@"position"];  // 添加到view
            self.topScoreLab.text = [NSString stringWithFormat:@"↓%@",self.betAmountStr];  // 修改金额
             */

            NSLog(@"|ROOM-VC-BETTING==9200|roomID:%@===betAmount:%@===playingId:%@===productID:%@",weakSelf.roomIdStr,betAmount,weakSelf.playingId,weakSelf.productIdStr);
            
            // 投注成功发送消息
            NSDictionary *contentDic = @{@"betAmount":betAmount,@"date":nowDate,@"expect":weakSelf.expectLab.text,@"level":weakSelf.infoModel.level,@"name":weakSelf.infoModel.nickname,@"playingId":weakSelf.playingId,@"playingType":weakSelf.playingType,@"type":@"1"};
            NSString *contentSter = [ToastView dictionaryToJson:contentDic];
            NSLog(@"========^send^text^^========%@",contentSter);
            JMSGTextContent *content = [[JMSGTextContent alloc]initWithText:contentSter];
            JMSGMessage *sendMessage = [JMSGMessage createChatRoomMessageWithContent:content chatRoomId:weakSelf.roomIdStr];
            [JMSGMessage sendMessage:sendMessage];
            NSError *error;
            [weakSelf onSendMessageResponse:sendMessage error:error];
            GPMessageModel *messageModel = [GPMessageModel new];
            [messageModel setValuesForKeysWithDictionary:contentDic];
            [messageModel setValue:@"sender" forKey:@"sendType"];
            [messageModel setValue:weakSelf.infoModel.nickname forKey:@"name"];
            [weakSelf.receiveMessageArray addObject:messageModel];
            NSLog(@"|JMSENDMESSAGE|-|SEND|%@",sendMessage);
            [weakSelf.tableView reloadData];
            
            // 添加tableview向上滚动
            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:self.receiveMessageArray.count-1 inSection:0];
            [self.tableView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            
            // 投注成功关闭betContentView
            [weakSelf.roomBetView.betTextField resignFirstResponder];
            weakSelf.roomBetView.betBottom.constant = 10;
            weakSelf.roomBetView.hidden = YES;
            [weakSelf.inputTextView resignFirstResponder];
            weakSelf.chatViewBottom.constant = 0;
            
            
        }else{
            
            [ToastView toastViewWithMessage:respondModel.msg timer:3.0];
            
            NSLog(@"|ROOM-VC-BETTING==else|roomID:%@===betAmount:%@===playingId:%@===productID:%@",self.roomIdStr,betAmount,self.playingId,self.productIdStr);

        }
        
    } enError:^(NSError *error) {
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        [ToastView toastViewWithMessage:@"数据连接出错，请稍后再试" timer:3.0];
        
    }];
        
    }
}


#pragma mark - 极光代理方法（接收消息）
// 接收聊天室消息
- (void)onReceiveChatRoomConversation:(JMSGConversation *)conversation
                             messages:(NSArray JMSG_GENERIC(__kindof JMSGMessage *)*)messages{
    
    NSLog(@"=========%@",[messages.lastObject.target roomID]);
    
    // 过滤其他聊天室信息
    if ([[messages.lastObject.target roomID]isEqualToString:self.roomIdStr]) {

    JMSGTextContent *textContent = (JMSGTextContent *)messages.lastObject.content;
    
    NSString *msgText = textContent.text;
    
    JMSGUser *fromName = (JMSGUser *)messages.lastObject.fromUser;
    
    NSLog(@"|CHATROOM|-|fromname|%@",fromName);
    
    NSString *nickname;
    
    if (fromName.nickname != nil) {
        
        nickname = fromName.nickname;
        
        NSLog(@"|CHATROOM|-|nickname|%@",nickname);
    }else{
        
        nickname = fromName.username;
        
        NSLog(@"|CHATROOM|-|username|%@",nickname);
    }
    
    
    NSDictionary *messageDic = [ToastView dictionaryWithJsonString:msgText];
    
    NSLog(@"========^^diction^^========%@",messageDic);
    
    GPMessageModel *messageModel = [GPMessageModel new];
    
    [messageModel setValuesForKeysWithDictionary:messageDic];
    
    [messageModel setValue:nickname forKey:@"fromName"];
    
    [self.receiveMessageArray addObject:messageModel];
    
    [self.tableView reloadData];
    
    if (messageModel.type.integerValue == 2) {  // 开奖结果
        
        GPRoomHistoryModel *historyModel = [GPRoomHistoryModel new];
        
        historyModel.expect = messageModel.expect;
        historyModel.code = messageModel.openCode;
        historyModel.codeText = messageModel.openText;
        
        self.historyExpectLab.text = [NSString stringWithFormat:@"%@",messageModel.expect];
        self.historyCodeLab.text = [NSString stringWithFormat:@"%@",messageModel.openCode];
        self.historyCodeTextLab.text = [NSString stringWithFormat:@"%@",messageModel.openText];
        
        [self.historyDataArray insertObject:historyModel atIndex:0];
        [self.historyDataArray removeObject:self.historyDataArray.lastObject];
        [self.historyTableView reloadData];
        
        // 计算当期盈亏
        [self mathBetMoney];
        
    }else if (messageModel.type.integerValue == 5){  // 封盘
        
        [self.enterTimer setFireDate:[NSDate distantFuture]]; // 封盘关闭定时器
        self.timerLab.text = @"关闭算账";
        // 发送停售提醒
        [self addEndBetMessage];
    }else if (messageModel.type.integerValue == 4){  // 开盘
        
        // 开启定时器
        [self.enterTimer setFireDate:[NSDate distantPast]];
        
        // 刷新数据
        [self refreshEnterRoomAgain];
    }
    
    // 添加tableview向上滚动
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:self.receiveMessageArray.count-1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    NSLog(@"========^receive^text^^========%@",msgText);
        
    }else{
        
//        NSLog(@"^^^^^^^^^其他聊天室消息^^^^^^^^^%@",[messages.lastObject.target roomID]);
    }
}

#pragma mark - 极光代理方法 （发送消息结果回调）
- (void)onSendMessageResponse:(JMSGMessage *)message error:(NSError *)error{
    
    if (!error) {
        
        JMSGTextContent *textContent = (JMSGTextContent *)message.content;
        
        NSString *msgText = textContent.text;
        
        NSLog(@"|ROOM-VC|-|send-success|%@",msgText);
    }else{
        
        NSLog(@"|ROOM-VC|-|send-error|%@",error);
        [ToastView toastViewWithMessage:@"发送失败" timer:3.0];
    }
}
#pragma mark - 极光代理方法 （当前登录用户被踢、非客户端修改密码强制登出、登录状态异常、被删除、被禁用、信息变更等事件）
- (void)onReceiveUserLoginStatusChangeEvent:(JMSGUserLoginStatusChangeEvent *)event{
    
    if (event.eventType == kJMSGEventNotificationLoginKicked) {
        
        NSLog(@"^^^room^^^用户被登出^^^^^^^");
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
//        [self alertViewWithTitle:@"提醒" message:@"账号在其他设备登陆"];
        
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提醒" message:@"账号在其他设备登陆" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            // 删除本地数据
            [UserDefaults deleateData];
            
        }];
        
        [alertVC addAction:action];
        
        [self presentViewController:alertVC animated:YES completion:nil];
    }
    
    NSLog(@"==============^^信息变更^^==================%@",event.eventDescription);
    
    JMSGUser *user = [JMSGUser myInfo];
    
    NSLog(@"^^^^^^^^^^^^金额变更^^^^^^^^^^^^^^^%@",user.avatar);
    
    if (user.avatar.length>0) {
        
//        NSString *score = [NSString stringWithFormat:@"%d",user.avatar.intValue-self.moneyLab.text.intValue];
        
        int score = user.avatar.intValue-self.moneyLab.text.intValue;
        
        // 更新余额
        self.moneyLab.text = [NSString stringWithFormat:@"%@",user.avatar];
        
        NSLog(@"|^^^^^^^^^^^^^^^SCORE^^^^^^^^^^^^^^^^^|%d",score);
        
//        // score>0表示赢
//        if (score>0) {
//            NSLog(@"|^^^^^^^^^^^^^^^赢SCORE^^^^^^^^^^^^^^^^^|%d",score);
//            self.moneyLab.text = [NSString stringWithFormat:@"%@",user.avatar];
//            self.scoreView.hidden = NO;
//            CGPoint centerPoint = self.view.center;
//            CGMutablePathRef path = CGPathCreateMutable();
//            CGPathMoveToPoint(path, nil, centerPoint.x, centerPoint.y);
//            CGPathAddQuadCurveToPoint(path, nil, centerPoint.x+100, centerPoint.y-100, scoreViewX, scoreViewY);///添加一个控制点和结束点
//            CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
//            animation.path = path;
//            animation.duration = 3.0;
//            [self.scoreView.layer addAnimation:animation forKey:@"position"];
//
//            self.topScoreLab.text = [NSString stringWithFormat:@"↑赢%d",score];
//            self.topScoreLab.textColor = [UIColor redColor];
//        }else{
//            NSLog(@"|^^^^^^^^^^^^^^^输SCORE^^^^^^^^^^^^^^^^^|%d",score);
//            self.moneyLab.text = [NSString stringWithFormat:@"%@",user.avatar];
//            self.scoreView.hidden = NO;
//            CGPoint centerPoint = self.view.center;
//            CGMutablePathRef path = CGPathCreateMutable();
//            CGPathMoveToPoint(path, nil, centerPoint.x, centerPoint.y);
//            CGPathAddQuadCurveToPoint(path, nil, centerPoint.x+100, centerPoint.y-100, scoreViewX, scoreViewY);///添加一个控制点和结束点
//            CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
//            animation.path = path;
//            animation.duration = 3.0;
//            [self.scoreView.layer addAnimation:animation forKey:@"position"];
//            self.topScoreLab.text = [NSString stringWithFormat:@"↓亏%d",score];
//            self.topScoreLab.textColor = [UIColor greenColor];
//        }
    }
 
}

#pragma mark - 查看游戏记录计算输赢金额
- (void)mathBetMoney{
    
    [self.progressHUD showAnimated:YES];
    
    [self loadUserDefaultsData];
    
    NSString *gameDetailLoc = [NSString stringWithFormat:@"%@user/1/playingRecord",kBaseLocation];
    NSDictionary *paramDic = @{@"roomId":self.roomIdStr,@"page":@"1",@"rows":@"10"};
    // 请求登陆接口
    __weak typeof(self)weakSelf = self;
    [AFNetManager requestPOSTWithURLStr:gameDetailLoc paramDic:paramDic token:self.token finish:^(id responserObject) {
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        NSString *code = [NSString stringWithFormat:@"%@",[responserObject objectForKey:@"code"]];
        NSString *msg = [responserObject objectForKey:@"msg"];
        NSMutableArray *gameArray = [responserObject objectForKey:@"data"];
        
        if (code.integerValue == 9200) {
            
            // 获取当期投注
            NSMutableArray *mathArr = [NSMutableArray array];
            for (NSDictionary *dataDic in gameArray) {
                
                GPBetDetailModel *detaileModel = [[GPBetDetailModel alloc]init];
                [detaileModel setValuesForKeysWithDictionary:dataDic];
                
                if (detaileModel.expect.integerValue == self.historyExpectLab.text.integerValue) {
                    
                    [mathArr addObject:detaileModel];
                }
            }
            
            // 计算当期投注金额
            if (mathArr.count>0) {
                
                mathBetMoney = 0;
                
                for (GPBetDetailModel *model in mathArr) {
                    
                    mathBetMoney += (model.rewardNum.intValue-model.betAmout.intValue);
                }
                NSLog(@"=========当期盈亏===========%d",mathBetMoney);
                
                if (mathBetMoney>0) {  // 赢
                    
                    // 添加动画
                    self.scoreView.hidden = NO;
                    self.topScoreLab.text = @"上期赢";
                    self.topScoreLab.font = [UIFont systemFontOfSize:20];
                    CGPoint centerPoint = self.view.center;
                    CGMutablePathRef path = CGPathCreateMutable(); // 可变路径
                    CGPathMoveToPoint(path, nil, centerPoint.x, centerPoint.y);  // 设置起点
                    CGPathAddQuadCurveToPoint(path, nil, centerPoint.x+100, centerPoint.y-100, scoreViewX, scoreViewY);// 添加弧度路径
                    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"]; // 设置动画
                    animation.path = path;  // 添加路径
                    animation.duration = 3.0; // 动画时长
                    [self.scoreView.layer addAnimation:animation forKey:@"position"];  // 添加到view
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        self.topScoreLab.font = [UIFont systemFontOfSize:13];
                        self.topScoreLab.text = [NSString stringWithFormat:@"↑%d",mathBetMoney];  // 修改金额
                    });
     
                }else if (mathBetMoney<0){  // 亏
                    
                    // 添加动画
                    self.scoreView.hidden = NO;
                    self.topScoreLab.text = @"上期亏";
                    self.topScoreLab.font = [UIFont systemFontOfSize:20];
                    CGPoint centerPoint = self.view.center;
                    CGMutablePathRef path = CGPathCreateMutable(); // 可变路径
                    CGPathMoveToPoint(path, nil, centerPoint.x, centerPoint.y);  // 设置起点
                    CGPathAddQuadCurveToPoint(path, nil, centerPoint.x+100, centerPoint.y-100, scoreViewX, scoreViewY);// 添加弧度路径
                    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"]; // 设置动画
                    animation.path = path;  // 添加路径
                    animation.duration = 3.0; // 动画时长
                    [self.scoreView.layer addAnimation:animation forKey:@"position"];  // 添加到view
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        self.topScoreLab.font = [UIFont systemFontOfSize:13];
                        self.topScoreLab.text = [NSString stringWithFormat:@"↓%d",mathBetMoney];  // 修改金额
                    });
                    
                    
                }else{  // 平
                    
                    self.scoreView.hidden = YES;
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

#pragma mark - 加载玩法说明
- (void)loadProductDetailDataWithParamDic:(NSDictionary *)paramDic productName:(NSString *)productName{
    
    [self.progressHUD showAnimated:YES];
    
    [self loadUserDefaultsData];
    
    NSString *productDetailLoc = [NSString stringWithFormat:@"%@product/1/productDetail",kBaseLocation];
    
    // 请求登陆接口
    __weak typeof(self)weakSelf = self;
    [AFNetManager requestPOSTWithURLStr:productDetailLoc paramDic:paramDic token:self.token finish:^(id responserObject) {
        
        NSLog(@"|GAMEINS-VC|success:%@",responserObject);
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        GPRespondModel *respondModel = [GPRespondModel new];
        
        [respondModel setValuesForKeysWithDictionary:responserObject];
        
        if (respondModel.code.integerValue == 9200) {
            
//            [ToastView toastViewWithMessage:respondModel.msg timer:1.5];
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            GPGameInstroctionViewController *gameInsVC = [storyboard instantiateViewControllerWithIdentifier:@"gameInstrostionVC"];
            
            gameInsVC.htmlString = [respondModel.data objectForKey:@"productExplain"];
            
            gameInsVC.myTitle = productName;
            
            gameInsVC.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:gameInsVC animated:YES];
            
        }else{
            
            [ToastView toastViewWithMessage:respondModel.msg timer:2.5];
        }
        
    } enError:^(NSError *error) {
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        [ToastView toastViewWithMessage:@"数据连接出错，请稍后再试" timer:3.0];
        
    }];
    
}

#pragma mark - 跳转走势图
- (void)turnToTrendVC{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    GPTrendViewController *trendVC = [storyboard instantiateViewControllerWithIdentifier:@"trendVC"];
    
    trendVC.roomId = self.roomIdStr;
    
    [self.navigationController pushViewController:trendVC animated:YES];
}

#pragma mark - 跳转游戏记录
- (void)turnToHistoryVC{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    GPRoomPlayingRecordViewController *playingRecordVC = [storyboard instantiateViewControllerWithIdentifier:@"playingRecordVC"];
    playingRecordVC.roomId = self.roomIdStr;
    [self.navigationController pushViewController:playingRecordVC animated:YES];
}

#pragma mark - 刷新余额
- (IBAction)refreshButton:(UIButton *)sender {
    
    [self.progressHUD showAnimated:YES];
    
    self.moneyLab.text = @"??元宝";
    
    [self loadUserDefaultsData];
    
    NSString *walletLoc = [NSString stringWithFormat:@"%@user/1/money",kBaseLocation];
    
    // 请求登陆接口
    __weak typeof(self)weakSelf = self;
    [AFNetManager requestPOSTWithURLStr:walletLoc paramDic:nil token:self.token finish:^(id responserObject) {
        
        NSLog(@"|ROOM-VC-MONEY-REFSH|success:%@",responserObject);
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        GPRespondModel *respondModel = [GPRespondModel new];
        
        [respondModel setValuesForKeysWithDictionary:responserObject];
        
        if (respondModel.code.integerValue == 9200) {
            
            GPWalletModel *walletModel = [GPWalletModel new];
            
            [walletModel setValuesForKeysWithDictionary:respondModel.data];
            
            // 刷新钱包金额
            self.moneyLab.text = walletModel.moneyNum;
            
        }else{
            
            [ToastView toastViewWithMessage:respondModel.msg timer:2.5];
        }
        
    } enError:^(NSError *error) {
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        [ToastView toastViewWithMessage:@"数据连接出错，请稍后再试" timer:3.0];
        
    }];
    
}

#pragma mark - 关闭历史记录
- (IBAction)dissmissHistoryView:(UIButton *)sender {
    
    isShow++;
    self.historyView.hidden  = YES;
    
}

#pragma mark - table view 代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView.tag == 1200) {
        
        return self.historyDataArray.count;
        
    }else{
        
        return self.receiveMessageArray.count;
    }
  
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag == 1200) {   // historyTableView
        
        return 30;
        
    }else{  // 聊天tableview
   
        GPMessageModel *messageModel = self.receiveMessageArray[indexPath.row];
        
        if ([messageModel.type isEqualToString:@"0"]) {
            
            return 50;
            
        }else if ([messageModel.type isEqualToString:@"1"]){
            
            return 150;
            
        }else if ([messageModel.type isEqualToString:@"2"]){
            
            return 50;
            
        }else if([messageModel.type isEqualToString:@"3"]){
            
            return 80;
        }else if([messageModel.type isEqualToString:@"9"]){
            
            return 65;
            
        }else{
            
            return 0.01;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag == 1200) {   // historyTableView
        
        GPRoomHistoryCell *historyCell = [tableView dequeueReusableCellWithIdentifier:@"historyCell" forIndexPath:indexPath];
        
        historyCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        GPRoomHistoryModel *historyModel = self.historyDataArray[indexPath.row];
        
        [historyCell setDataWithModel:historyModel];
        
        return historyCell;
        
    }else{  // 聊天tableview
        
        GPMessageModel *messageModel = self.receiveMessageArray[indexPath.row];
        
        if ([messageModel.sendType isEqualToString:@"sender"]) {  // 发送发cell
            
            if ([messageModel.type isEqualToString:@"1"]) {
                
                GPMsgSenderCell *secderCell = [tableView dequeueReusableCellWithIdentifier:@"secderCell" forIndexPath:indexPath];
                
                secderCell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                [secderCell setDataWithModel:messageModel];
                
//                [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                
                return secderCell;
            }else{
                return [[UITableViewCell alloc]init];
            }
        }else{  // 接收方cell
            
            if ([messageModel.type isEqualToString:@"0"]) {  // 进入房间的消息
                
                GPMsgEnterRoomCell *enterRoomCell = [tableView dequeueReusableCellWithIdentifier:@"enterRoomCell" forIndexPath:indexPath];
                
                enterRoomCell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                [enterRoomCell setDataWithModel:messageModel];
                
//                [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                
                return enterRoomCell;
                
            }else if ([messageModel.type isEqualToString:@"3"]){  // 推送开奖信息
                
                GPMsgSystemCell *systemCell = [tableView dequeueReusableCellWithIdentifier:@"systemCell" forIndexPath:indexPath];
                
                systemCell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                [systemCell setDataWithModel:messageModel];
                
//                [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                
                return systemCell;
                
            }else if ([messageModel.type isEqualToString:@"1"]){  // 下注成功后的推送
                
                GPMsgReceiveCell *receiveCell = [tableView dequeueReusableCellWithIdentifier:@"receiveCell" forIndexPath:indexPath];
                
                [receiveCell setDataWithModel:messageModel];
                
//                [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                
                return receiveCell;
                
            }else if ([messageModel.type isEqualToString:@"2"]){  // 开奖信息
                
                GPMsgScoreCell *scoreCell = [tableView dequeueReusableCellWithIdentifier:@"scoreCell" forIndexPath:indexPath];
                scoreCell.backgroundColor = [UIColor clearColor];
                [scoreCell setDataWithModel:messageModel];
                
                return scoreCell;
                
            }else if ([messageModel.type isEqualToString:@"9"]){  // 倒计时60秒提醒消息
                
                GPMsgNoticeCell *noticeCell = [tableView dequeueReusableCellWithIdentifier:@"noticeCell" forIndexPath:indexPath];
                noticeCell.backgroundColor = [UIColor clearColor];
                [noticeCell setdataWithModel:messageModel];
                
                return noticeCell;
                
            }else{
                
                return [UITableViewCell new];
            }
            
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 点击后取消cell的点击状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 跟投点击事件
    if (tableView.tag == 1201) {

        GPMessageModel *messageModel = self.receiveMessageArray[indexPath.row];

//        if (![messageModel.sendType isEqualToString:@"sender"]) {

            if (messageModel.type.integerValue ==1) {

                if (messageModel.expect.integerValue != self.expectLab.text.integerValue) {

                    [ToastView toastViewWithMessage:@"只能跟投当前期" timer:3.0];
                }else{

                    self.betCopyView.hidden = NO;
                    self.playingType = messageModel.playingType;
                    self.betCopyView.betInfoArray = @[messageModel.name,messageModel.expect,messageModel.playingType,messageModel.betAmount].mutableCopy;
                    self.playingId = messageModel.playingId;
                    self.betAmountStr = [NSString stringWithFormat:@"%@",messageModel.betAmount];
                    
                    [self.betCopyView.tableView reloadData];
                    // 保存当前跟投期数
                    self.flowBetViewExcept = messageModel.expect;

                }
            }
//        }
    }else if (tableView.tag == 1200){
        
        isShow++;
        self.historyView.hidden  = YES;
    }
    
}

#pragma mark - 提醒框
- (void)alertViewWithTitle:(NSString *)title message:(NSString *)message{
    
    UIAlertController *alert  = [UIAlertController alertControllerWithTitle:title
                                                                    message:message
                                                             preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction     *action = [UIAlertAction actionWithTitle:@"确定"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           
                                                           [self dismissViewControllerAnimated:YES
                                                                                    completion:nil];
                                                       }];
    
    [alert addAction:action];
    
    [self presentViewController:alert
                       animated:YES
                     completion:nil];
    
}

#pragma mark - 懒加载
- (NSMutableArray *)pageOneDataArray{
    
    if (!_pageOneDataArray) {
        
        self.pageOneDataArray = [NSMutableArray array];
    }
    return _pageOneDataArray;
}

- (NSMutableArray *)pageTwoDataArray{
    
    if (!_pageTwoDataArray) {
        
        self.pageTwoDataArray = [NSMutableArray array];
    }
    return _pageTwoDataArray;
}

- (NSMutableArray *)pageThreeDataArray{
    
    if (!_pageThreeDataArray) {
        
        self.pageThreeDataArray = [NSMutableArray array];
    }
    return _pageThreeDataArray;
}

- (NSMutableArray *)receiveMessageArray{
    
    if (!_receiveMessageArray) {
        
        self.receiveMessageArray = [NSMutableArray array];
    }
    return _receiveMessageArray;
}

- (NSMutableArray *)historyDataArray{
    
    if (!_historyDataArray) {
        
        self.historyDataArray = [NSMutableArray array];
    }
    return _historyDataArray;
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
