//
//  GPAlertNoticeView.m
//  GPLottery
//
//  Created by cc on 2018/4/9.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPAlertNoticeView.h"

@interface GPAlertNoticeView()<UIWebViewDelegate>

@property (strong, nonatomic) MBProgressHUD *progressHUD;

@end

@implementation GPAlertNoticeView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        NSArray *viewArr = [[NSBundle mainBundle]loadNibNamed:@"GPAlertNoticeView" owner:self options:nil];
        self = viewArr[0];
        self.frame = frame;
 
    }
    return self;
}

#pragma mark - 加载数据
- (void)loadDataWithString:(NSString *)urlStr{
    
    // 初始化加载框
    self.progressHUD = [[MBProgressHUD alloc]initWithFrame:CGRectMake(0, 0, kSize_width, kSize_height)];
    [self addSubview:_progressHUD];
    
    self.webView.delegate = self;
    // web view 样式
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
//    self.webView.scrollView.scrollEnabled = NO;
//    self.webView.userInteractionEnabled = NO;
    
    [self.webView loadHTMLString:urlStr baseURL:nil];
}

- (IBAction)makeSureButton:(UIButton *)sender {
    
    if (self.dissMissBlock) {
        
        self.dissMissBlock();
    }
    
}
#pragma mark - web view 代理方法
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    [self.progressHUD showAnimated:YES];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [self.progressHUD hideAnimated:YES];
    
    // 设置web view 字体大小
    NSString *jsString = [NSString stringWithFormat:@"document.body.style.fontSize=13"];
    [webView stringByEvaluatingJavaScriptFromString:jsString];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
