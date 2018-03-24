//
//  GPEnterRoomInfoModel.h
//  GPLottery
//
//  Created by cc on 2018/3/24.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "BaseModel.h"

@interface GPEnterRoomInfoModel : BaseModel

@property (strong, nonatomic) NSDictionary *playingList;// 投注点选选项
@property (strong, nonatomic) NSString *level;          // 用户等级
@property (strong, nonatomic) NSString *moneyNum;       // 用户金币
@property (strong, nonatomic) NSString *isCloseAccount; // 是否关闭算账
@property (strong, nonatomic) NSArray  *history;        // 开奖历史
@property (strong, nonatomic) NSString *isSilent;       // 是否禁言
@property (strong, nonatomic) NSDictionary *coming;     // 下期数据

@end
