//
//  GPAgentBenefitAnalysisCell.h
//  GPLottery
//
//  Created by cc on 2018/3/30.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPAgentBenefitAnalysisModel.h"

@interface GPAgentBenefitAnalysisCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *creatDateLab;
@property (weak, nonatomic) IBOutlet UILabel *memberLab;
@property (weak, nonatomic) IBOutlet UILabel *profitLab;

- (void)setDataWithModel:(GPAgentBenefitAnalysisModel *)model;

@end
