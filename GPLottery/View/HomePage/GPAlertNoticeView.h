//
//  GPAlertNoticeView.h
//  GPLottery
//
//  Created by cc on 2018/4/9.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GPAlertNoticeView : UIView

@property (weak, nonatomic) IBOutlet UILabel *noticeTitle;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSString *noticeStr;
@property (copy, nonatomic) void(^dissMissBlock)(void);

- (instancetype)initWithFrame:(CGRect)frame;

- (void)loadDataWithString:(NSString *)urlStr;

@end
