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

static int isShow = 0; // 历史开奖记录view
static int minute;     // 倒计时分钟
static int second;     // 倒计时秒
@interface GPRoomViewController ()<UITextViewDelegate,JMSGConversationDelegate,JMessageDelegate,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chatViewBottom;  // chatview距离底部的距离


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
@property (strong, nonatomic) NSString *playingId;     // 玩法id
@property (strong, nonatomic) NSString *minAmount;     // 最小下注金额
@property (strong, nonatomic) NSMutableArray *receiveMessageArray;  // 接收聊天室消息

@property (weak, nonatomic) IBOutlet UIView *historyView;            // 往期记录
@property (weak, nonatomic) IBOutlet UITableView *historyTableView;  // 往期记录
@property (strong, nonatomic) NSMutableArray *historyDataArray;      // 往期记录

@property (strong, nonatomic) NSString *openTime;   // 倒计时剩余时间
@property (strong, nonatomic) NSTimer *enterTimer;  // 进入房间定时器
@property (strong, nonatomic) NSTimer *normolTimer; // 房间内定时器

@property (strong, nonatomic) GPRoomCopyBetView *betCopyView;  // 跟投页面


@end

@implementation GPRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"游戏大厅";
    NSLog(@"|ROOMVC|roomID:%@==productid:%@",_roomIdStr,_productIdStr);
    
    [self loadSubView];
    
    [self loadOddsContentData];
}

#pragma mark - 关闭页面退出聊天室
- (void)viewDidDisappear:(BOOL)animated{
    
    // 退出聊天室
    [JMSGChatRoom leaveChatRoomWithRoomId:self.roomIdStr completionHandler:^(id resultObject, NSError *error) {
       
        if (!error) {
            
            NSLog(@"|ROOM-VC|-|LEAVE-CHATROOM|-|SUCCESS|%@",resultObject);
            
        }else{
            
            NSLog(@"|ROOM-VC|-|LEAVE-CHATROOM|-|error|%@",error);
        }
    }];
    
    // 销毁定时器
    [self.normolTimer invalidate];
    self.normolTimer = nil;
    [self.enterTimer invalidate];
    self.enterTimer = nil;
}

- (void)loadSubView{
    
    // 房间内正常定时器
    self.normolTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(normolCountdown) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:self.normolTimer forMode:NSDefaultRunLoopMode];
    [self.normolTimer setFireDate:[NSDate distantFuture]];  // 关闭定时器
    
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
    };
    
    // item点击事件
    self.roomBetView.selecetItemBlock = ^(NSString *playId,NSString *minAmount) {
      
        weakSelf.playingId = playId;    // 玩法id
        weakSelf.minAmount = minAmount; // 最小下注金额
        
    };
    
    // 确定投注
    self.roomBetView.betBtnBlock = ^(NSString *betAmountStr){
        
        weakSelf.betAmountStr = betAmountStr;  // 下注金额
        
        [weakSelf makeSureBetWithAmount:weakSelf.betAmountStr];

    };
    
    // **********添加跟投页面*********** //
    self.betCopyView = [[GPRoomCopyBetView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:self.betCopyView];
    self.betCopyView.hidden = YES;
    
    // 确定跟投
    self.betCopyView.makeSuerBtnBlock = ^{
        
//        [weakSelf makeSureBetWithAmount:weakSelf.betAmountStr];
    };
    
    // 取消跟投
    self.betCopyView.cancelBtnBlock = ^{
      
        weakSelf.betCopyView.hidden = YES;
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
    
    NSLog(@"===:%@",self.token);
    
}


#pragma mark - 投注按钮
- (IBAction)betButton:(UIButton *)sender {
    
    [UIView animateWithDuration:1 animations:^{
        
        self.roomBetView.hidden = NO;

    }];
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
            
            [ToastView toastViewWithMessage:msg timer:3.0];
            
            // 获取房间内数据
            NSDictionary *dataDic = [responserObject objectForKey:@"data"];
            
            self.roomInfoModel = [GPEnterRoomInfoModel new];
            
            [self.roomInfoModel setValuesForKeysWithDictionary:dataDic];
            
            // 房间数据赋值
            [self updataForRoomContent];
            
            // 投注数据赋值
            [self updataForBetContent];
            
        }else{
            
            [ToastView toastViewWithMessage:msg timer:3.0];
        }
        [weakSelf.historyTableView reloadData];
        // 刷新数据
        [weakSelf.roomBetView.leftCollectionView reloadData];
        [weakSelf.roomBetView.middleCollectionView reloadData];
        [weakSelf.roomBetView.rightCollectionView reloadData];
    } enError:^(NSError *error) {
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        [ToastView toastViewWithMessage:@"数据连接出错，请稍后再试" timer:3.0];
        
        NSLog(@"%@",error);
        
    }];
}

