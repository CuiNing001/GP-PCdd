//
//  GPMsgEnterRoomCell.h
//  GPLottery
//
//  Created by cc on 2018/3/26.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPMessageModel.h"

@interface GPMsgEnterRoomCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *levelImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLab;

- (void)setDataWithModel:(GPMessageModel *)messageModel;

@end
