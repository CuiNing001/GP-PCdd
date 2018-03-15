//
//  GPHistoryCell.h
//  GPLottery
//
//  Created by cc on 2018/3/15.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPHistoryModel.h"

@interface GPHistoryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *yearDateLab;  // 日期
@property (weak, nonatomic) IBOutlet UILabel *hourDateLab;  // 时间
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;     // 金额
@property (weak, nonatomic) IBOutlet UILabel *typeLab;      // 方式

- (void)setDateWithModel:(GPHistoryModel *)model;

@end
