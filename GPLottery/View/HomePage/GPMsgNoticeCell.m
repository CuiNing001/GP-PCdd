//
//  GPMsgNoticeCell.m
//  GPLottery
//
//  Created by cc on 2018/4/11.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPMsgNoticeCell.h"

@implementation GPMsgNoticeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setdataWithModel:(GPMessageModel *)model{
    
    self.noticeMsgLab.text = [NSString stringWithFormat:@" 【%@】距封盘还有60秒，请抓紧时间下注  ",model.expect];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
