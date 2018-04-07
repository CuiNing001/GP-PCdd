//
//  GPMsgSenderCell.m
//  GPLottery
//
//  Created by cc on 2018/3/26.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPMsgSenderCell.h"

@implementation GPMsgSenderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setDataWithModel:(GPMessageModel *)messageModel{
    
    self.msgTimeLab.text = [NSString stringWithFormat:@"%@",messageModel.date];
    self.nicknameLab.text = [NSString stringWithFormat:@"%@",messageModel.name];
    [self.levelImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",messageModel.level]]];
    self.playingTypeLab.text = [NSString stringWithFormat:@"%@",messageModel.playingType];
    self.expectLab.text = [NSString stringWithFormat:@"%@",messageModel.expect];
    self.betAmountLab.text = [NSString stringWithFormat:@"%@",messageModel.betAmount];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
