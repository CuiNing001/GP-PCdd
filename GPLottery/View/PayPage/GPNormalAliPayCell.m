//
//  GPNormalAliPayCell.m
//  GPLottery
//
//  Created by cc on 2018/4/9.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPNormalAliPayCell.h"

@implementation GPNormalAliPayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDataWithModel:(GPNormalPayModel *)model{
    
    self.accountNumLab.text = model.bankCard;
    self.accountNameLab.text = model.accountName;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
