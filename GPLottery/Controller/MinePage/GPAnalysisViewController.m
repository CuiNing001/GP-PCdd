//
//  GPAnalysisViewController.m
//  GPLottery
//
//  Created by cc on 2018/3/17.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPAnalysisViewController.h"

@interface GPAnalysisViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *settlementBtn;
@property (weak, nonatomic) IBOutlet UIButton *noSettlementBtn;


@end

@implementation GPAnalysisViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"收益分析";
}

#pragma mark - 已结算
- (IBAction)hasBeenButton:(UIButton *)sender {
    
    // 修改点击状态
    self.settlementBtn.backgroundColor    = [UIColor colorWithRed:223/255.0 green:229/255.0 blue:233/255.0 alpha:1];
    self.noSettlementBtn.backgroundColor = [UIColor colorWithRed:193/255.0 green:193/255.0 blue:193/255.0 alpha:1];
    [self.settlementBtn setTitleColor:[UIColor colorWithRed:26/255.0 green:198/255.0 blue:133/255.0 alpha:1] forState:UIControlStateNormal];
    [self.noSettlementBtn setTitleColor:[UIColor colorWithRed:69/255.0 green:69/255.0 blue:69/255.0 alpha:1] forState:UIControlStateNormal];
    
}

#pragma mark - 未结算
- (IBAction)noSettlementButton:(UIButton *)sender {
    
    // 修改点击状态
    self.noSettlementBtn.backgroundColor    = [UIColor colorWithRed:223/255.0 green:229/255.0 blue:233/255.0 alpha:1];
    self.settlementBtn.backgroundColor = [UIColor colorWithRed:193/255.0 green:193/255.0 blue:193/255.0 alpha:1];
    [self.noSettlementBtn setTitleColor:[UIColor colorWithRed:26/255.0 green:198/255.0 blue:133/255.0 alpha:1] forState:UIControlStateNormal];
    [self.settlementBtn setTitleColor:[UIColor colorWithRed:69/255.0 green:69/255.0 blue:69/255.0 alpha:1] forState:UIControlStateNormal];
    
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
