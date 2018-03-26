//
//  GPMsgEnterRoomCell.m
//  GPLottery
//
//  Created by cc on 2018/3/26.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPMsgEnterRoomCell.h"

@implementation GPMsgEnterRoomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDataWithModel:(GPMessageModel *)messageModel{
    
    [self.levelImageView setImage:[UIImage imageNamed:messageModel.level]];
    self.userNameLab.text = messageModel.name;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
