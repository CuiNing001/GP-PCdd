//
//  GPMsgScoreCell.m
//  GPLottery
//
//  Created by cc on 2018/4/8.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPMsgScoreCell.h"

@implementation GPMsgScoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDataWithModel:(GPMessageModel *)messageModel{
    
    self.scoreLab.text = [NSString stringWithFormat:@"  第%@期 %@ %@ %@  ",messageModel.expect,messageModel.openTime,messageModel.openCode,messageModel.openText];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
