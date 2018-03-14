//
//  GPRegistModel.h
//  GPLottery
//
//  Created by cc on 2018/3/14.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "BaseModel.h"

@interface GPRegistModel : BaseModel

@property (strong, nonatomic) NSString *level;      // 等级
@property (strong, nonatomic) NSString *moneyNum;   // 金币
@property (strong, nonatomic) NSString *headImage;  // 头像
@property (strong, nonatomic) NSString *nickname;   // 昵称
@property (strong, nonatomic) NSString *autograph;  // 签名
@property (strong, nonatomic) NSString *id;         // id
@property (strong, nonatomic) NSString *token;      // token

@end
