//
//  GPChooseBankCell.m
//  GPLottery
//
//  Created by cc on 2018/3/19.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPChooseBankCell.h"

@implementation GPChooseBankCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
}

- (void)setDataWithBankName:(NSString *)bankName{
    
    self.bankNameLab.text = bankName;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
