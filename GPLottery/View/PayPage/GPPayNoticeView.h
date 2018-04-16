//
//  GPPayNoticeView.h
//  GPLottery
//
//  Created by cc on 2018/4/14.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GPPayNoticeView : UIView

- (instancetype)initWithFrame:(CGRect)frame;
- (void)setDataWithString:(NSString *)htmlStr;

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *noticeViewContentHeight; // view高度


@end
