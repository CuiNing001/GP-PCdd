//
//  GPMsgScoreCell.h
//  GPLottery
//
//  Created by cc on 2018/4/8.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPMessageModel.h"

@interface GPMsgScoreCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *scoreLab;

- (void)setDataWithModel:(GPMessageModel *)messageModel;
@end
