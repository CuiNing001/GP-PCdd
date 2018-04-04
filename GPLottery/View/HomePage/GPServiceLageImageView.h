//
//  GPServiceLageImageView.h
//  GPLottery
//
//  Created by cc on 2018/4/3.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GPServiceLageImageView : UIView

- (instancetype)initWithFrame:(CGRect)frame;

@property (weak, nonatomic) IBOutlet UIImageView *largeImageView;
@property (strong, nonatomic) MBProgressHUD *progressHUD;

- (void)setImageDataWithMessage:(JMSGMessage *)message;

@property (copy, nonatomic) void(^dissmissBlock)(void);

@end
