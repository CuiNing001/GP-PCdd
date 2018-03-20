//
//  GPWithdrawInfoModel.h
//  GPLottery
//
//  Created by cc on 2018/3/20.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "BaseModel.h"

@interface GPWithdrawInfoModel : BaseModel

@property (strong, nonatomic) NSString *withdrawRemind;  // 提醒
@property (strong, nonatomic) NSString *accountName;     // 开户名
@property (strong, nonatomic) NSString *withdrawExplain; // 提现须知
@property (strong, nonatomic) NSString *bankName;        // 银行名称
@property (strong, nonatomic) NSString *bankCardAccount; // 卡号


@end
