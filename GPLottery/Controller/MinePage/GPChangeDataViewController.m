//
//  GPChangeDataViewController.m
//  GPLottery
//
//  Created by cc on 2018/3/14.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPChangeDataViewController.h"

@interface GPChangeDataViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel     *usernameLab;     // 用户名
@property (weak, nonatomic) IBOutlet UITextField *nicknameTF;      // 昵称
@property (weak, nonatomic) IBOutlet UITextField *signatureTF;     // 个性签名
@property (strong, nonatomic) MBProgressHUD      *progressHUD;     // 加载框
@property (strong, nonatomic) GPInfoModel        *infoModel;       // 本地数据
@property (strong, nonatomic) NSString           *changeDataLoc;   // 修改资料地址
@property (strong, nonatomic) NSString           *token;           // token
@property (strong, nonatomic) NSDictionary       *paramDic;        // 参数
@property (strong, nonatomic) NSString           *nickName;        // 昵称
@property (strong, nonatomic) NSString           *autograph;       // 个性签名

@end

@implementation GPChangeDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    [self loadSubView];
}

- (void)loadData{
    
    self.title = @"修改资料";
    
    self.usernameLab.text = self.username;
    
}

- (void)loadSubView{
    
    [self setTextFieldDelegate];   // 添加输入框代理
    
    // 添加空白区域点击事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(returnKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    // 初始化加载框
    self.progressHUD = [[MBProgressHUD alloc]initWithFrame:CGRectMake(0, 0, kSize_width, kSize_height)];
    [self.view addSubview:_progressHUD];
}

#pragma mark - 确定修改
- (IBAction)makeSureButton:(UIButton *)sender {
    
    [self.progressHUD showAnimated:YES];
    
    // 加载本地数据
    [self loadUserDefaultsData];
    
    // 请求登陆接口
    __weak typeof(self)weakSelf = self;
    [AFNetManager requestPOSTWithURLStr:weakSelf.changeDataLoc paramDic:weakSelf.paramDic token:weakSelf.token finish:^(id responserObject) {
        
        NSLog(@"|LOGIN-VC|success:%@",responserObject);
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        GPRespondModel *respondModel = [GPRespondModel new];
        
        [respondModel setValuesForKeysWithDictionary:responserObject];
        
        if (respondModel.code.integerValue == 9200) {
            
            [ToastView toastViewWithMessage:respondModel.msg timer:3.0];
            
        }else{
            
            [ToastView toastViewWithMessage:respondModel.msg timer:3.5];
        }
        
    } enError:^(NSError *error) {
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        [ToastView toastViewWithMessage:@"数据连接出错，请稍后再试" timer:3.0];
        
    }];
    
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

#pragma mark - 回收键盘
- (void)returnKeyboard{
    
    // 点击空白区域回收键盘
    [self.nicknameTF resignFirstResponder];
    [self.signatureTF resignFirstResponder];
}

#pragma mark - 添加输入框代理
- (void)setTextFieldDelegate{
    
    self.nicknameTF.delegate = self;
    self.signatureTF.delegate = self;
}

#pragma mark - 加载本地数据
- (void)loadUserDefaultsData{
    
    NSMutableDictionary *infoDic = [UserDefaults searchData];
    
    self.infoModel               = [[GPInfoModel alloc]init];
    
    [self.infoModel setValuesForKeysWithDictionary:infoDic];
    
    self.changeDataLoc = [NSString stringWithFormat:@"%@user/1/updateNickname",kBaseLocation];
    self.nickName      = self.nicknameTF.text;
    self.autograph     = self.signatureTF.text;
    self.token         = self.infoModel.token;
    self.paramDic = @{@"nickName"  :self.nickName,
                      @"autograph" :self.autograph
                      };

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
