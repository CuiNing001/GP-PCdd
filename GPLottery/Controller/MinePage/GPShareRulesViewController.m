//
//  GPShareRulesViewController.m
//  GPLottery
//
//  Created by cc on 2018/3/31.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPShareRulesViewController.h"
#import "GPNormalUserModel.h"
#import "GPNormalUserCell.h"

@interface GPShareRulesViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *ruleNumOneLab;
@property (weak, nonatomic) IBOutlet UILabel *ruleNumTwoLab;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *normalUserArray; // 普通用户数据
@property (strong, nonatomic) MBProgressHUD      *progressHUD;
@property (strong, nonatomic) GPInfoModel        *infoModel;
@property (strong, nonatomic) NSString           *token;


@end

@implementation GPShareRulesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadData];
    [self loadSubView];
}

#pragma mark - 加载数据
- (void)loadData{
    
    self.title = @"分享规则";
    
    // 普通用户数据
    [self loadNormalUserData];
    
    [self loadUserDefaultsData];
}

#pragma mark - 加载子控件
- (void)loadSubView{
    
    // table view 代理
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"GPNormalUserCell" bundle:nil] forCellReuseIdentifier:@"normalUserCell"];
    
    // tableView样式
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

#pragma mark- 普通用户分享规则
- (void)loadNormalUserData{
    
    [self.progressHUD showAnimated:YES];
    
    [self loadUserDefaultsData];
    
    NSString *normalUserLoc = [NSString stringWithFormat:@"%@member/1/memberRule",kBaseLocation];
    
    // 请求登陆接口
    __weak typeof(self)weakSelf = self;
    [AFNetManager requestPOSTWithURLStr:normalUserLoc paramDic:nil token:self.token finish:^(id responserObject) {
        
        NSLog(@"|AGENTOPEN-VC|success:%@",responserObject);
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        GPRespondModel *respondModel = [GPRespondModel new];
        
        [respondModel setValuesForKeysWithDictionary:responserObject];
        
        if (respondModel.code.integerValue == 9200) {
            
//            [ToastView toastViewWithMessage:respondModel.msg timer:1.5];
            
            // 普通用户数据赋值
            weakSelf.ruleNumOneLab.text = [respondModel.data objectForKey:@"notice1"];
            weakSelf.ruleNumTwoLab.text = [respondModel.data objectForKey:@"notice2"];
            
            NSMutableArray *dataArr = [respondModel.data objectForKey:@"date1"];
            
            for (NSDictionary *dataDic in dataArr) {
                
                GPNormalUserModel *userModel = [GPNormalUserModel new];
                
                [userModel setValuesForKeysWithDictionary:dataDic];
                
                [weakSelf.normalUserArray addObject:userModel];
            }
            [weakSelf.tableView reloadData];
            
        }else{
            
            [ToastView toastViewWithMessage:respondModel.msg timer:2.5];
        }
        
    } enError:^(NSError *error) {
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        [ToastView toastViewWithMessage:@"数据连接出错，请稍后再试" timer:3.0];
        
    }];
}

#pragma mark - 加载本地数据
- (void)loadUserDefaultsData{
    
    NSMutableDictionary *infoDic = [UserDefaults searchData];
    
    self.infoModel               = [[GPInfoModel alloc]init];
    
    [self.infoModel setValuesForKeysWithDictionary:infoDic];
    
    self.token = self.infoModel.token;
    
}
#pragma mark - tableview 数据代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.normalUserArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GPNormalUserCell *normalUserCell = [tableView dequeueReusableCellWithIdentifier:@"normalUserCell" forIndexPath:indexPath];
    
    normalUserCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (self.normalUserArray.count>0) {
        
        GPNormalUserModel *normalUserModel = self.normalUserArray[indexPath.row];
        
        [normalUserCell setDataWithModel:normalUserModel];
    }
    
    return normalUserCell;
}

#pragma mark - 懒加载
- (NSMutableArray *)normalUserArray{
    
    if (!_normalUserArray) {
        
        self.normalUserArray = [NSMutableArray array];
    }
    return _normalUserArray;
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
