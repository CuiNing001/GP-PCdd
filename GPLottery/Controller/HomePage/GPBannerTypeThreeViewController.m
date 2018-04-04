//
//  GPBannerTypeThreeViewController.m
//  GPLottery
//
//  Created by cc on 2018/4/2.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPBannerTypeThreeViewController.h"

@interface GPBannerTypeThreeViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) MBProgressHUD *progressHUD;

@end

@implementation GPBannerTypeThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadSubView];
}

- (void)loadSubView{
    self.automaticallyAdjustsScrollViewInsets = false;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.webViewLoc]];
    
    [self.webView loadRequest:request];
    
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
//    self.webView.scrollView.scrollEnabled = NO;
    self.webView.delegate = self;
    
    // 初始化加载框
    self.progressHUD = [[MBProgressHUD alloc]initWithFrame:CGRectMake(0, 0, kSize_width, kSize_height)];
    [self.view addSubview:_progressHUD];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    [self.progressHUD showAnimated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [self.progressHUD hideAnimated:YES];
    
    // 设置webview字体大小
    NSString *jsString = [[NSString alloc] initWithFormat:@"document.body.style.fontSize=13"];
    
    [webView stringByEvaluatingJavaScriptFromString:jsString];
    
    //页面背景色
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='#B9D2DC'"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
