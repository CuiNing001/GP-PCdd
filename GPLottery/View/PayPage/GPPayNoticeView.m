//
//  GPPayNoticeView.m
//  GPLottery
//
//  Created by cc on 2018/4/14.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPPayNoticeView.h"

@interface GPPayNoticeView()<UIWebViewDelegate>

@property (strong, nonatomic) MBProgressHUD *progressHUD;

@end

@implementation GPPayNoticeView


- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        NSArray *viewArr = [[NSBundle mainBundle]loadNibNamed:@"GPPayNoticeView" owner:self options:nil];
        
        self = viewArr[0];
        
        self.frame = frame;
        
        [self setWebViewStyle];
    }
    
    return self;
}

#pragma mark - webview样式
- (void)setWebViewStyle{
    
    self.webView.delegate = self;
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
    self.webView.scrollView.scrollEnabled = NO;
    self.webView.opaque = NO;
    self.webView.backgroundColor = [UIColor colorWithRed:35/255.0 green:198/255.0 blue:164/255.0 alpha:1];
}

- (void)setDataWithString:(NSString *)htmlStr{
    
    [self.webView loadHTMLString:htmlStr baseURL:nil];
}

#pragma mark - 关闭页面
- (IBAction)dissmissButton:(UIButton *)sender {
    
    
}

#pragma mark - webview代理方法
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    [self.progressHUD showAnimated:YES];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    // 设置webview字体大小
    NSString *jsString = [[NSString alloc] initWithFormat:@"document.body.style.fontSize=16"];
 
    [webView stringByEvaluatingJavaScriptFromString:jsString];
    
    //页面背景色
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='#23C6A4'"];
    
    // 字体颜色
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= 'white'"];

    
    // 自适应webview高度
    CGRect frame = webView.frame;
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    webView.frame = frame;
    
    NSLog(@"|payNoticeHeight|%f",frame.size.height);
    
    self.noticeViewContentHeight.constant = webView.frame.size.height+60;
    [self layoutIfNeeded];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
