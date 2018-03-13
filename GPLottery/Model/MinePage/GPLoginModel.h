//
//  GPLoginModel.h
//  GPLottery
//
//  Created by cc on 2018/3/13.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "BaseModel.h"

@interface GPLoginModel : BaseModel

@property (strong, nonatomic) NSString *level;      // 等级
@property (strong, nonatomic) NSString *moneyNum;   // 元宝
@property (strong, nonatomic) NSString *headImage;  // 头像
@property (strong, nonatomic) NSString *nickname;   // 昵称
@property (strong, nonatomic) NSString *autograph;  // 个性签名
@property (strong, nonatomic) NSString *id;         // 玩家id
@property (strong, nonatomic) NSString *token;      // token

@end
