//
//  GPRechargeListCell.h
//  GPLottery
//
//  Created by cc on 2018/3/20.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPRechargeModel.h"

@interface GPRechargeListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *amountLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *typeLab;

- (void)setDataWithModel:(GPRechargeModel *)model;

@end
