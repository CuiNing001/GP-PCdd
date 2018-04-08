//
//  GPMessageModel.h
//  GPLottery
//
//  Created by cc on 2018/3/26.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "BaseModel.h"

@interface GPMessageModel : BaseModel

@property(nonatomic, assign, readonly) JMSGContentType contentType; // 消息类型


@property (strong, nonatomic) NSString *playingId; // 下注号
@property (strong, nonatomic) NSString *date;    // 时间
@property (strong, nonatomic) NSString *level;   // 用户等级
@property (strong, nonatomic) NSString *name;    // 用户昵称
@property (strong, nonatomic) NSString *type;    // 消息类型
@property (strong, nonatomic) NSString *value;   // 开奖内容
@property (strong, nonatomic) NSString *expect;  // 开奖期数
@property (strong, nonatomic) NSString *playingType; // 下注类型
@property (strong, nonatomic) NSString *betAmount;   // 下注金额
@property (strong, nonatomic) NSString *fromName;    // 接收方名称
@property (strong, nonatomic) NSString *timestamp;   // 消息发出的时间戳
@property (strong, nonatomic) NSString *sendType;    // 发送方和接收方

//@property (strong, nonatomic) NSString *openCode;  // 开奖信息内容
//@property (strong, nonatomic) NSString *openText;  // 开奖内容
/** @brief 图片消息的原图 */
@property (strong, nonatomic) UIImage *image;
/** @brief 图片消息缩略图的大小 */
@property (nonatomic) CGSize thumbnailImageSize;

@property (strong, nonatomic) UIImage *thumbnailImage;

@property (strong, nonatomic) NSString *openTime;  // 开奖信息时间
@property (strong, nonatomic) NSString *openCode; // 开内容
@property (strong, nonatomic) NSString *openText; // 开奖类型（大小单双）

@end
