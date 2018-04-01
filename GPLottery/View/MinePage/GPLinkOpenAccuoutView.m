//
//  GPLinkOpenAccuoutView.m
//  GPLottery
//
//  Created by cc on 2018/3/16.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPLinkOpenAccuoutView.h"
#import <CoreImage/CoreImage.h>

@interface GPLinkOpenAccuoutView()

@property (strong, nonatomic) GPInfoModel *infoModel;            // 本地数据
@end

@implementation GPLinkOpenAccuoutView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        NSArray *viewArr = [[NSBundle mainBundle]loadNibNamed:@"GPLinkOpenAccuoutView" owner:self options:nil];
        self = viewArr[0];
        self.frame = frame;
        [self loadUserDefaultsData];
        
        // 二维码添加长按手势
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
        [self.qrCardImage addGestureRecognizer:longPress];
    }
    return self;
}

#pragma mark - 生成二维码
- (void)loadQRCardWithLoc{
    
    // 二维码地址赋值
    self.urlLab.text = self.qrImageStr;
    
    // 生成二维码
    CIFilter *filte = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filte setDefaults];
    
    NSString *string = self.qrImageStr;
    
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    [filte setValue:data forKey:@"inputMessage"];
    
    CIImage *image = [filte outputImage];

    self.qrCardImage.image = [self createNonInterpolatedUIImageFormCIImage:image withSize:500];
}

/*
 * @param:image:CIImage
 * @param:size:分辨率
 */
#pragma mark - 增加二维码清晰度
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

#pragma mark -复制链接
- (IBAction)linkOfCopyButton:(UIButton *)sender {
    
    if (self.copyBlock) {
        
        self.copyBlock();
        
        
    }
}

#pragma mark - 图片长按手势
- (void)longPress:(UILongPressGestureRecognizer *)longPress{
    
    // 长按开始
    if (longPress.state == UIGestureRecognizerStateBegan) {
        
        if (self.longPressBlock) {
            
            self.longPressBlock();
        }
    }
}

#pragma mark - 加载本地数据
- (void)loadUserDefaultsData{
    
    NSMutableDictionary *infoDic = [UserDefaults searchData];
    
    self.infoModel               = [[GPInfoModel alloc]init];
    
    [self.infoModel setValuesForKeysWithDictionary:infoDic];
    
    self.contentLab.text = [NSString stringWithFormat:@"通过以上链接或扫描二维码注册的用户即为下线，您的分享ID为：%@，用户注册时填写此介绍人ID，即可成为您的下线。",self.infoModel.userID];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
