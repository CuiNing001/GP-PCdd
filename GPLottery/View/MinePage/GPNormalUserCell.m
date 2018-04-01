//
//  GPNormalUserCell.m
//  GPLottery
//
//  Created by cc on 2018/3/30.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPNormalUserCell.h"

@implementation GPNormalUserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDataWithModel:(GPNormalUserModel *)model{
    
    self.levelLab.text = model.level;
    self.amountLab.text = model.amout;
    self.commissionLab.text = model.commission;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
