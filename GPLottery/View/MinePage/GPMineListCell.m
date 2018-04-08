//
//  GPMineListCell.m
//  GPLottery
//
//  Created by cc on 2018/3/13.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPMineListCell.h"

@implementation GPMineListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDataWithImage:(NSString *)image text:(NSString *)text money:(NSString *)money{
    
    // money为空和不为空状态赋值
    if (!money) {
        
        self.mineListImage.image = [UIImage imageNamed:image];
        self.mineListText.text   = text;
        self.mineListMoney.text  = @"";
        
    }else{
        
        self.mineListImage.image = [UIImage imageNamed:image];
        self.mineListText.text   = text;
        self.mineListMoney.text  = [NSString stringWithFormat:@"%@",money];
    }
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
