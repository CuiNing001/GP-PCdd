//
//  GPBetCell.m
//  GPLottery
//
//  Created by cc on 2018/3/16.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPBetCell.h"

@implementation GPBetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDateWithModel:(GPBetModel *)model{
        
        self.typeLab.text = model.name;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
