//
//  GPLuckyCell.m
//  GPLottery
//
//  Created by cc on 2018/3/21.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPLuckyCell.h"

@implementation GPLuckyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDataWithModel:(GPLuckyModel *)model{
    
    self.creatTimeLab.text      = model.createTime;
    self.luckMoneyLevelLab.text = model.luckyMoneyLevel;
    self.extractAmountLab.text  = model.extractAmount;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
