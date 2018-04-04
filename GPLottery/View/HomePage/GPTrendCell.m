//
//  GPTrendCell.m
//  GPLottery
//
//  Created by cc on 2018/4/3.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPTrendCell.h"

@implementation GPTrendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDataWithModel:(GPTrendModel *)trendModel{
    
    UIColor *type1Color = [UIColor colorWithRed:127/255.0 green:177/255.0 blue:255/255.0 alpha:1];  // 大、小颜色
    UIColor *type2Color = [UIColor colorWithRed:125/255.0 green:218/255.0 blue:255/255.0 alpha:1];  // 单、双颜色
    UIColor *type3Color = [UIColor colorWithRed:169/255.0 green:146/255.0 blue:240/255.0 alpha:1];  // 小单、大单、大双、小双颜色
    
    self.expectLab.text = trendModel.expect;
    self.openCodeLab.text = trendModel.openCode;
    
    if (trendModel.type.integerValue == 1) {       // 1:大、双、大双

        self.big.backgroundColor         = type1Color;  // 大
        [self.big setTextColor:[UIColor whiteColor]];
        
        self.small.backgroundColor       = [UIColor clearColor]; // 小
        [self.small setTextColor:[UIColor clearColor]];
        
        self.single.backgroundColor      = [UIColor clearColor]; // 单
        [self.single setTextColor:[UIColor clearColor]];
        
        self.doubleLab.backgroundColor   = type2Color;  // 双
        [self.doubleLab setTextColor:[UIColor whiteColor]];
        
        self.bigSingle.backgroundColor   = [UIColor clearColor]; // 大单
        [self.bigSingle setTextColor:[UIColor clearColor]];
        
        self.smallSingl.backgroundColor  = [UIColor clearColor]; // 小单
        [self.smallSingl setTextColor:[UIColor clearColor]];
        
        self.bigDouble.backgroundColor   = type3Color;  // 大双
        [self.bigDouble setTextColor:[UIColor whiteColor]];
        
        self.smallDouble.backgroundColor = [UIColor clearColor]; // 小双
        [self.smallDouble setTextColor:[UIColor clearColor]];

    }else if (trendModel.type.integerValue == 2){  // 2:小、双、小双
        
        self.big.backgroundColor         = [UIColor clearColor]; // 大
        [self.big setTextColor:[UIColor clearColor]];
        
        self.small.backgroundColor       = type1Color;  // 小
        [self.small setTextColor:[UIColor whiteColor]];
        
        self.single.backgroundColor      = [UIColor clearColor]; // 单
        [self.single setTextColor:[UIColor clearColor]];
        
        self.doubleLab.backgroundColor   = type2Color;  // 双
        [self.doubleLab setTextColor:[UIColor whiteColor]];
        
        self.bigSingle.backgroundColor   = [UIColor clearColor]; // 大单
        [self.bigSingle setTextColor:[UIColor clearColor]];
        
        self.smallSingl.backgroundColor  = [UIColor clearColor]; // 小单
        [self.smallSingl setTextColor:[UIColor clearColor]];
        
        self.bigDouble.backgroundColor   = [UIColor clearColor]; // 大双
        [self.bigDouble setTextColor:[UIColor clearColor]];
        
        self.smallDouble.backgroundColor = type3Color;  // 小双
        [self.smallDouble setTextColor:[UIColor whiteColor]];
        
        
    }else if (trendModel.type.integerValue == 3){  // 3:小、单、小单
        
        self.big.backgroundColor         = [UIColor clearColor]; // 大
        [self.big setTextColor:[UIColor clearColor]];
        
        self.small.backgroundColor       = type1Color;  // 小
        [self.small setTextColor:[UIColor whiteColor]];
        
        self.single.backgroundColor      = type2Color;  // 单
        [self.single setTextColor:[UIColor whiteColor]];
        
        self.doubleLab.backgroundColor   = [UIColor clearColor]; // 双
        [self.doubleLab setTextColor:[UIColor clearColor]];
        
        self.bigSingle.backgroundColor   = [UIColor clearColor];  // 大单
        [self.bigSingle setTextColor:[UIColor clearColor]];
        
        self.smallSingl.backgroundColor  = type3Color; // 小单
        [self.smallSingl setTextColor:[UIColor whiteColor]];
        
        self.bigDouble.backgroundColor   = [UIColor clearColor]; // 大双
        [self.bigDouble setTextColor:[UIColor clearColor]];
        
        self.smallDouble.backgroundColor = [UIColor clearColor]; // 小双
        [self.smallDouble setTextColor:[UIColor clearColor]];
        
    }else{  // 4:大、单、大单
        
        self.big.backgroundColor         = type1Color;  // 大
        [self.big setTextColor:[UIColor whiteColor]];
        
        self.small.backgroundColor       = [UIColor clearColor]; // 小
        [self.small setTextColor:[UIColor clearColor]];
        
        self.single.backgroundColor      = type2Color;  // 单
        [self.single setTextColor:[UIColor whiteColor]];
        
        self.doubleLab.backgroundColor   = [UIColor clearColor]; // 双
        [self.doubleLab setTextColor:[UIColor clearColor]];
        
        self.bigSingle.backgroundColor   = type3Color;  // 大单
        [self.bigSingle setTextColor:[UIColor whiteColor]];
        
        self.smallSingl.backgroundColor  = [UIColor clearColor]; // 小单
        [self.smallSingl setTextColor:[UIColor clearColor]];
        
        self.bigDouble.backgroundColor   = [UIColor clearColor]; // 大双
        [self.bigDouble setTextColor:[UIColor clearColor]];
        
        self.smallDouble.backgroundColor = [UIColor clearColor]; // 小双
        [self.smallDouble setTextColor:[UIColor clearColor]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
