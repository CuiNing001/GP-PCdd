//
//  GPNoticeCell.m
//  GPLottery
//
//  Created by cc on 2018/3/28.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPNoticeCell.h"

@implementation GPNoticeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
#pragma mark - 公告
- (void)setDataWithModel:(GPNoticeModel *)noticeModel{
    
    self.noticeLab.text = noticeModel.title;
    self.noticeTimeLab.text = noticeModel.createDate;
    if ([noticeModel.status isEqualToString:@"0"]) {
        self.noticeStatusImageView.hidden = NO;     // 未读
    }else{
        self.noticeStatusImageView.hidden = YES;    // 已读
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
