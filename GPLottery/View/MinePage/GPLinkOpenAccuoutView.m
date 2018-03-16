//
//  GPLinkOpenAccuoutView.m
//  GPLottery
//
//  Created by cc on 2018/3/16.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPLinkOpenAccuoutView.h"

@implementation GPLinkOpenAccuoutView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        NSArray *viewArr = [[NSBundle mainBundle]loadNibNamed:@"GPLinkOpenAccuoutView" owner:self options:nil];
        self = viewArr[0];
        self.frame = frame;
    }
    return self;
}

#pragma mark -复制链接
- (IBAction)linkOfCopyButton:(UIButton *)sender {
    
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
