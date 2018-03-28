//
//  GPNoticeDetailViewController.m
//  GPLottery
//
//  Created by cc on 2018/3/28.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPNoticeDetailViewController.h"

@interface GPNoticeDetailViewController ()<UIWebViewDelegate>

@property (strong, nonatomic) GPInfoModel *infoModel;            // 本地数据
@property (strong, nonatomic) MBProgressHUD *progressHUD;
@property (strong, nonatomic) NSString *token;

@property (strong,nonatomic) NSString *detailStr;  // 详情内容

@end

@implementation GPNoticeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadData];
    [self loadSubView];
}

#pragma mark - 加载数据
- (void)loadData{
    
    // 加载详情数据
    [self loadNetContentData];
}

#pragma mark - 加载子控件
- (void)loadSubView{
    
    self.title = @"动态详情";
    
    self.titleLab.text = self.titleStr;
    self.timeLab.text = self.timeStr;
    
    // 初始化加载框
    self.progressHUD = [[MBProgressHUD alloc]initWithFrame:CGRectMake(0, 0, kSize_width, kSize_height)];
    [self.view addSubview:_progressHUD];
    
    // webview代理
    self.webView.delegate = self;
    
    // web view 样式
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
    self.webView.scrollView.scrollEnabled = NO;
    self.webView.userInteractionEnabled = NO;
}

#pragma mark - 加载详情数据
- (void)loadNetContentData{
    
    [self.progressHUD showAnimated:YES];
    
    [self loadUserDefaultsData];
    
    NSString *contentLoc = [NSString stringWithFormat:@"%@%@",kBaseLocation,self.contentStr];
    
    NSDictionary *paramDic = @{@"id":self.contentId};
    
    // 请求登陆接口
    __weak typeof(self)weakSelf = self;
    [AFNetManager requestPOSTWithURLStr:contentLoc paramDic:paramDic token:self.token finish:^(id responserObject) {
        
        NSLog(@"|NOTICE-CONTENT-VC|success:%@",responserObject);
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        GPRespondModel *respondModel = [GPRespondModel new];
        
        [respondModel setValuesForKeysWithDictionary:responserObject];
        
        if (respondModel.code.integerValue == 9200) {
            
            [ToastView toastViewWithMessage:respondModel.msg timer:1.5];
                
            weakSelf.detailStr = [respondModel.data objectForKey:@"content"];
            
            // 详情内容不为空时加载数据
            if (weakSelf.detailStr.length != 0) {
                
                [weakSelf.webView loadHTMLString:weakSelf.detailStr baseURL:nil];
            }
        }else{
            
            [ToastView toastViewWithMessage:respondModel.msg timer:2.5];
        }
        
    } enError:^(NSError *error) {
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        [ToastView toastViewWithMessage:@"数据连接出错，请稍后再试" timer:3.0];
        
    }];
    
}

#pragma mark - 加载本地数据
- (void)loadUserDefaultsData{
    
    NSMutableDictionary *infoDic = [UserDefaults searchData];
    
    self.infoModel               = [[GPInfoModel alloc]init];
    
    [self.infoModel setValuesForKeysWithDictionary:infoDic];
    
    self.token   = self.infoModel.token;
    
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
