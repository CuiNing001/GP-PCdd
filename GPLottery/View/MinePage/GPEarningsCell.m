//
//  GPEarningsCell.m
//  GPLottery
//
//  Created by cc on 2018/3/30.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPEarningsCell.h"

@implementation GPEarningsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDataWithModel:(GPEarningsModel *)model{
    
    self.timeLab.text = model.createDate;
    self.betAmountLab.text = model.betAmount;
    self.levelLab.text = model.level;
    self.commissionLab.text = model.commission;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
