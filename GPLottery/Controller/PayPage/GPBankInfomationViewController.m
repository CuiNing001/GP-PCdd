//
//  GPBankInfomationViewController.m
//  GPLottery
//
//  Created by cc on 2018/3/31.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPBankInfomationViewController.h"
#import "GPTransferTypeCell.h"

static int touch = 0;
@interface GPBankInfomationViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (strong, nonatomic) GPInfoModel *infoModel;            // 本地数据
@property (strong, nonatomic) MBProgressHUD *progressHUD;
@property (strong, nonatomic) NSString *token;

@property (weak, nonatomic) IBOutlet UILabel *bankCardLab;    // 银行名称
@property (weak, nonatomic) IBOutlet UILabel *accountNameLab; // 收款人
@property (weak, nonatomic) IBOutlet UILabel *cardNumberLab;  // 账号
@property (weak, nonatomic) IBOutlet UILabel *bankAddressLab; // 开户行
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *bankNameTF;   // 银行名称
@property (weak, nonatomic) IBOutlet UITextField *accountNameTF; // 存款人姓名
@property (weak, nonatomic) IBOutlet UITextField *bankNumberTF;  // 存款人卡号
@property (weak, nonatomic) IBOutlet UITextField *amountTF;      // 存款金额
@property (weak, nonatomic) IBOutlet UILabel *transferTypeLab;    // 存款方式
@property (strong, nonatomic) NSMutableArray *transferArray;   // 存款方式
@property (strong, nonatomic) NSString *type;

@end

@implementation GPBankInfomationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"填写存款信息";
    
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
    
    self.transferArray = @[@"网银转账",@"柜台转账"].mutableCopy;
}

- (void)loadSubView{
    
    self.automaticallyAdjustsScrollViewInsets = false;
    
    [self setTextFieldDelegate];
    
    // 初始化加载框
    self.progressHUD = [[MBProgressHUD alloc]initWithFrame:CGRectMake(0, 0, kSize_width, kSize_height)];
    [self.view addSubview:_progressHUD];
    
    // table view 代理
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    
    // tableView样式
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"GPTransferTypeCell" bundle:nil] forCellReuseIdentifier:@"transferCell"];
    
    // 添加空白区域点击事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(returnKeyboard)];
//    [self.view addGestureRecognizer:tap];
    
    self.bankCardLab.text = self.bankName;
    self.accountNameLab.text = self.accountName;
    self.bankAddressLab.text = self.mesg;
    self.cardNumberLab.text = self.bankCard;
    
}

#pragma mark - 复制收款人名字
- (IBAction)accountNameCopyButton:(UIButton *)sender {
    
    UIPasteboard *pastboard = [UIPasteboard generalPasteboard];
    
    pastboard.string = self.accountNameLab.text;
    
    [ToastView toastViewWithMessage:@"收款人已复制" timer:3.0];
}

#pragma mark - 复制银行账号
- (IBAction)cardNumberCopyButton:(UIButton *)sender {
    
    UIPasteboard *pastboard = [UIPasteboard generalPasteboard];
    
    pastboard.string = self.cardNumberLab.text;
    
    [ToastView toastViewWithMessage:@"卡号已复制" timer:3.0];
}

#pragma mark - 选择存款方式
- (IBAction)typeButton:(UIButton *)sender {
    
    touch++;
    
    if (touch%2==0) {
        
        self.tableView.hidden = YES;
    }else{
        self.tableView.hidden = NO;
    }
}

