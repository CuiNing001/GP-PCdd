//
//  GPHomeLeftItemView.m
//  GPLottery
//
//  Created by cc on 2018/4/7.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPHomeLeftItemView.h"

@implementation GPHomeLeftItemView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        NSArray *viewArr = [[NSBundle mainBundle]loadNibNamed:@"GPHomeLeftItemView" owner:self options:nil];
        self = viewArr[0];
        self.frame = frame;
    }
    return self;
}

#pragma mark - 关闭页面
- (IBAction)dissmissButton:(UIButton *)sender {
    
    if (self.dissmissBlock) {
        
        self.dissmissBlock();
    }
}

#pragma mark - 我的钱包
- (IBAction)walletButton:(UIButton *)sender {
    
    if (self.myWalletBlock) {
        
        self.myWalletBlock();
    }
}

#pragma mark - 我的消息
- (IBAction)mineMessageButton:(UIButton *)sender {
    
    if (self.myMessageBlock) {
        
        self.myMessageBlock();
    }
}

#pragma mark - 充值
- (IBAction)topUpButton:(UIButton *)sender {
    
    if (self.topUpBlock) {
        
        self.topUpBlock();
    }
}

#pragma mark - 提现
- (IBAction)withdrawalButton:(UIButton *)sender {
    
    if (self.withdrawalBlock) {
        
        self.withdrawalBlock();
    }
}

#pragma mark - 底部关闭页面按钮
- (IBAction)bottomDissmissButton:(UIButton *)sender {
    
    if (self.dissmissBlock) {
        
        self.dissmissBlock();
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
