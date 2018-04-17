//
//  GPBackWaterCell.m
//  GPLottery
//
//  Created by cc on 2018/3/15.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPBackWaterCell.h"

@implementation GPBackWaterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDataWithModel:(GPBackWaterModel *)model{
    
    self.timeLab.text     = [NSString stringWithFormat:@"%@",model.createDate];
    self.moneyNumLab.text = [NSString stringWithFormat:@"%@",model.backWaterNum];
    self.backWaterLab.text = [NSString stringWithFormat:@"%@",model.backWaterRate];
    if (model.status.integerValue == 1) {
        
        self.stateLab.text = @"满足";
    }else{
        self.stateLab.text = @"未满足";
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
