//
//  GPServiceSenderCell.h
//  GPLottery
//
//  Created by cc on 2018/3/29.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPMessageModel.h"

@interface GPServiceSenderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLab;
@property (weak, nonatomic) IBOutlet UIView *cellContentView;  // 背景view
@property (weak, nonatomic) IBOutlet UIImageView *cellBackgroundImage;  // 聊天气泡
@property (weak, nonatomic) IBOutlet UILabel *textLab;  // 显示聊天文字
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;  // 背景view高
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentWidth;   // 背景view宽
@property (strong, nonatomic) UIImageView *cellImageView;        // 图片消息
@property (nonatomic, readonly) UIEdgeInsets margin;
@property (strong, nonatomic) NSMutableArray *marginConstraints;

@property (strong, nonatomic) UIImage *scaleImage;  // 缩放image

// 控件样式
- (void)setDataWithMessage:(JMSGMessage *)message;

// 自定义高度
- (void)cellHeightWithModel:(JMSGMessage *)messageModel;

@property (strong, nonatomic) GPInfoModel *infoModel;       // 本地数据

@end
