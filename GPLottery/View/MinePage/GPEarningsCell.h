//
//  GPEarningsCell.h
//  GPLottery
//
//  Created by cc on 2018/3/30.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPEarningsModel.h"

@interface GPEarningsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *timeLab;       // 日期
@property (weak, nonatomic) IBOutlet UILabel *betAmountLab;  // 会员下注
@property (weak, nonatomic) IBOutlet UILabel *levelLab;      // 佣金级别
@property (weak, nonatomic) IBOutlet UILabel *commissionLab; // 佣金

- (void)setDataWithModel:(GPEarningsModel *)model;

@end
