//
//  GPTrendModel.h
//  GPLottery
//
//  Created by cc on 2018/4/3.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "BaseModel.h"

@interface GPTrendModel : BaseModel

@property (strong, nonatomic) NSString *expect;  // 期数
@property (strong, nonatomic) NSString *openCode; // 开奖
@property (strong, nonatomic) NSString *type;     // 开奖类型

@end
