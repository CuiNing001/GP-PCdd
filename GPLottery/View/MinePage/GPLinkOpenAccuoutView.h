//
//  GPLinkOpenAccuoutView.h
//  GPLottery
//
//  Created by cc on 2018/3/16.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GPLinkOpenAccuoutView : UIView

@property (weak, nonatomic) IBOutlet UIView *QRView;
@property (weak, nonatomic) IBOutlet UILabel *urlLab;
@property (weak, nonatomic) IBOutlet UIButton *buttonOfCopy;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UIImageView *qrCardImage;
@property (strong, nonatomic) NSString *qrImageStr;

// 复制按钮点击事件
@property (copy, nonatomic) void(^copyBlock)(void);

// 图片长按手势
@property (copy, nonatomic) void(^longPressBlock)(void);

- (instancetype)initWithFrame:(CGRect)frame;
- (void)loadQRCardWithLoc;



@end
