//
//  GPPlayListModel.h
//  GPLottery
//
//  Created by cc on 2018/3/21.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "BaseModel.h"

@interface GPPlayListModel : BaseModel

@property (strong, nonatomic) NSString *playingTypeName; // 玩法名称
@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *onlineNum;       // 在线人数
@property (strong, nonatomic) NSString *playingImageUrl; // 背景图地址
@property (strong, nonatomic) NSString *remarkExplain;   // 左下角文字
@property (strong, nonatomic) NSString *lowestMoneyNum;  // 当前玩法进入房间最低金额

@end
