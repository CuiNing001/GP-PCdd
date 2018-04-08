//
//  GPCoverView.h
//  GPLottery
//
//  Created by cc on 2018/4/8.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GPCoverView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;

- (instancetype)initWithFrame:(CGRect)frame;
@property (copy, nonatomic) void(^dissMissBlock)(void);

@end
