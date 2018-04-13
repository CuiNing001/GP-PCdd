//
//  GPUserStatusModel.h
//  GPLottery
//
//  Created by cc on 2018/3/19.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "BaseModel.h"

@interface GPUserStatusModel : BaseModel

@property (strong, nonatomic) NSString *phoneStatus;           // 手机绑定状态
@property (strong, nonatomic) NSString *luckTurntableStatus;   // 转盘抽奖次数
@property (strong, nonatomic) NSString *userExchange;          // 提现密码绑定状态
@property (strong, nonatomic) NSString *bankStatus;            // 银行卡绑定状态
@property (strong, nonatomic) NSString *lowestMoneyNum;        // 用户进入房间最低金额

@end
