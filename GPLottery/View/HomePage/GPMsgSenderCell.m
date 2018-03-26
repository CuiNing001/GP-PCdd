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
    
    self.nicknameLab.text = messageModel.name;
    [self.levelImageView setImage:[UIImage imageNamed:messageModel.level]];
    self.playingTypeLab.text = messageModel.playingType;
    self.expectLab.text = messageModel.expect;
    self.betAmountLab.text = messageModel.betAmount;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
