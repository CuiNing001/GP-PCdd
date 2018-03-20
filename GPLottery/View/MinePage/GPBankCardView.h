//
//  GPBankCardView.h
//  GPLottery
//
//  Created by cc on 2018/3/20.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPBankInfoModel.h"

@interface GPBankCardView : UIView

@property (weak, nonatomic) IBOutlet UILabel *accountNameLab;
@property (weak, nonatomic) IBOutlet UILabel *bankTypeLab;
@property (weak, nonatomic) IBOutlet UILabel *bankCardLab;
@property (weak, nonatomic) IBOutlet UILabel *bankAddressLab;
@property (copy, nonatomic) void(^changeBankBlock)(void);

- (void)setDataWithModel:(GPBankInfoModel *)model;
- (instancetype)initWithFrame:(CGRect)frame;

@end
