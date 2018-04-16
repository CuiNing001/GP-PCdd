//
//  GPBetDetailModel.h
//  GPLottery
//
//  Created by cc on 2018/3/16.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "BaseModel.h"

@interface GPBetDetailModel : BaseModel

@property (strong, nonatomic) NSString *betAmout;     // 下注金额
@property (strong, nonatomic) NSString *openCode;     // 开奖结果
@property (strong, nonatomic) NSString *playingType;  // 投注类型
@property (strong, nonatomic) NSString *rewardNum;    // 中奖元宝
@property (strong, nonatomic) NSString *title;        // 标题
@property (strong, nonatomic) NSString *openTime;     // 开奖时间
@property (strong, nonatomic) NSString *openType;     // 中奖玩法
@property (strong, nonatomic) NSString *expect;       // 游戏期数

@end
