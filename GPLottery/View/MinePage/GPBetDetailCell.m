//
//  GPBetDetailCell.m
//  GPLottery
//
//  Created by cc on 2018/3/16.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPBetDetailCell.h"

@implementation GPBetDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

#pragma mark - 截取投注类型字符串
- (NSString *)rangeStringWithString:(NSString *)string{
    
    NSRange startRange = [string rangeOfString:@"("];
    NSRange endRange = [string rangeOfString:@")"];
    NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
    NSString *result = [string substringWithRange:range];
    NSLog(@"^^^^^^^%@",result);
    return result;
}

#pragma mark - 修改投注类型颜色
- (void)changeBetTypeColorWithString:(NSString *)string{
    
    NSRange startRange = [string rangeOfString:@"("];
    NSRange endRange = [string rangeOfString:@")"];
    NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
    
    NSMutableAttributedString *attrDescribeStr = [[NSMutableAttributedString alloc] initWithString:string];
    
    [attrDescribeStr addAttribute:NSForegroundColorAttributeName
     
                            value:[UIColor redColor]
     
                            range:range];
    
    self.playingTypeLab.attributedText = attrDescribeStr;

}

- (void)setDataWithModel:(GPBetDetailModel *)model{

    self.titleLab.text        = model.title;        // 开奖标题
    self.openCodeLab.text     = model.openCode;     // 开奖号码
    
    self.playingTypeLab.text  = model.playingType;  // 投注类型
    self.openTypeLab.text     = model.openType;     // 开奖类型
    
    if (model.playingType.length>0) {
        
        // 截取用户投注类型
        NSString *playingType = [self rangeStringWithString:model.playingType];
        
        // 判断开奖类型内是否包含投注类型
        if ([model.openType containsString:playingType]) {
            
            // 包含时修改投注文字颜色
            [self changeBetTypeColorWithString:self.playingTypeLab.text];
            
            // 修改开奖类型文字颜色
            NSMutableAttributedString *attrDescribeStr = [[NSMutableAttributedString alloc] initWithString:self.openTypeLab.text];
            [attrDescribeStr addAttribute:NSForegroundColorAttributeName
                                    value:[UIColor redColor]
                                    range:[self.openTypeLab.text rangeOfString:playingType]];
            self.openTypeLab.attributedText = attrDescribeStr;
            
        }else{
            
            
        }
    }
    
    
    self.betAmoutLab.text     = model.betAmout;     // 投注金额
    self.rewardNumLAb.text    = model.rewardNum;    // 中奖金额
    self.openTimeLab.text     = model.openTime;
    self.topRewardNumLab.text = [NSString stringWithFormat:@"%ld",model.rewardNum.integerValue-model.betAmout.integerValue];  // 中奖金额-下注金额
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
