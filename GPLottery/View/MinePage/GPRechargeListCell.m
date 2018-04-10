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
    
    self.amountLab.text = [NSString stringWithFormat:@"%@",model.amount];
    self.timeLab.text   = [NSString stringWithFormat:@"%@",model.time];
    
    if (model.status.integerValue == 1) {
        
        self.typeLab.text = @"未审核";
    }else if (model.status.integerValue == 2){
        
        self.typeLab.text = @"审核通过";
    }else if (model.status.integerValue == 3){
        
        self.typeLab.text = @"审核不通过";
    }else{
        
        self.typeLab.text = @"未审核";
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
