//
//  GPBannerListModel.h
//  GPLottery
//
//  Created by cc on 2018/3/21.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "BaseModel.h"

@interface GPBannerListModel : BaseModel

@property (strong, nonatomic) NSString *imagePath;  // 图片地址
@property (strong, nonatomic) NSString *bannerTime; // 创建时间
@property (strong, nonatomic) NSString *productId;  // 产品id
@property (strong, nonatomic) NSString *id;         //
@property (strong, nonatomic) NSString *type;       // 

@end
