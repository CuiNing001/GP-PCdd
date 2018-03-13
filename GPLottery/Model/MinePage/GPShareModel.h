//
//  GPShareModel.h
//  GPLottery
//
//  Created by cc on 2018/3/13.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "BaseModel.h"

@interface GPShareModel : BaseModel

@property (strong, nonatomic) NSString *date;  // 时间
@property (strong, nonatomic) NSString *url;   // 分享网址（生成二维码）

@end
