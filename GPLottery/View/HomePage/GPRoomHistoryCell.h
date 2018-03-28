//
//  GPRoomHistoryCell.h
//  GPLottery
//
//  Created by cc on 2018/3/27.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPRoomHistoryModel.h"

@interface GPRoomHistoryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *expectLab;
@property (weak, nonatomic) IBOutlet UILabel *codeLab;
@property (weak, nonatomic) IBOutlet UILabel *typeLab;

- (void)setDataWithModel:(GPRoomHistoryModel *)model;

@end
