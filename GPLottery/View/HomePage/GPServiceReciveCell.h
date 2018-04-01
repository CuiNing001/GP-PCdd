//
//  GPServiceReciveCell.h
//  GPLottery
//
//  Created by cc on 2018/3/29.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPMessageModel.h"

@interface GPServiceReciveCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *textLab;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;


@property (weak, nonatomic) IBOutlet UILabel *timeLab;                   // 消息时间
@property (weak, nonatomic) IBOutlet UILabel *nicknameLab;               // 昵称
@property (weak, nonatomic) IBOutlet UIView *cellContentView;            // 消息背景
@property (weak, nonatomic) IBOutlet UIImageView *cellBackgroundImage;   // 消息气泡
@property (strong, nonatomic) UIImageView *cellImageView;        // 图片消息
@property (nonatomic, readonly) UIEdgeInsets margin;
@property (strong, nonatomic) NSMutableArray *marginConstraints;
@property (strong, nonatomic) UIImage *scaleImage;  // 缩放image

@property (assign, nonatomic) CGSize textSize;

// 控件赋值
- (void)setDataWithMessage:(JMSGMessage *)message;

// 根据文本自适应cell高度
- (void)cellHeightWithModel:(JMSGMessage *)model;

@end
