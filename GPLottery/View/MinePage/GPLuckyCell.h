//
//  GPLuckyCell.h
//  GPLottery
//
//  Created by cc on 2018/3/21.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPLuckyModel.h"

@interface GPLuckyCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *creatTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *luckMoneyLevelLab;
@property (weak, nonatomic) IBOutlet UILabel *extractAmountLab;

- (void)setDataWithModel:(GPLuckyModel *)model;

@end
