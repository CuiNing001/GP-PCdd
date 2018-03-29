//
//  GPServiceViewController.m
//  GPLottery
//
//  Created by cc on 2018/3/22.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPServiceViewController.h"

@interface GPServiceViewController ()

@end

@implementation GPServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"客服";
}

#pragma mark - 发送消息结果回调
- (void)onSendMessageResponse:(JMSGMessage *)message error:(NSError *)error{
    
    
}

#pragma mark - 接收消息回调
- (void)onReceiveMessage:(JMSGMessage *)message error:(NSError *)error{
    
    JMSGTextContent *textContent = (JMSGTextContent *)message;
    
    NSString *msgText = textContent.text;
    
    NSLog(@"客服接收消息%@",msgText);
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
