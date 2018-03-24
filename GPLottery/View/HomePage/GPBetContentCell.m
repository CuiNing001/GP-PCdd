//
//  GPBetContentCell.m
//  GPLottery
//
//  Created by cc on 2018/3/23.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPBetContentCell.h"

@implementation GPBetContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
}

- (void)setDataWithMode:(GPOddsInfoModel *)model{
    
    self.nameLab.text = model.name;
    self.oddsLab.text = model.odds;

}

@end