#pragma mark - 房间数据赋值
- (void)updataForRoomContent{
    
    self.moneyLab.text = self.roomInfoModel.moneyNum;  // 用户元宝数
    NSDictionary *comingDic = [NSDictionary dictionaryWithDictionary:self.roomInfoModel.coming];  // 下期数据
    self.expectLab.text = [comingDic objectForKey:@"expect"]; // 即将开奖期数
    self.openTime = [comingDic objectForKey:@"openTime"];  // 倒计时秒数
    NSString *endTime = [comingDic objectForKey:@"forbidBetAheadTime"]; // 封盘时间
    
    NSLog(@"|ROOM-VC|-|openTime|:%@-|endTime|:%@",_openTime,endTime);
    
    // 设置倒计时
    if (self.openTime.intValue>60) {
        minute = self.openTime.intValue/60;   // 获取分钟数
        second = self.openTime.intValue%60;   // 获取秒数
    }else{
        minute = 0;
        second = self.openTime.intValue;
    }
    
    NSLog(@"|ENTERROOM-OPENTIME|^^^^^^opentime^^^^^|%@|^^^^^^^minute^^^^^^^|%d|^^^^^^second^^^^^^^|%d",self.openTime,minute,second);
    
    self.enterTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(countdown) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:self.enterTimer forMode:NSDefaultRunLoopMode];
  
    // 设置开奖历史数据
    NSMutableArray *historyArr = [NSMutableArray arrayWithArray:self.roomInfoModel.history];
    
    for (NSDictionary *codeDic in historyArr) {
        
        GPRoomHistoryModel *historyModel = [GPRoomHistoryModel new];
        
        [historyModel setValuesForKeysWithDictionary:codeDic];
        
        [self.historyDataArray addObject:historyModel];
    }
    
    GPRoomHistoryModel *expectModel = self.historyDataArray.firstObject;
    self.historyExpectLab.text      = expectModel.expect;
    self.historyCodeLab.text        = expectModel.code;
    self.historyCodeTextLab.text    = expectModel.codeText;
    
}

#pragma mark - 倒计时
/*
 * @param openTime:进入房间获取剩余倒计时时间
 * @param timer:距离下期开奖时间3分30秒 - 10秒封盘时间 = 倒计时时间3分20秒
 */
