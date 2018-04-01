//
//  GPAgentUserInfoModel.h
//  GPLottery
//
//  Created by cc on 2018/3/30.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "BaseModel.h"

@interface GPAgentUserInfoModel : BaseModel

@property (strong, nonatomic) NSString *profitLossQuota; // 盈亏额
@property (strong, nonatomic) NSString *userName;        // 用户名
@property (strong, nonatomic) NSString *nickName;        // 昵称

@end
