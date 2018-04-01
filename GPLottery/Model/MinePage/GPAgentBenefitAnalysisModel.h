//
//  GPAgentBenefitAnalysisModel.h
//  GPLottery
//
//  Created by cc on 2018/3/30.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "BaseModel.h"

@interface GPAgentBenefitAnalysisModel : BaseModel

@property (strong, nonatomic) NSString *memberUserSum; // 会员数量
@property (strong, nonatomic) NSString *profitLossQuota; // 盈亏额度
@property (strong, nonatomic) NSString *createDate;  // 创建时间
@property (strong, nonatomic) NSString *status;      // 失效字段

@end
