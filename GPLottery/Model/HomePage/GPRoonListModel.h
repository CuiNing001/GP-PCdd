//
//  GPRoonListModel.h
//  GPLottery
//
//  Created by cc on 2018/3/22.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "BaseModel.h"

@interface GPRoonListModel : BaseModel

@property (strong, nonatomic) NSString *name;  // 房间名
@property (strong, nonatomic) NSString *onlineNumRoom;  // 房间在线人数
@property (strong, nonatomic) NSString *roomId;  // 房间id
@property (strong, nonatomic) NSString *url;  // 房间图地址

@end
