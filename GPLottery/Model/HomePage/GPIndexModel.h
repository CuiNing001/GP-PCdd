//
//  GPIndexModel.h
//  GPLottery
//
//  Created by cc on 2018/3/21.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "BaseModel.h"

@interface GPIndexModel : BaseModel

@property (strong, nonatomic) NSArray *bannerList;    // banner list
@property (strong, nonatomic) NSString *registerNum;  // 注册人数
@property (strong, nonatomic) NSString *winRate;      // 赚钱率
@property (strong, nonatomic) NSString *earnedIncome; // 已赚积分
@property (strong, nonatomic) NSArray *productList;   // 产品列表

@end
