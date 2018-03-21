//
//  GPProductListModel.h
//  GPLottery
//
//  Created by cc on 2018/3/21.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "BaseModel.h"

@interface GPProductListModel : BaseModel

@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *productUrl;  // 产品主图
@property (strong, nonatomic) NSString *productName; // 产品名称

@end
