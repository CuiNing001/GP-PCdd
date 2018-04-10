//
//  GPNormalAliPayCell.h
//  GPLottery
//
//  Created by cc on 2018/4/9.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPNormalPayModel.h"

@interface GPNormalAliPayCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *accountNumLab;
@property (weak, nonatomic) IBOutlet UILabel *accountNameLab;

- (void)setDataWithModel:(GPNormalPayModel *)model;

@end
