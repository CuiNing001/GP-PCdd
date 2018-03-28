//
//  GPEnterPayModel.h
//  GPLottery
//
//  Created by cc on 2018/3/28.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "BaseModel.h"

@interface GPEnterPayModel : BaseModel

@property (strong, nonatomic) NSString *remindText;  // 提醒
@property (strong, nonatomic) NSString *money;       // 余额
@property (strong, nonatomic) NSString *loginName;   // 账号


@end