- (void)countdown{  // 进入房间开奖倒计时
    
    // 初始倒计时时间<0显示封盘中
    if (second<0) {
        
        // 秒数为0时提示封盘中，停止定时器
        self.timerLab.text = @"封盘中";
        
        // 关闭进入房间定时器
        [self.enterTimer setFireDate:[NSDate distantFuture]];
        
        minute = 3;
        second = 30;
        // 开启正常房间内定时器
        [self.normolTimer setFireDate:[NSDate distantPast]];
    }else{
        
        if (minute>=0) {
            self.timerLab.text = [NSString stringWithFormat:@"%d分:%d秒",minute,second];
            // 分钟数大于0，秒数每秒减1
            second--;
            if (second == 0) {
                if (minute==0) {
                    minute--;
                }else{
                    
                    // 秒数为0时,分钟数减1, 充值秒数为59
                    minute--;
                    second = 59;
                }
            }
            
        }else{
            
            self.timerLab.text = [NSString stringWithFormat:@"0分:%d秒",second];
            // 分钟数<=0时，秒数每秒减1
            second--;
            
            if (second == 0) {
                // 秒数为0时提示封盘中，停止定时器
                self.timerLab.text = @"封盘中";
                
                // 关闭进入房间定时器
                [self.enterTimer setFireDate:[NSDate distantFuture]];
                
                minute = 3;
                second = 30;
                // 修改当前期数
                self.expectLab.text = [NSString stringWithFormat:@"%d",self.expectLab.text.intValue+1];
                // 开启正常房间内定时器
                [self.normolTimer setFireDate:[NSDate distantPast]];
            }
        }
    }
}
- (void)normolCountdown{   // 正常房间内开奖倒计时

    if (minute>=0) {
        // 分钟数>=0时，秒数没秒减1，
        second--;
        if (minute == 3 && second >20) {
            // 分钟数==3并且秒数>20显示封盘中（10秒钟封盘时间）
            self.timerLab.text = @"封盘中";
        }else{
            
            // 封盘结束开始倒计时
            self.timerLab.text = [NSString stringWithFormat:@"%d分:%d秒",minute,second];
            
            if (second==0) {
                // 秒数为0时分钟数减1，重置秒数为59
                minute--;
                second = 59;
            }
        }
    }else{
        // 分钟数<0时，秒数每秒减1
        self.timerLab.text = [NSString stringWithFormat:@"0分:%d秒",second];
        second--;
        if (second>=0) {
            // 秒数==0时显示封盘中
            self.timerLab.text = @"封盘中";
            // 修改当前期数
            self.expectLab.text = [NSString stringWithFormat:@"%d",self.expectLab.text.intValue+1];
            // 重置倒计时时间
            minute = 3;
            second = 30;
        }
        
    }
    
}

