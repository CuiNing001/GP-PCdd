//
//  ToastView.h
//  GPPcdd
//
//  Created by mading shouyou on 2018/1/4.
//  Copyright © 2018年 mading shouyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToastView : UIView

// toast
+ (void)toastViewWithMessage:(NSString *)message timer:(NSTimeInterval)timer;

// Jason字符串转字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

+ (NSString*)dictionaryToJson:(NSDictionary *)dic;

@end
