//
//  GPServiceLageImageView.m
//  GPLottery
//
//  Created by cc on 2018/4/3.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPServiceLageImageView.h"

@implementation GPServiceLageImageView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        NSArray *viewArray = [[NSBundle mainBundle]loadNibNamed:@"GPServiceLageImageView" owner:self options:nil];
        
        self = viewArray[0];
        
        self.frame = frame;
    
    }
    return self;
}


- (IBAction)dissmissView:(UIButton *)sender {
    
    if (self.dissmissBlock) {
        
        self.dissmissBlock();
    }
}


- (void)setImageDataWithMessage:(JMSGMessage *)message{
    
    
    JMSGImageContent *imageContent = (JMSGImageContent *)message.content;
    
    [imageContent largeImageDataWithProgress:^(float percent, NSString *msgId) {
        
        NSLog(@"======================%f==================",percent);
        
        if(percent == 1){
            
        }
        
    } completionHandler:^(NSData *data, NSString *objectId, NSError *error) {
        
        if (!error) {
            [self.largeImageView setImage:[UIImage imageWithData:data]];
            
            self.largeImageView.contentMode     = UIViewContentModeScaleAspectFit;
            self.largeImageView.backgroundColor = [UIColor clearColor];
            self.largeImageView.clipsToBounds   = YES;
            
        }else{
            [ToastView toastViewWithMessage:@"图片获取失败" timer:3.0];
        }
        
        
    }];
}
     
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
