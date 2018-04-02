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
    
    self.msgTimeLab.text = [NSString stringWithFormat:@"%@",messageModel.date];
    self.nicknameLab.text = [NSString stringWithFormat:@"%@",messageModel.name];
    [self.userIconImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",messageModel.level]]];
    self.expectLab.text = [NSString stringWithFormat:@"%@",messageModel.expect];
    self.playingTypeLab.text = [NSString stringWithFormat:@"%@",messageModel.playingType];
    self.betAmountLab.text = [NSString stringWithFormat:@"%@",messageModel.betAmount];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
