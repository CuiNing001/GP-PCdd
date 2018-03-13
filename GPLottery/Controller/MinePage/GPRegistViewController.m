//
//  GPRegistViewController.m
//  GPLottery
//
//  Created by cc on 2018/3/13.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPRegistViewController.h"

@interface GPRegistViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTF;      // 用户名
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;      // 密码
@property (weak, nonatomic) IBOutlet UITextField *passwordAgainTF; // 密码again
@property (weak, nonatomic) IBOutlet UITextField *refereeTF;       // 推荐人

@end

@implementation GPRegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - 返回界面
- (IBAction)backToLoginPage:(UIButton *)sender {
    
    
}

#pragma mark - 注册按钮
- (IBAction)registButton:(UIButton *)sender {
    
    
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
