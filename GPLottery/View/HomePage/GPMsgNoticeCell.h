//
//  GPMsgNoticeCell.h
//  GPLottery
//
//  Created by cc on 2018/4/11.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPMessageModel.h"

@interface GPMsgNoticeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *noticeMsgLab;

- (void)setdataWithModel:(GPMessageModel *)model;

@end
