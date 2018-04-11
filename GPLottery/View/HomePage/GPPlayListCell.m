//
//  GPPlayListCell.m
//  GPLottery
//
//  Created by cc on 2018/3/21.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPPlayListCell.h"

@implementation GPPlayListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDataWithModel:(GPPlayListModel *)model{
    
    int number = arc4random()%6;
    
//    NSString *imageLoc = [NSString stringWithFormat:@"%@%@",kImageLoction,model.playingImageUrl];
    
//    [self.bgImage sd_setImageWithURL:[NSURL URLWithString:imageLoc]];
    self.playTypeLab.text  = [NSString stringWithFormat:@"%@",model.playingTypeName];
    self.remarkLab.text    = [NSString stringWithFormat:@"%@",model.remarkExplain];
    self.onlineNumLab.text = [NSString stringWithFormat:@"%d",model.onlineNum.intValue+number];
    
}

#pragma mark - 赔率说明
- (IBAction)oddsButton:(UIButton *)sender {
    
    if (self.oddInstroctionBlock) {
        
        self.oddInstroctionBlock();
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
