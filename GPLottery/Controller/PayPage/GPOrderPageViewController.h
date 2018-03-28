//
//  GPOrderPageViewController.h
//  GPLottery
//
//  Created by cc on 2018/3/28.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GPOrderPageViewController : UIViewController

@property (strong, nonatomic) NSString *orderType;  // 订单类型（微信2，支付宝1）
@property (strong, nonatomic) NSString *orderMoney; // 支付金额
@property (strong, nonatomic) NSString *titleStr;   //
@property (strong, nonatomic) NSString *payUrl;     // 支付链接
@property (strong, nonatomic) NSString *orderID;    // 订单id

@end
