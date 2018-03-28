//
//  GPNoticeDetailViewController.h
//  GPLottery
//
//  Created by cc on 2018/3/28.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GPNoticeDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSString *contentStr;  // 数据地址
@property (strong, nonatomic) NSString *contentId;   // 数据id
@property (strong, nonatomic) NSString *titleStr;    // 标题
@property (strong, nonatomic) NSString *timeStr;     // 时间



@end
