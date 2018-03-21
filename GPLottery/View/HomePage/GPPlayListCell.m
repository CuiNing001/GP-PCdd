//
//  GPPlayListCell.m
//  GPLottery
//
//  Created by cc on 2018/3/21.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPPlayListCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation GPPlayListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDataWithModel:(GPPlayListModel *)model{
    
    NSString *imageLoc = [NSString stringWithFormat:@"%@%@",kImageLoction,model.playingImageUrl];
    
    [self.bgImage sd_setImageWithURL:[NSURL URLWithString:imageLoc]];
    self.playTypeLab.text  = model.playingTypeName;
    self.remarkLab.text    = model.remarkExplain;
    self.onlineNumLab.text = model.onlineNum;
    
}

#pragma mark - 赔率说明
- (IBAction)oddsButton:(UIButton *)sender {
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
