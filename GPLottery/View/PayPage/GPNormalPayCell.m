//
//  GPNormalPayCell.m
//  GPLottery
//
//  Created by cc on 2018/3/31.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPNormalPayCell.h"

@implementation GPNormalPayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDataWithModel:(GPNormalPayModel *)model{
    
    self.bankNameLab.text = model.bankName;
    self.accountNameLab.text = model.accountName;
    self.mesgLab.text = model.mesg;
    self.bankCardLab.text = model.bankCard;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
