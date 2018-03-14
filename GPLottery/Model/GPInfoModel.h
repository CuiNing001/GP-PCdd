//
//  GPInfoModel.h
//  GPLottery
//
//  Created by cc on 2018/3/14.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "BaseModel.h"

@interface GPInfoModel : BaseModel

@property (strong, nonatomic) NSString *loginName;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *token;
@property (strong, nonatomic) NSString *nickname;
@property (strong, nonatomic) NSString *islogin;
@property (strong, nonatomic) NSString *moneyNum;
@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) NSString *level;

@end
