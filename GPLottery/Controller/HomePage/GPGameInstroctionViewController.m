//
//  GPGameInstroctionViewController.m
//  GPLottery
//
//  Created by cc on 2018/3/21.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPGameInstroctionViewController.h"

@interface GPGameInstroctionViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;


@end

@implementation GPGameInstroctionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = self.myTitle;
    
    [self.webView loadHTMLString:self.htmlString baseURL:nil];
    
    self.webView.scrollView.scrollEnabled = NO;
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
