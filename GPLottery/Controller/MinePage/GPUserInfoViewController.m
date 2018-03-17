//
//  GPUserInfoViewController.m
//  GPLottery
//
//  Created by cc on 2018/3/17.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPUserInfoViewController.h"

@interface GPUserInfoViewController ()

@end

@implementation GPUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"用户信息";
}


#pragma mark - 游戏类型
- (IBAction)gameTypeTap:(UITapGestureRecognizer *)sender {
}

#pragma mark - 开始时间
- (IBAction)startTimeTap:(UITapGestureRecognizer *)sender {
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
