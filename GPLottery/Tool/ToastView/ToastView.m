//
//  ToastView.m
//  GPPcdd
//
//  Created by mading shouyou on 2018/1/4.
//  Copyright © 2018年 mading shouyou. All rights reserved.
//

#import "ToastView.h"

@implementation ToastView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

/*
* message: 提醒文字
* timer  : 动画时长
*/
+ (void)toastViewWithMessage:(NSString *)message timer:(NSTimeInterval)timer{
    
// 找到主屏幕
UIWindow *window             = [UIApplication sharedApplication].keyWindow;

// 自定义弹出View
UIView *showView             = [[UIView alloc]init];

showView.backgroundColor     = [UIColor blackColor];

showView.frame               = CGRectMake(1, 1, 1, 1);

showView.alpha               = 1.0f;

showView.layer.cornerRadius  = 5.0;

showView.layer.masksToBounds = YES;

[window addSubview:showView];

// 自定义提醒文字
UILabel *label = [[UILabel alloc]init];

UIFont *font   = [UIFont systemFontOfSize:15];

CGRect rect    = [message boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 30)
                                       options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:@{NSFontAttributeName:font}
                                       context:nil];

label.frame           = CGRectMake(10, 5, ceil(CGRectGetWidth(rect)), ceil(CGRectGetHeight(rect)));
    
label.text            = message;
    
label.textColor       = [UIColor whiteColor];
    
label.font            = [UIFont systemFontOfSize:15];
    
label.textAlignment   = NSTextAlignmentCenter;
    
label.backgroundColor = [UIColor clearColor];
    
[showView addSubview:label];
    
showView.frame = CGRectMake((kSize_width - CGRectGetWidth(rect) - 20)/2,
                            kSize_height/2-20,
                            CGRectGetWidth(rect)+20,
                            CGRectGetHeight(rect)+10);
    
    // 添加动画
[UIView animateWithDuration:timer animations:^{
        
    showView.alpha = 0;
        
} completion:^(BOOL finished) {
        
    [showView removeFromSuperview];
}];
}



@end
