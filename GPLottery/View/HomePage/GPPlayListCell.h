//
//  GPPlayListCell.h
//  GPLottery
//
//  Created by cc on 2018/3/21.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPPlayListModel.h"

@interface GPPlayListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *bgImage;  // 背景图
@property (weak, nonatomic) IBOutlet UILabel *playTypeLab;  // 玩法类型
@property (weak, nonatomic) IBOutlet UILabel *remarkLab;    // 左下角文字
@property (weak, nonatomic) IBOutlet UILabel *onlineNumLab; // 在线人数
@property (copy, nonatomic) void (^oddInstroctionBlock)(void);  // 赔率说明

- (void)setDataWithModel:(GPPlayListModel *)model;

@end
