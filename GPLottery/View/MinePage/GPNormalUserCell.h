//
//  GPNormalUserCell.h
//  GPLottery
//
//  Created by cc on 2018/3/30.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPNormalUserModel.h"

@interface GPNormalUserCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *levelLab;
@property (weak, nonatomic) IBOutlet UILabel *amountLab;
@property (weak, nonatomic) IBOutlet UILabel *commissionLab;

- (void)setDataWithModel:(GPNormalUserModel *)model;




@end
