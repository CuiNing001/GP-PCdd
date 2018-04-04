//
//  GPRoomItemAlertView.m
//  GPLottery
//
//  Created by cc on 2018/4/3.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPRoomItemAlertView.h"

@implementation GPRoomItemAlertView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        NSArray *viewArray = [[NSBundle mainBundle]loadNibNamed:@"GPRoomItemAlertView" owner:self options:nil];
        self = viewArray[0];
        self.frame = frame;
    }
    return self;
}

// 投注记录
- (IBAction)recordBtn:(UIButton *)sender {
    
    if (self.recordBtnBlock) {
        
        self.recordBtnBlock();
    }
}


// 玩法说明
- (IBAction)insBtn:(UIButton *)sender {
    
    if (self.insBtnBlock) {
        
        self.insBtnBlock();
    }
    
}


// 走势图
- (IBAction)trendBtn:(UIButton *)sender {
    
    if (self.trendBtnBlock) {
        
        self.trendBtnBlock();
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
