//
//  GPHistoryModel.h
//  GPLottery
//
//  Created by cc on 2018/3/15.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "BaseModel.h"

@interface GPHistoryModel : BaseModel

@property (strong, nonatomic) NSString *moneyChangeAmount; // 回水时间
@property (strong, nonatomic) NSString *createTime;        // 回水率
@property (strong, nonatomic) NSString *changeType;        // 状态

@end
