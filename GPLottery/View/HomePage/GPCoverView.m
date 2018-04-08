//
//  GPCoverView.m
//  GPLottery
//
//  Created by cc on 2018/4/8.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPCoverView.h"

@implementation GPCoverView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        NSArray *viewArr = [[NSBundle mainBundle]loadNibNamed:@"GPCoverView" owner:self options:nil];
        
        self = viewArr[0];
        
        self.frame = frame;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenCover)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)hiddenCover{
    
    if (self.dissMissBlock) {
        
        self.dissMissBlock();
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
