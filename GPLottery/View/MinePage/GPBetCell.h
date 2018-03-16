//
//  GPBetCell.h
//  GPLottery
//
//  Created by cc on 2018/3/16.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPBetModel.h"

@interface GPBetCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *typeLab;

- (void)setDateWithModel:(GPBetModel *)model;

@end
