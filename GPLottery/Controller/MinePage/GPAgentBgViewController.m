//
//  GPAgentBgViewController.m
//  GPLottery
//
//  Created by cc on 2018/3/15.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPAgentBgViewController.h"

@interface GPAgentBgViewController ()

@property (weak, nonatomic) IBOutlet UILabel *totalNumberLab;
@property (weak, nonatomic) IBOutlet UILabel *addNewNumberLab;


@end

@implementation GPAgentBgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadData];
    [self loadSubView];
}

#pragma mark - 加载数据
- (void)loadData{
    
    self.title = @"代理后台";
    
}

#pragma mark - 加载子控件
- (void)loadSubView{
    
    
}

#pragma mark - 加载网络数据
- (void)loadNetData{
    
    
}

#pragma mark - 收益分析
- (IBAction)analysisButton:(UIButton *)sender {
    
    
}

#pragma mark - 用户信息
- (IBAction)userInfoButton:(UIButton *)sender {
    
    
}

#pragma mark - 代理协议
- (IBAction)protocolButton:(UIButton *)sender {
    
    
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
