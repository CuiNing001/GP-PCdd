//
//  GPLuckyModel.h
//  GPLottery
//
//  Created by cc on 2018/3/21.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "BaseModel.h"

@interface GPLuckyModel : BaseModel

@property (strong, nonatomic) NSString *createTime;      // 抽奖时间
@property (strong, nonatomic) NSString *luckyMoneyLevel; // 红包等级
@property (strong, nonatomic) NSString *extractAmount;   // 金额

@end
