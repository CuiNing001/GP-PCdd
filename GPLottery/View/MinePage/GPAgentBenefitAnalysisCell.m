//
//  GPAgentBenefitAnalysisCell.m
//  GPLottery
//
//  Created by cc on 2018/3/30.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPAgentBenefitAnalysisCell.h"

@implementation GPAgentBenefitAnalysisCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDataWithModel:(GPAgentBenefitAnalysisModel *)model{
    
    self.creatDateLab.text = model.createDate;
    self.memberLab.text = model.memberUserSum;
    self.profitLab.text = model.profitLossQuota;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
