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

// 重写cell选中方法
- (void)setSelected:(BOOL)selected{
    
    [super setSelected:selected];
    
    if (selected) {
        
        // 修改选中item的UI
        self.bgView.layer.borderWidth = 0.5;
        self.bgView.layer.borderColor = [UIColor whiteColor].CGColor;
        
    }else{
        
        // 修改选中item的UI
        self.bgView.layer.borderWidth = 0;
        self.bgView.layer.borderColor = [UIColor clearColor].CGColor;
    }
}

@end
