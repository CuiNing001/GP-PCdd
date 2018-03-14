//
//  GPRespondModel.h
//  GPLottery
//
//  Created by cc on 2018/3/13.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "BaseModel.h"

@interface GPRespondModel : BaseModel

/*
 * 通用model
 */
@property (strong, nonatomic) NSString *code;
@property (strong, nonatomic) NSMutableDictionary *data;
@property (strong, nonatomic) NSString *msg;
@property (strong, nonatomic) NSString *success;

@end