#pragma mark - 投注数据赋值
- (void)updataForBetContent{
    
    NSDictionary *playListDic = self.roomInfoModel.playingList;
    
    NSMutableArray *dataThirdArr = [playListDic objectForKey:@"dateThird"];   // page1数据
    NSMutableArray *dateFirstArr = [playListDic objectForKey:@"dateFirst"];   // page2数据
    NSMutableArray *dateSecondArr = [playListDic objectForKey:@"dateSecond"]; // page3数据
    
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

#pragma mark - 确定投注
- (void)makeSureBetWithAmount:(NSString *)betAmount{
    
    [self.progressHUD showAnimated:YES];
    
    [self loadUserDefaultsData];
    
    NSString *betLoc = [NSString stringWithFormat:@"%@betting/1/do",kPlayBaseLocation];
    
    NSDictionary *paramDic = @{@"roomId":self.roomIdStr,@"betAmount":betAmount,@"playingId":self.playingId,@"productId":self.productIdStr};
    
    // 请求登陆接口
    __weak typeof(self)weakSelf = self;
    [AFNetManager requestPOSTWithURLStr:betLoc paramDic:paramDic token:self.token finish:^(id responserObject) {
        
        NSLog(@"|ROOM-VC-BETTING|success:%@",responserObject);
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        GPRespondModel *respondModel = [GPRespondModel new];
        
        [respondModel setValuesForKeysWithDictionary:responserObject];
        
        if (respondModel.code.integerValue == 9200) {
            
            [ToastView toastViewWithMessage:respondModel.msg timer:3.0];

            NSLog(@"|ROOM-VC-BETTING==9200|roomID:%@===betAmount:%@===playingId:%@===productID:%@",self.roomIdStr,betAmount,self.playingId,self.productIdStr);
            
            // 投注成功发送消息
            NSDictionary *contentDic = @{@"playingType":self.roomBetView.nameStr,@"betAmount":betAmount,@"level":self.infoModel.level,@"expect":self.expectLab.text,@"type":@"1"};
//            JMSGCustomContent *content = [[JMSGCustomContent alloc]initWithCustomDictionary:contentDic];
            NSString *contentSter = [ToastView dictionaryToJson:contentDic];
            NSLog(@"========^send^text^^========%@",contentSter);
            JMSGTextContent *content = [[JMSGTextContent alloc]initWithText:contentSter];
            JMSGMessage *sendMessage = [JMSGMessage createChatRoomMessageWithContent:content chatRoomId:self.roomIdStr];
            [JMSGMessage sendMessage:sendMessage];
            NSError *error;
            [self onSendMessageResponse:sendMessage error:error];
            GPMessageModel *messageModel = [GPMessageModel new];
            [messageModel setValuesForKeysWithDictionary:contentDic];
            [messageModel setValue:@"sender" forKey:@"sendType"];
            [messageModel setValue:self.infoModel.nickname forKey:@"name"];
            [weakSelf.receiveMessageArray addObject:messageModel];
            NSLog(@"|JMSENDMESSAGE|-|SEND|%@",sendMessage);
            [weakSelf.tableView reloadData];
            
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


#pragma mark - 极光代理方法
// 接收聊天室消息
- (void)onReceiveChatRoomConversation:(JMSGConversation *)conversation
                             messages:(NSArray JMSG_GENERIC(__kindof JMSGMessage *)*)messages{
    
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
    
    NSLog(@"========^receive^text^^========%@",msgText);
}

#pragma mark - 发送消息结果回调
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

// 当前登录用户被踢、非客户端修改密码强制登出、登录状态异常、被删除、被禁用、信息变更等事件
- (void)onReceiveUserLoginStatusChangeEvent:(JMSGUserLoginStatusChangeEvent *)event{
    
    NSLog(@"==============^^信息变更^^==================%@",event);
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
        
        return 50;
        
    }else{  // 聊天tableview
        
        GPMessageModel *messageModel = self.receiveMessageArray[indexPath.row];
        
        if ([messageModel.type isEqualToString:@"0"]) {
            
            return 50;
            
        }else if ([messageModel.type isEqualToString:@"1"]){
            
            return 120;
            
        }else if ([messageModel.type isEqualToString:@"2"]){
            
            return 1;
            
        }else if([messageModel.type isEqualToString:@"3"]){
            
            return 80;
        }else{
            
            return 10;
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
                
                return secderCell;
            }else{
                return [[UITableViewCell alloc]init];
            }
        }else{  // 接收方cell
            
            if ([messageModel.type isEqualToString:@"0"]) {  // 进入房间的消息
                
                GPMsgEnterRoomCell *enterRoomCell = [tableView dequeueReusableCellWithIdentifier:@"enterRoomCell" forIndexPath:indexPath];
                
                enterRoomCell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                [enterRoomCell setDataWithModel:messageModel];
                
                return enterRoomCell;
                
            }else if ([messageModel.type isEqualToString:@"3"]){  // 推送开奖信息
                
                GPMsgSystemCell *systemCell = [tableView dequeueReusableCellWithIdentifier:@"systemCell" forIndexPath:indexPath];
                
                systemCell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                [systemCell setDataWithModel:messageModel];
                
                return systemCell;
                
            }else if ([messageModel.type isEqualToString:@"1"]){  // 下注成功后的推送
                
                GPMsgReceiveCell *receiveCell = [tableView dequeueReusableCellWithIdentifier:@"receiveCell" forIndexPath:indexPath];
                
                [receiveCell setDataWithModel:messageModel];
                
                return receiveCell;
                
            }else{
                
                return [[UITableViewCell alloc]init];
            }
            
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 点击后取消cell的点击状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 跟投点击事件
//    if (tableView.tag == 1201) {
//
//        GPMessageModel *messageModel = self.receiveMessageArray[indexPath.row];
//
//        if (![messageModel.sendType isEqualToString:@"sender"]) {
//
//            if ([messageModel.type isEqualToString:@"1"]) {
//
//                if (![messageModel.expect isEqualToString:self.expectLab.text]) {
//
//                    [ToastView toastViewWithMessage:@"只能跟投当前期" timer:3.0];
//                }else{
//
//                    self.betCopyView.hidden = NO;
//
//                    self.betCopyView.betInfoArray = @[messageModel.level,messageModel.expect,messageModel.playingType,messageModel.betAmount].mutableCopy;
//
//                    self.betAmountStr = messageModel.betAmount;
//
//                    self.playingId = messageModel.playingId;
//
//                    [self.betCopyView.tableView reloadData];
//                }
//            }
//        }
//    }
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
