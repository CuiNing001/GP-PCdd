//
//  GPMessageModel.h
//  GPLottery
//
//  Created by cc on 2018/3/26.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "BaseModel.h"

@interface GPMessageModel : BaseModel

@property (strong, nonatomic) NSString *level;   // 用户等级
@property (strong, nonatomic) NSString *name;    // 用户昵称
@property (strong, nonatomic) NSString *type;    // 消息类型
@property (strong, nonatomic) NSString *value;   // 开奖内容
@property (strong, nonatomic) NSString *expect;  // 开奖期数
@property (strong, nonatomic) NSString *playingType; // 下注类型
@property (strong, nonatomic) NSString *betAmount;   // 下注金额
@property (strong, nonatomic) NSString *fromName;    // 接收方名称
@property (strong, nonatomic) NSString *timestamp;   // 消息发出的时间戳

@end
