//
//  GPBetDetailCell.h
//  GPLottery
//
//  Created by cc on 2018/3/16.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPBetDetailModel.h"

@interface GPBetDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLab;          // 标题
@property (weak, nonatomic) IBOutlet UILabel *openCodeLab;       // 开奖结果
@property (weak, nonatomic) IBOutlet UILabel *playingTypeLab;    // 投注类型
@property (weak, nonatomic) IBOutlet UILabel *openTypeLab;       // 中奖玩法
@property (weak, nonatomic) IBOutlet UILabel *betAmoutLab;       // 下注金额
@property (weak, nonatomic) IBOutlet UILabel *rewardNumLAb;      // 中奖元宝
@property (weak, nonatomic) IBOutlet UILabel *openTimeLab;       // 开奖时间
@property (weak, nonatomic) IBOutlet UILabel *topRewardNumLab;   // 顶部中奖金额

- (void)setDataWithModel:(GPBetDetailModel *)model;

@end
