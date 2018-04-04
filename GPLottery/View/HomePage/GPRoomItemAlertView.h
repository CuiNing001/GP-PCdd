//
//  GPRoomItemAlertView.h
//  GPLottery
//
//  Created by cc on 2018/4/3.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GPRoomItemAlertView : UIView

- (instancetype)initWithFrame:(CGRect)frame;

@property (copy, nonatomic) void(^recordBtnBlock)(void); // 投注记录
@property (copy, nonatomic) void(^insBtnBlock)(void);    // 玩法说明
@property (copy, nonatomic) void(^trendBtnBlock)(void);  // 走势图

@end
