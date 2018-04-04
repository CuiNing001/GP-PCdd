//
//  GPBannerTypeTwoViewController.m
//  GPLottery
//
//  Created by cc on 2018/4/2.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPBannerTypeTwoViewController.h"
#import "GPLinkOpenAccuoutView.h"

@interface GPBannerTypeTwoViewController ()

@property (strong, nonatomic) GPLinkOpenAccuoutView *linkView;   // 链接开户view

@end

@implementation GPBannerTypeTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadSubView];
}

- (void)loadSubView{
    
    self.automaticallyAdjustsScrollViewInsets = false;
    
    self.title = @"分享二维码";
    
    // 初始化linkView
    self.linkView = [[GPLinkOpenAccuoutView alloc]initWithFrame:CGRectMake(0, 0, kSize_width, kSize_height)];
    [self.view addSubview:self.linkView];
    
    
    // 二维码赋值
    self.linkView.qrImageStr = self.QRLocation;
    [self.linkView loadQRCardWithLoc];
    
    // 实现linkView复制按钮点击事件
    __weak typeof(self)weakSelf = self;
    self.linkView.copyBlock = ^{
        
        // 复制二维码地址到剪切板
        [weakSelf copyQRCardBlock];
    };
    
    // linkView图片长按手势点击事件
    self.linkView.longPressBlock = ^{
        
        // 长按图片保存到相册
        [weakSelf saveQRImage];
    };
}

#pragma mark - 图片长按保存二维码
- (void)saveQRImage{
    
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"保存图片" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消保存图片");
    }];
    
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"确认保存图片");
        
        // 保存图片到相册
        UIImageWriteToSavedPhotosAlbum(self.linkView.qrCardImage.image,self,@selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:),nil); }];
    
    [alertControl addAction:cancel];
    [alertControl addAction:confirm];
    [self presentViewController:alertControl animated:YES completion:nil];
}

#pragma mark 保存图片后的回调
- (void)imageSavedToPhotosAlbum:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(id)contextInfo
{
    NSString*message =@"提示";
    if(!error) {
        message =@"成功保存到相册";
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {  }];
        
        [alertControl addAction:action];
        
        [self presentViewController:alertControl animated:YES completion:nil];
        
    }else
        
    {
        message = [error description];
        
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {   }];
        
        [alertControl addAction:action];
        
        [self presentViewController:alertControl animated:YES completion:nil];
        
    }
    
}


#pragma mark - 复制二维码地址
- (void)copyQRCardBlock{
    
    // 复制到剪切板
    UIPasteboard *pastboard = [UIPasteboard generalPasteboard];
    pastboard.string = self.linkView.urlLab.text;
    
    // 提醒框
    [ToastView toastViewWithMessage:@"已复制到剪切板" timer:3.0];
    
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
