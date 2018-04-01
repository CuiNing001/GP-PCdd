//
//  GPAgentUserInfoCell.h
//  GPLottery
//
//  Created by cc on 2018/3/30.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPAgentUserInfoModel.h"

@interface GPAgentUserInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *profitLossQuotaLab; // 盈亏额
@property (weak, nonatomic) IBOutlet UILabel *usernameLab;        // 用户名
@property (weak, nonatomic) IBOutlet UILabel *nicknameLab;        // 昵称

- (void)setDataWithModel:(GPAgentUserInfoModel *)model;

@end
