//
//  GPBindBancCardViewController.m
//  GPLottery
//
//  Created by cc on 2018/3/19.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPBindBancCardViewController.h"
#import "GPChooseBankCell.h"

static int chooseNum = 0;
@interface GPBindBancCardViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) MBProgressHUD  *progressHUD;
@property (strong, nonatomic) GPInfoModel    *infoModel;
@property (strong, nonatomic) NSString       *token;


@property (weak, nonatomic) IBOutlet UIView *bankTypeView;

@property (weak, nonatomic) IBOutlet UITextField *accountNameTF;      // 开户姓名
@property (weak, nonatomic) IBOutlet UITextField *bankNumberTF;       // 银行卡号
@property (weak, nonatomic) IBOutlet UITextField *bankAddressTF;      // 开户地址
@property (weak, nonatomic) IBOutlet UITextField *bankPasswordTF;     // 提现密码
@property (weak, nonatomic) IBOutlet UITableView *bankTypeTableView;  // 银行类型选择框
@property (weak, nonatomic) IBOutlet UILabel     *bankNameLab;        // 银行名称
@property (strong, nonatomic) NSMutableArray     *bankTypeArray;      // 银行类型

@end

@implementation GPBindBancCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadSubView];
    [self loadData];
}

- (void)loadData{
    
    // 添加代理
    [self addDelegate];
    
    // 获取可用银行信息
    [self bankTypeData];
    
}

- (void)loadSubView{
    
    self.title = @"绑定银行卡";
    
    // 点击空白区域回收键盘
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(returnKeyboard)];
//    [self.view addGestureRecognizer:tap];
    
    // 初始化加载框
    self.progressHUD = [[MBProgressHUD alloc]initWithFrame:CGRectMake(0, 0, kSize_width, kSize_height)];
    [self.view addSubview:_progressHUD];
    
    // 注册cell
    [self.bankTypeTableView registerNib:[UINib nibWithNibName:@"GPChooseBankCell" bundle:nil] forCellReuseIdentifier:@"chooseBankCell"];

}


#pragma mark - 可用银行信息
- (void)bankTypeData{
    
    [self.progressHUD showAnimated:YES];
    
    [self loadUserDefaultsData];
    
    NSString *bankTypeLoc = [NSString stringWithFormat:@"%@user/1/myAvailableBank",kBaseLocation];
    
    // 请求登陆接口
    __weak typeof(self)weakSelf = self;
    [AFNetManager requestPOSTWithURLStr:bankTypeLoc paramDic:nil token:self.token finish:^(id responserObject) {
        
        NSLog(@"|BINDBANK-VC|success:%@",responserObject);
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        NSString *code     = [NSString stringWithFormat:@"%@",[responserObject objectForKey:@"code"]];
        NSString *msg      = [responserObject objectForKey:@"msg"];
        NSArray *dataArray = [responserObject objectForKey:@"data"];
        
        if (code.integerValue == 9200) {
            
            [ToastView toastViewWithMessage:msg timer:3.0];
            
            for (NSString *bankStr in dataArray) {
                
                [self.bankTypeArray addObject:bankStr];
            }
            [self.bankTypeTableView reloadData];
        }else{
            
            [ToastView toastViewWithMessage:msg timer:3.0];
        }
        
    } enError:^(NSError *error) {
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        [ToastView toastViewWithMessage:@"数据连接出错，请稍后再试" timer:3.0];
        
    }];
}

#pragma mark - 选择银行
- (IBAction)chooseBankNameTap:(UITapGestureRecognizer *)sender {
    
    chooseNum++;
    
    if (chooseNum%2==0) {
        
        self.bankTypeTableView.hidden = YES;
    }else{
        
        self.bankTypeTableView.hidden = NO;
    }
}


