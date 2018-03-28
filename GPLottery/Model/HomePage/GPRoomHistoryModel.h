//
//  GPRoomHistoryModel.h
//  GPLottery
//
//  Created by cc on 2018/3/27.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "BaseModel.h"

@interface GPRoomHistoryModel : BaseModel

@property (strong, nonatomic) NSString *expect;   // 开奖期数
@property (strong, nonatomic) NSString *code;     // 开奖记录
@property (strong, nonatomic) NSString *codeText; // 开奖类型

@end
