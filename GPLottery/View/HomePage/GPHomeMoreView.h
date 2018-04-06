//
//  GPHomeMoreView.h
//  GPLottery
//
//  Created by cc on 2018/4/6.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GPHomeMoreView : UIView

- (instancetype)initWithFrame:(CGRect)frame;

@property (copy, nonatomic) void(^rechargeBlock)(void); // 充值
@property (copy, nonatomic) void(^withdrawBlock)(void); // 提现

@end
