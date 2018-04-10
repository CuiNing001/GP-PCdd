//
//  GPServiceSenderCell.m
//  GPLottery
//
//  Created by cc on 2018/3/29.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPServiceSenderCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

/** @brief 缩略图宽度(当缩略图宽度为0或者宽度大于高度时) */
#define kEMMessageImageSizeWidth 120
/** @brief 缩略图高度(当缩略图高度为0或者宽度小于高度时) */
#define kEMMessageImageSizeHeight 120
/** @brief 位置消息cell的高度 */
#define kEMMessageLocationHeight 95
/** @brief 语音消息cell的高度 */
#define kEMMessageVoiceHeight 23

@implementation GPServiceSenderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self _setupBackgroundImageViewConstraints];  // 背景图片约束
    [self _setupCellTextLableConstraints];        // 文字约束
}

// 控件样式
- (void)setDataWithMessage:(JMSGMessage *)message{
    
    [self loadUserDefaultsData];
    
    NSTimeInterval second = message.timestamp.longLongValue/1000;             // 格式化时间戳
    
    NSDate *expireTimeDate = [NSDate dateWithTimeIntervalSince1970:second];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"MM-dd HH:mm:ss"];
    
    NSString *msgDate = [formatter stringFromDate:expireTimeDate];
 
    self.timeLab.text = [NSString stringWithFormat:@"%@",msgDate];
    
    self.nicknameLab.text = self.infoModel.nickname;
    
    NSLog(@"========|发送cell|%@|==message==|%@",message.fromUser,message);
    
    if (message.contentType == kJMSGContentTypeText) {
        
        self.textLab.hidden       = NO;
        self.cellImageView.hidden = YES;
        JMSGTextContent *textContent = (JMSGTextContent *)message.content;
        NSString *msgText = textContent.text;
        self.textLab.text = msgText;
        
    }else if(message.contentType == kJMSGContentTypeImage){
        
        self.textLab.hidden       = YES;
        self.cellImageView.hidden = NO;
        [self setupImageBubbleView];
        self.cellImageView.contentMode     = UIViewContentModeScaleToFill;
        self.cellImageView.clipsToBounds   = YES;
        JMSGImageContent *imageContent = (JMSGImageContent *)message.content;
        
        [imageContent largeImageDataWithProgress:^(float percent, NSString *msgId) {
            
            NSLog(@"======================%f==================",percent);
            
        } completionHandler:^(NSData *data, NSString *objectId, NSError *error) {
            
            if (!error) {
                NSString *imageLink = imageContent.imageLink;
                NSLog(@"=========^^^图片地址^^^========%@",imageLink);
                [self.cellImageView setImage:[UIImage imageWithData:data]];
                
            }else{
//                [ToastView toastViewWithMessage:@"图片获取失败" timer:3.0];
            }
            
        }];
        
    }
    
    // 设置图片拉伸样式
    self.cellBackgroundImage.image           = [[UIImage imageNamed:@"input_send_bg"]resizableImageWithCapInsets:UIEdgeInsetsMake(28, 18, 25, 10)] ;
    self.cellBackgroundImage.contentMode     = UIViewContentModeScaleToFill;
    self.cellBackgroundImage.backgroundColor = [UIColor clearColor];
    self.cellBackgroundImage.clipsToBounds   = YES;
    
    // 设置cell高度
    [self cellHeightWithModel:message];
}

// 自定义高度
- (void)cellHeightWithModel:(JMSGMessage *)messageModel{
    
    [self layoutIfNeeded];
    
    if (messageModel.contentType == kJMSGContentTypeText) {
        
        // 获取文字的宽高
        CGSize textSize             = [self.textLab.text boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]} context:nil].size;
        // 文字lable的宽度
        CGFloat bubbleViewW         = textSize.width+30;
        // 文字lable的高度
        CGFloat bubbleViewH         = textSize.height+10;
        // 修改contentview的宽
        self.contentWidth.constant  = bubbleViewW;
        // 修改contentview的高
        self.contentHeight.constant = bubbleViewH;
    }else{
        // 获取图片略缩图size
        JMSGImageContent *imageContent = (JMSGImageContent *)messageModel.content;
        CGSize imageSize = imageContent.imageSize;
        // 获取图片略缩图size
        CGSize retSize = imageSize;
        if (retSize.width == 0 || retSize.height == 0) {
            retSize.width  = kEMMessageImageSizeWidth;
            retSize.height = kEMMessageImageSizeHeight;
        }
        else if (retSize.width > retSize.height) {
            CGFloat height =  kEMMessageImageSizeWidth / retSize.width * retSize.height;
            retSize.height = height;
            retSize.width  = kEMMessageImageSizeWidth;
        }
        else {
            CGFloat width  = kEMMessageImageSizeHeight / retSize.height * retSize.width;
            retSize.width  = width;
            retSize.height = kEMMessageImageSizeHeight;
        }
        self.contentWidth.constant  = retSize.width;
        self.contentHeight.constant = retSize.height;
        
    }
}

#pragma mark - 设置背景图片的约束
- (void)_setupBackgroundImageViewConstraints{
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.cellBackgroundImage attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.cellContentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];         // 距离contentview顶部：0
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.cellBackgroundImage attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.cellContentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];      // 距离contentview底部：0
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.cellBackgroundImage attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.cellContentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];     // 距离contentview中心点对齐
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.cellBackgroundImage attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.cellContentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];       // 距离contentview右侧：0
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.cellBackgroundImage attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.cellContentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];        // 距离contentview左侧：0
}

#pragma mark - 设置文字消息的约束
- (void)_setupCellTextLableConstraints{
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.textLab attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.cellBackgroundImage attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];      // 距离聊天气泡顶部：0
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.textLab attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.cellBackgroundImage attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];   // 距离聊天气泡底部：0
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.textLab attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.cellBackgroundImage attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];  // 与聊天气泡中心点对齐
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.textLab attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.cellBackgroundImage attribute:NSLayoutAttributeRight multiplier:1.0 constant:-10]];  // 距离聊天气泡右侧：10
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.textLab attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.cellBackgroundImage attribute:NSLayoutAttributeLeft multiplier:1.0 constant:10]];    // 距离聊天气泡左侧：10
}

#pragma mark - 设置展示图片消息的控件
- (void)setupImageBubbleView
{
    self.cellImageView = [[UIImageView alloc] init];
    self.cellImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.cellImageView.backgroundColor = [UIColor clearColor];
    self.cellImageView.contentMode     = UIViewContentModeScaleToFill;
    self.cellImageView.clipsToBounds   = YES;
    [self.cellBackgroundImage addSubview:self.cellImageView];
    
    [self _setupImageBubbleMarginConstraints];
}

#pragma mark - 设置图片消息的约束
- (void)_setupImageBubbleMarginConstraints
{
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.cellImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.cellBackgroundImage attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];      // 距离聊天气泡顶部：0
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.cellImageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.cellBackgroundImage attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];   // 距离聊天气泡底部：0
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.cellImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.cellBackgroundImage attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];  // 与聊天气泡中心点对齐
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.cellImageView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.cellBackgroundImage attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];  // 距离聊天气泡右侧：10
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.cellImageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.cellBackgroundImage attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];    // 距离聊天气泡左侧：10
}


#pragma mark - 加载本地数据
- (void)loadUserDefaultsData{
    
    NSMutableDictionary *infoDic = [UserDefaults searchData];
    
    self.infoModel               = [[GPInfoModel alloc]init];
    
    [self.infoModel setValuesForKeysWithDictionary:infoDic];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
