//
//  GPBankCardView.m
//  GPLottery
//
//  Created by cc on 2018/3/20.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPBankCardView.h"

@implementation GPBankCardView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        NSArray *viewArray = [[NSBundle mainBundle]loadNibNamed:@"GPBankCardView" owner:self options:nil];
        self = viewArray[0];
        self.frame = frame;
    }
    return self;
}

- (IBAction)changeBankInfoButton:(UIButton *)sender {
    
    if (self.changeBankBlock) {
        
        self.changeBankBlock();
    }
}

- (void)setDataWithModel:(GPBankInfoModel *)model{
    
    self.accountNameLab.text = model.accountName;
    self.bankTypeLab.text    = model.bankName;
    self.bankCardLab.text    = model.bankCard;
    self.bankAddressLab.text = model.bankAddress;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
