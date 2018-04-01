//
//  GPEarningsModel.h
//  GPLottery
//
//  Created by cc on 2018/3/30.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "BaseModel.h"

@interface GPEarningsModel : BaseModel

@property (strong, nonatomic) NSString *betAmount;  // 会员下注
@property (strong, nonatomic) NSString *level;      // 会员等级
@property (strong, nonatomic) NSString *commission; // 佣金级别
@property (strong, nonatomic) NSString *createDate; // 创建时间

@end
