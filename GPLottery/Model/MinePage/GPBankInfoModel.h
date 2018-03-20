//
//  GPBankInfoModel.h
//  GPLottery
//
//  Created by cc on 2018/3/20.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "BaseModel.h"

@interface GPBankInfoModel : BaseModel

@property (strong, nonatomic) NSString *accountName;  // 开户姓名
@property (strong, nonatomic) NSString *bankName;     // 银行名称
@property (strong, nonatomic) NSString *bankCard;     // 银行卡号
@property (strong, nonatomic) NSString *bankAddress;  // 银行地址

@end
