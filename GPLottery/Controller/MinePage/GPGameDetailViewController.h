//
//  GPGameDetailViewController.h
//  GPLottery
//
//  Created by cc on 2018/3/16.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GPGameDetailViewController : UIViewController

@property (strong, nonatomic) NSString *productId;  // 产品ID
@property (strong, nonatomic) NSString *beginDate;  // 开始时间
@property (strong, nonatomic) NSString *endDate;    // 结束时间

@end