#pragma mark - 提交
- (IBAction)makeSureButton:(UIButton *)sender {
    
    [self.progressHUD showAnimated:YES];
    
    [self loadUserDefaultsData];
    
    if ([self.transferTypeLab.text isEqualToString:@"网银转账"]) {
        
        self.type = @"0";
    }else{
        
        self.type = @"1";
    }
    
    NSString *bankName = [NSString stringWithFormat:@"%@",self.bankNameTF.text];
    NSString *bankNumber = [NSString stringWithFormat:@"%@",self.bankNumberTF.text];
    NSString *amount = [NSString stringWithFormat:@"%@",self.amountTF.text];
    NSString *accountName = [NSString stringWithFormat:@"%@",self.accountNameTF.text];
    NSString *bankInfoLoc = [NSString stringWithFormat:@"%@pay/1/fillBankPayInfoSubmit",kBaseLocation];
    
    NSDictionary *paramDic = @{@"bankName":bankName,@"bankCardAccount":bankNumber,@"amount":amount,@"accountName":accountName,@"transferType":self.type};
    
//     请求登陆接口
    __weak typeof(self)weakSelf = self;
    [AFNetManager requestPOSTWithURLStr:bankInfoLoc paramDic:paramDic token:self.token finish:^(id responserObject) {

        NSLog(@"|BANK-INFO-VC|success:%@",responserObject);

        [weakSelf.progressHUD hideAnimated:YES];

        GPRespondModel *respondModel = [GPRespondModel new];

        [respondModel setValuesForKeysWithDictionary:responserObject];

        if (respondModel.code.integerValue == 9200) {

            [ToastView toastViewWithMessage:respondModel.msg timer:1.5];
            
            [weakSelf.navigationController popViewControllerAnimated:YES];

        }else{

            [ToastView toastViewWithMessage:respondModel.msg timer:2.5];
        }

    } enError:^(NSError *error) {

        [weakSelf.progressHUD hideAnimated:YES];

        [ToastView toastViewWithMessage:@"数据连接出错，请稍后再试" timer:3.0];

    }];
    
}

#pragma mark - tableview代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.transferArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 35;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GPTransferTypeCell *transferCell = [tableView dequeueReusableCellWithIdentifier:@"transferCell" forIndexPath:indexPath];
    
    transferCell.transferLab.text = self.transferArray[indexPath.row];
    
    return transferCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    touch++;
    self.tableView.hidden = YES;
    self.transferTypeLab.text = self.transferArray[indexPath.row];
    
}

#pragma mark - 添加输入框代理
- (void)setTextFieldDelegate{
    
    self.bankNameTF.delegate = self;
    self.accountNameTF.delegate = self;
    self.bankNumberTF.delegate = self;
    self.amountTF.delegate = self;
}

#pragma mark - 回收键盘
- (void)returnKeyboard{
    
    // 点击空白区域回收键盘
    [self.bankNameTF resignFirstResponder];
    [self.accountNameTF resignFirstResponder];
    [self.bankNumberTF resignFirstResponder];
    [self.amountTF resignFirstResponder];
}

#pragma mark - 输入框代理方法
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

#pragma mark - 加载本地数据
- (void)loadUserDefaultsData{
    
    NSMutableDictionary *infoDic = [UserDefaults searchData];
    
    self.infoModel               = [[GPInfoModel alloc]init];
    
    [self.infoModel setValuesForKeysWithDictionary:infoDic];
    
    self.token = self.infoModel.token;
    
}

#pragma mark - 懒加载
- (NSMutableArray *)transferArray{
    
    if (!_transferArray) {
        
        self.transferArray = [NSMutableArray array];
    }
    return _transferArray;
}


#pragma mark -
- (void)postAsynWithURL:(NSURL*)aURL parems:(NSDictionary *)postParems compile:(void(^)(id response, NSData *data, NSError *error))block{
    
    NSString * parameterStr = @"";
    
    for (NSString * key  in postParems) {
        
        NSString * content = postParems[key];
        
        if ([content isKindOfClass:[NSDictionary class]] || [content isKindOfClass:[NSArray class]]) {
            
            NSData * data = [NSJSONSerialization dataWithJSONObject:content options:0 error:nil];
            
            content = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            
        }
        
        if (content.length > 0) {
            
            parameterStr = [NSString stringWithFormat:@"%@&%@=%@",parameterStr,key,content];
            
        }
        
    }
    
    if ([parameterStr hasPrefix:@"&"]) {
        
        parameterStr = [parameterStr substringFromIndex:1];
        
    }
    
    NSData * postData = [parameterStr dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%@",@([postData length])];
    
    //    NSLog(@"url_parameterStr : %@",parameterStr);
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:aURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5];
    
    [request setHTTPMethod:@"POST"];
    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [request setHTTPBody:postData];
    
    NSLog(@"|---BANKINFOR---|%@",postData);
    
    [request setValue:self.token forHTTPHeaderField:@"token"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (!connectionError) {
            
            id resultDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&connectionError];
            
            block(resultDic,data,connectionError);
            
        }else{
            
            block(nil,data,connectionError);
            
        }
        
    }];
    
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
