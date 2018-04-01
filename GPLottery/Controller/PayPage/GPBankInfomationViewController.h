//
//  GPBankInfomationViewController.h
//  GPLottery
//
//  Created by cc on 2018/3/31.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GPBankInfomationViewController : UIViewController

@property (strong, nonatomic) NSString *accountName;  // 用户名
@property (strong, nonatomic) NSString *bankName;       // 银行名称
@property (strong, nonatomic) NSString *mesg;   // 提醒信息
@property (strong, nonatomic) NSString *bankCard;  // 银行卡号

@end
