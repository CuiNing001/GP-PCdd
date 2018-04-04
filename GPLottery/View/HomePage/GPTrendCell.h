//
//  GPTrendCell.h
//  GPLottery
//
//  Created by cc on 2018/4/3.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPTrendModel.h"

@interface GPTrendCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *expectLab;   // 期数
@property (weak, nonatomic) IBOutlet UILabel *openCodeLab; // 开奖
@property (weak, nonatomic) IBOutlet UILabel *big;         // 大
@property (weak, nonatomic) IBOutlet UILabel *small;       // 小
@property (weak, nonatomic) IBOutlet UILabel *single;      // 单
@property (weak, nonatomic) IBOutlet UILabel *doubleLab;   // 双
@property (weak, nonatomic) IBOutlet UILabel *bigSingle;   // 大单
@property (weak, nonatomic) IBOutlet UILabel *smallSingl;  // 小单
@property (weak, nonatomic) IBOutlet UILabel *bigDouble;   // 大双
@property (weak, nonatomic) IBOutlet UILabel *smallDouble; // 小双

- (void)setDataWithModel:(GPTrendModel *)trendModel;

@end
