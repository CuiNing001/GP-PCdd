//
//  GPMsgReceiveCell.h
//  GPLottery
//
//  Created by cc on 2018/3/26.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPMessageModel.h"

@interface GPMsgReceiveCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel     *nicknameLab;         // 昵称
@property (weak, nonatomic) IBOutlet UIImageView *userIconImageView;   // 会员级别
@property (weak, nonatomic) IBOutlet UIImageView *receiveBgImageView;  // 聊天背景
@property (weak, nonatomic) IBOutlet UILabel     *expectLab;           // 期数
@property (weak, nonatomic) IBOutlet UILabel     *playingTypeLab;      // 投注类型
@property (weak, nonatomic) IBOutlet UILabel     *betAmountLab;        // 下注金额

- (void)setDataWithModel:(GPMessageModel *)messageModel;


@end
