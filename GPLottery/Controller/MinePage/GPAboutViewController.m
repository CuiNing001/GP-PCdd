//
//  GPAboutViewController.m
//  GPLottery
//
//  Created by cc on 2018/3/14.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPAboutViewController.h"

@interface GPAboutViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) MBProgressHUD *progressHUD;
@property (strong, nonatomic) GPInfoModel *infoModel;            // 本地数据
@property (strong, nonatomic) NSString *aboutUrl;
@end

@implementation GPAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadSubView];
}

- (void)loadSubView{
    
    [self loadUserDefaultsData];
 
    self.title = @"关于";
    
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

#pragma mark - 加载本地数据
- (void)loadUserDefaultsData{
    
    NSMutableDictionary *infoDic = [UserDefaults searchData];
    
    self.infoModel               = [[GPInfoModel alloc]init];
    
    [self.infoModel setValuesForKeysWithDictionary:infoDic];
    
    self.aboutUrl = self.infoModel.aboutUrl;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.aboutUrl]];
    
    [self.webView loadRequest:request];
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
