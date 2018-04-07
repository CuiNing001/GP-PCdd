//
//  GPHomeLeftItemView.h
//  GPLottery
//
//  Created by cc on 2018/4/7.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GPHomeLeftItemView : UIView

@property (weak, nonatomic) IBOutlet UILabel *nickNameLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (copy, nonatomic) void(^dissmissBlock)(void);   // 关闭页面
@property (copy, nonatomic) void(^topUpBlock)(void);      // 充值
@property (copy, nonatomic) void(^withdrawalBlock)(void); // 提现
@property (copy, nonatomic) void(^myWalletBlock)(void);   // 我的钱包
@property (copy, nonatomic) void(^myMessageBlock)(void);  // 我的消息

- (instancetype)initWithFrame:(CGRect)frame;

@end
