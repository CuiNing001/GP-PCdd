//
//  GPNormalPayModel.h
//  GPLottery
//
//  Created by cc on 2018/3/31.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "BaseModel.h"

@interface GPNormalPayModel : BaseModel

@property (strong, nonatomic) NSString *id;  // 1银行卡  2支付宝
@property (strong, nonatomic) NSString *accountName;  // 用户名
@property (strong, nonatomic) NSString *bankName;       // 银行名称
@property (strong, nonatomic) NSString *mesg;   // 提醒信息
@property (strong, nonatomic) NSString *bankCard;  // 银行卡号
@property (strong, nonatomic) NSString *remark; // 备注信息


@end