#pragma mark - 确定绑定银行卡
- (IBAction)makeSureButton:(UIButton *)sender {
    
    // 输入内容不为空
    if (![self.accountNameTF.text isEqualToString:@""]&&![self.bankNameLab.text isEqualToString:@""]&&![self.bankNumberTF.text isEqualToString:@""]&&![self.bankAddressTF.text isEqualToString:@""]&&![self.bankPasswordTF.text isEqualToString:@""]) {
        
        [self.progressHUD showAnimated:YES];
        
        [self loadUserDefaultsData];
        
        NSString *bindBankLoc = [NSString stringWithFormat:@"%@user/1/bindBankCard",kBaseLocation];
        NSDictionary *paramDic = @{@"accountName":self.accountNameTF.text,
                                   @"bankName":self.bankNameLab.text,
                                   @"bankAddress":self.bankAddressTF.text,
                                   @"bankCardAccount":self.bankAddressTF.text,
                                   @"withdrawalsPassword":self.bankPasswordTF.text};
        
        // 请求登陆接口
        __weak typeof(self)weakSelf = self;
        [AFNetManager requestPOSTWithURLStr:bindBankLoc paramDic:paramDic token:self.token finish:^(id responserObject) {
            
            NSLog(@"|LOGIN-VC|success:%@",responserObject);
            
            [weakSelf.progressHUD hideAnimated:YES];
            
            GPRespondModel *respondModel = [GPRespondModel new];
            
            [respondModel setValuesForKeysWithDictionary:responserObject];
            
            if (respondModel.code.integerValue == 9200) {
                
                [ToastView toastViewWithMessage:respondModel.msg timer:3.0];
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }else{
                
                [ToastView toastViewWithMessage:respondModel.msg timer:3.0];
            }
            
        } enError:^(NSError *error) {
            
            [weakSelf.progressHUD hideAnimated:YES];
            
            [ToastView toastViewWithMessage:@"数据连接出错，请稍后再试" timer:3.0];
            
        }];
        
    }else{
        
        [ToastView toastViewWithMessage:@"请补全银行卡信息" timer:3.0];
    }
    
}


#pragma mark - 回收键盘
- (void)returnKeyboard{
    
    // 点击空白区域回收键盘
    [self.accountNameTF  resignFirstResponder];
    [self.bankNumberTF   resignFirstResponder];
    [self.bankAddressTF  resignFirstResponder];
    [self.bankPasswordTF resignFirstResponder];
}

#pragma mark - text field delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    // 输入结束回收键盘
    [textField resignFirstResponder];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // 禁止输入空格
    NSString *tem = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]componentsJoinedByString:@""];
    if (![string isEqualToString:tem]) {
        return NO;
    }
    return YES;
}

#pragma mark - tableview data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.bankTypeArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GPChooseBankCell *chooseBankCell = [tableView dequeueReusableCellWithIdentifier:@"chooseBankCell" forIndexPath:indexPath];
    
    NSString *bankTypeStr = self.bankTypeArray[indexPath.row];
    
    [chooseBankCell setDataWithBankName:bankTypeStr];
    
    return chooseBankCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    chooseNum++;
    
    self.bankTypeTableView.hidden = YES;
    
    NSString *bankTypeStr = self.bankTypeArray[indexPath.row];
    
    self.bankNameLab.text = bankTypeStr;
}

#pragma mark - 加载本地数据
- (void)loadUserDefaultsData{
    
    NSMutableDictionary *infoDic = [UserDefaults searchData];
    
    self.infoModel               = [[GPInfoModel alloc]init];
    
    [self.infoModel setValuesForKeysWithDictionary:infoDic];
    
    self.token = self.infoModel.token;
    
}

#pragma mark - 添加代理
- (void)addDelegate{
    
    // tableview代理
    self.bankTypeTableView.delegate   = self;
    self.bankTypeTableView.dataSource = self;
    
    // textField代理
    self.accountNameTF.delegate  = self;
    self.bankNumberTF.delegate   = self;
    self.bankAddressTF.delegate  = self;
    self.bankPasswordTF.delegate = self;
}

#pragma mark - 懒加载
- (NSMutableArray *)bankTypeArray{
    
    if (!_bankTypeArray) {
        
        self.bankTypeArray = [NSMutableArray array];
    }
    return _bankTypeArray;
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
