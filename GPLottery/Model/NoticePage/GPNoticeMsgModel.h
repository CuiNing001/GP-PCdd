//
//  GPNoticeMsgModel.h
//  GPLottery
//
//  Created by cc on 2018/3/28.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "BaseModel.h"

@interface GPNoticeMsgModel : BaseModel

@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *title;       // 标题
@property (strong, nonatomic) NSString *status;      // 读取状态 ：1已读，2未读
@property (strong, nonatomic) NSString *createDate;  // 创建时间

@end
