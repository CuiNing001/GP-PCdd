//
//  GPBackWaterCell.h
//  GPLottery
//
//  Created by cc on 2018/3/15.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPBackWaterModel.h"

@interface GPBackWaterCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *timeLab;       // 时间
@property (weak, nonatomic) IBOutlet UILabel *moneyNumLab;   // 金额
@property (weak, nonatomic) IBOutlet UILabel *backWaterLab;  // 回水
@property (weak, nonatomic) IBOutlet UILabel *stateLab;      // 状态

// cell数据赋值
- (void)setDataWithModel:(GPBackWaterModel *)model;

@end
