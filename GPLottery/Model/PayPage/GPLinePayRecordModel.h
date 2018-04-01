//
//  GPLinePayRecordModel.h
//  GPLottery
//
//  Created by cc on 2018/3/31.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "BaseModel.h"

@interface GPLinePayRecordModel : BaseModel

@property (strong, nonatomic) NSString *dateTime;  // 存款时间
@property (strong, nonatomic) NSString *amount;       // 存款金额
@property (strong, nonatomic) NSString *accountName;   // 用户开户名
@property (strong, nonatomic) NSString *bankName;  // 银行名称
@property (strong, nonatomic) NSString *receiveBankCardAccount;       // 收款账号
@property (strong, nonatomic) NSString *type;   //
@property (strong, nonatomic) NSString *receiveBankName;  // 银行
@property (strong, nonatomic) NSString *receiveBankAddress;       // 开户行地址
@property (strong, nonatomic) NSString *transferType;   // 0:网银   1:柜台
@property (strong, nonatomic) NSString *receiveAccountName;   // 平台开户名
@property (strong, nonatomic) NSString *donationAmount;  // 赠送金额
@property (strong, nonatomic) NSString *bankCardAccount;       // 用户卡号后四位
@property (strong, nonatomic) NSString *status;   // 审核状态：0是正在审核  1是审核通过  2是拒绝

@end
