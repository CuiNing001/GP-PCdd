//
//  GPInfoModel.h
//  GPLottery
//
//  Created by cc on 2018/3/14.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "BaseModel.h"

@interface GPInfoModel : BaseModel

@property (strong, nonatomic) NSString *loginName;  // 登录名
@property (strong, nonatomic) NSString *password;   // 密码
@property (strong, nonatomic) NSString *token;      // token
@property (strong, nonatomic) NSString *nickname;   // 昵称
@property (strong, nonatomic) NSString *islogin;    // 登录状态
@property (strong, nonatomic) NSString *moneyNum;   // 玩家金币
@property (strong, nonatomic) NSString *userID;     // 玩家ID
@property (strong, nonatomic) NSString *level;      // 等级
@property (strong, nonatomic) NSString *autograph;  // 签名

@end
