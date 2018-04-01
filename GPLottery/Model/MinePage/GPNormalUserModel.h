//
//  GPNormalUserModel.h
//  GPLottery
//
//  Created by cc on 2018/3/30.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "BaseModel.h"

@interface GPNormalUserModel : BaseModel

@property (strong, nonatomic) NSString *level;       // 级别
@property (strong, nonatomic) NSString *amout;      // 范围
@property (strong, nonatomic) NSString *commission;  // 佣金

@end
