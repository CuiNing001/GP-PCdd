//
//  GPBetContentCell.h
//  GPLottery
//
//  Created by cc on 2018/3/23.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPOddsInfoModel.h"

@interface GPBetContentCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *oddsLab;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (strong, nonatomic) NSString *selectStatus; // 选中状态

- (void)setDataWithMode:(GPOddsInfoModel *)model;



@end
