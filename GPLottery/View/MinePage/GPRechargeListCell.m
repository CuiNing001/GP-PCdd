//
//  GPRechargeListCell.m
//  GPLottery
//
//  Created by cc on 2018/3/20.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPRechargeListCell.h"

@implementation GPRechargeListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDataWithModel:(GPRechargeModel *)model{
    
    self.amountLab.text = model.amount;
    self.timeLab.text   = model.time;
    self.typeLab.text   = model.type;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
