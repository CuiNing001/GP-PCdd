//
//  GPHistoryCell.m
//  GPLottery
//
//  Created by cc on 2018/3/15.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPHistoryCell.h"

@implementation GPHistoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDateWithModel:(GPHistoryModel *)model{
    
    NSString *year = [model.createTime substringToIndex:10];   // 截取年月日
    NSString *hour = [model.createTime substringFromIndex:10]; // 截取时分秒
    
    self.yearDateLab.text = year;
    self.hourDateLab.text = hour;
    self.moneyLab.text    = model.moneyChangeAmount;
    self.typeLab.text     = model.changeType;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
