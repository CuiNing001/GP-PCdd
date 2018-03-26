//
//  GPMsgReceiveCell.m
//  GPLottery
//
//  Created by cc on 2018/3/26.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPMsgReceiveCell.h"

@implementation GPMsgReceiveCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
 
}

- (void)setDataWithModel:(GPMessageModel *)messageModel{
    
    self.nicknameLab.text = messageModel.fromName;
    [self.userIconImageView setImage:[UIImage imageNamed:messageModel.level]];
    self.expectLab.text = messageModel.expect;
    self.playingTypeLab.text = messageModel.playingType;
    self.betAmountLab.text = messageModel.betAmount;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
