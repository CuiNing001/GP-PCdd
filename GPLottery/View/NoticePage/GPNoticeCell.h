//
//  GPNoticeCell.h
//  GPLottery
//
//  Created by cc on 2018/3/28.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPNoticeModel.h"

@interface GPNoticeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *noticeLab;
@property (weak, nonatomic) IBOutlet UILabel *noticeTimeLab;
@property (weak, nonatomic) IBOutlet UIImageView *noticeStatusImageView;

- (void)setDataWithModel:(GPNoticeModel *)noticeModel;   // 公告


@end
