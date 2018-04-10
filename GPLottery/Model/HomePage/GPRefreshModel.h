//
//  GPRefreshModel.h
//  GPLottery
//
//  Created by cc on 2018/4/9.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "BaseModel.h"

@interface GPRefreshModel : BaseModel

// 刷新开奖内容及期数
@property (strong, nonatomic) NSString *expect;
@property (strong, nonatomic) NSString *isCloseAccount;
@property (strong, nonatomic) NSString *openTime;
@property (strong, nonatomic) NSString *forbidBetAheadTime;

@end
