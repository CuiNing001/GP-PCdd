//
//  GPHomeMoreView.m
//  GPLottery
//
//  Created by cc on 2018/4/6.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPHomeMoreView.h"

@implementation GPHomeMoreView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        NSArray *viewArray = [[NSBundle mainBundle]loadNibNamed:@"GPHomeMoreView" owner:self options:nil];
        
        self = viewArray[0];
        
        self.frame = frame;
    }
    return self;
}



- (IBAction)rechargeButton:(UIButton *)sender {
    
    if (self.rechargeBlock) {
        
        self.rechargeBlock();
    }
}


- (IBAction)withdrawButton:(UIButton *)sender {
    
    if (self.withdrawBlock) {
        
        self.withdrawBlock();
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
