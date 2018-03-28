//
//  GPRoomHistoryCell.m
//  GPLottery
//
//  Created by cc on 2018/3/27.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPRoomHistoryCell.h"

@implementation GPRoomHistoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDataWithModel:(GPRoomHistoryModel *)model{
    
    self.expectLab.text = [NSString stringWithFormat:@"第%@期",model.expect];
    self.codeLab.text = model.code;
    self.typeLab.text = model.codeText;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
