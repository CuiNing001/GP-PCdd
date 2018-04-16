//
//  UITabBar+RedCircle.h
//  GPLottery
//
//  Created by cc on 2018/4/16.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (RedCircle)

- (void)showBadgeOnItemIndex:(NSInteger)index;   ///<显示小红点

- (void)hideBadgeOnItemIndex:(NSInteger)index;  ///<隐藏小红点 
@end
