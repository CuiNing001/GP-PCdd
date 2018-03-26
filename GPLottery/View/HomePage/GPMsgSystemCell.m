//
//  GPMsgSystemCell.m
//  GPLottery
//
//  Created by cc on 2018/3/26.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPMsgSystemCell.h"

@interface GPMsgSystemCell()<UIWebViewDelegate>

@end

@implementation GPMsgSystemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
//    self.webView.scrollView.backgroundColor = [UIColor colorWithRed:185/255.0 green:210/255.0 blue:220/255.0 alpha:1];
    self.webView.scrollView.scrollEnabled = NO;
//    self.webView.opaque = NO; //不设置这个值 页面背景始终是白色
    self.webView.delegate = self;
}

- (void)setDataWithModel:(GPMessageModel *)messageModel{
    
    [self.webView loadHTMLString:messageModel.value baseURL:nil];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    // 设置webview字体大小
    NSString *jsString = [[NSString alloc] initWithFormat:@"document.body.style.fontSize=13"];
    
    [webView stringByEvaluatingJavaScriptFromString:jsString];
    
    //页面背景色
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='#B9D2DC'"];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
