//
//  GPRespondModel.h
//  GPLottery
//
//  Created by cc on 2018/3/13.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "BaseModel.h"

@interface GPRespondModel : BaseModel

/*
 * 通用model：注册、修改密码、修改昵称、设置昵称、直接开户、提现、绑定手机号、设置提现密码、修改提现密码、绑定银行卡
 */
@property (strong, nonatomic) NSString *code;
@property (strong, nonatomic) NSString *data;
@property (strong, nonatomic) NSString *msg;
@property (strong, nonatomic) NSString *success;

@end
