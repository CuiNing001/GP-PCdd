//
//  GPOddsInfoModel.h
//  GPLottery
//
//  Created by cc on 2018/3/24.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "BaseModel.h"

@interface GPOddsInfoModel : BaseModel

@property (strong, nonatomic) NSString *winNumber; // 开奖结果
@property (strong, nonatomic) NSString *odds;      // 开奖比率
@property (strong, nonatomic) NSString *maxAmout;  // 最大下注
@property (strong, nonatomic) NSString *playingId; // 玩法id
@property (strong, nonatomic) NSString *name;      // 玩法名称
@property (strong, nonatomic) NSString *minAmout;  // 最小下注
@property (strong, nonatomic) NSString *type;      // type
//@property (assign, nonatomic) NSString *selectState;   // 选中状态


@end
