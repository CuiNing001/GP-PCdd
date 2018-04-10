//
//  GPRechargeModel.h
//  GPLottery
//
//  Created by cc on 2018/3/20.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "BaseModel.h"

@interface GPRechargeModel : BaseModel

@property (strong, nonatomic) NSString *amount;      // 充值金额
@property (strong, nonatomic) NSString *time;        // 充值时间
@property (strong, nonatomic) NSString *type;        // 充值状态
@property (strong, nonatomic) NSString *paymentType; // 充值方式
@property (strong, nonatomic) NSString *status;      // 1：未审核  2：审核通过  3：审核不通过

@end
