//
//  GPMineViewController.m
//  GPLottery
//
//  Created by cc on 2018/3/11.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPMineViewController.h"

@interface GPMineViewController ()
@property (weak, nonatomic) IBOutlet UIView *headerView;      // headerView
@property (weak, nonatomic) IBOutlet UITableView *tableView;  // tableView
@property (weak, nonatomic) IBOutlet UIButton *userImageBtn;  // 头像按钮
@property (weak, nonatomic) IBOutlet UIView *nickView;        // 昵称、签名view
@property (weak, nonatomic) IBOutlet UILabel *nickNameLab;    // 昵称lable
@property (weak, nonatomic) IBOutlet UILabel *signatureLabel; // 签名label



@end

@implementation GPMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    [self loadSubView];

}

#pragma mark - 加载子控件
- (void)loadSubView{
    
    // 修改资料view添加点击事件
    UITapGestureRecognizer *dataTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeData)];
    [self.nickView addGestureRecognizer:dataTap];
    
}

#pragma mark - 加载数据
- (void)loadData{
    
}

#pragma mark - 修改头像
- (IBAction)changeUserImageBtn:(UIButton *)sender {
}

#pragma mark - 修改资料
- (void)changeData{
    
    NSLog(@"changeData");
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
