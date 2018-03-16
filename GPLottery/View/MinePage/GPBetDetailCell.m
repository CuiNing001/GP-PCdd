//
//  GPBetDetailCell.m
//  GPLottery
//
//  Created by cc on 2018/3/16.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPBetDetailCell.h"

@implementation GPBetDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDataWithModel:(GPBetDetailModel *)model{

    self.titleLab.text        = model.title;
    self.openCodeLab.text     = model.openCode;
    self.playingTypeLab.text  = model.playingType;
    self.openTypeLab.text     = model.openType;
    self.betAmoutLab.text     = model.betAmout;
    self.rewardNumLAb.text    = model.rewardNum;
    self.openTimeLab.text     = model.openTime;
    self.topRewardNumLab.text = model.rewardNum;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
