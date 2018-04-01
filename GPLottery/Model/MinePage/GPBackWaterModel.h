//
//  GPBackWaterModel.h
//  GPLottery
//
//  Created by cc on 2018/3/15.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "BaseModel.h"

@interface GPBackWaterModel : BaseModel

@property (strong, nonatomic) NSString *playingMerchantId;  // 玩法id
@property (strong, nonatomic) NSString *backWaterNum;       // 回水金额
@property (strong, nonatomic) NSString *createDate;         // 回水时间
@property (strong, nonatomic) NSString *backWaterRate;      // 回水率
@property (strong, nonatomic) NSString *status;             // 状态
@property (strong, nonatomic) NSString *agreementUrl;       // 回水规则地址

@end
