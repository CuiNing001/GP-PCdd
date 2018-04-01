//
//  GPAgentUserInfoCell.m
//  GPLottery
//
//  Created by cc on 2018/3/30.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPAgentUserInfoCell.h"

@implementation GPAgentUserInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDataWithModel:(GPAgentUserInfoModel *)model{
    
    self.profitLossQuotaLab.text = model.profitLossQuota;
    self.usernameLab.text = [NSString stringWithFormat:@"用户名：%@",model.userName];
    self.nicknameLab.text = [NSString stringWithFormat:@"昵称：%@",model.nickName];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
