//
//  GPNormalPayCell.h
//  GPLottery
//
//  Created by cc on 2018/3/31.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPNormalPayModel.h"

@interface GPNormalPayCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *bankNameLab;    // 银行名
@property (weak, nonatomic) IBOutlet UILabel *accountNameLab; // 用户名
@property (weak, nonatomic) IBOutlet UILabel *mesgLab;      // 提醒信息
@property (weak, nonatomic) IBOutlet UILabel *bankCardLab; // 银行卡号

- (void)setDataWithModel:(GPNormalPayModel *)model;

@end
