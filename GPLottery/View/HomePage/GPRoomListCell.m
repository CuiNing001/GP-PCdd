//
//  GPRoomListCell.m
//  GPLottery
//
//  Created by cc on 2018/3/22.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPRoomListCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation GPRoomListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDataWithModel:(GPRoonListModel *)model{
    
    int number = arc4random()%6;
    
    self.onlineNumRoomLab.text = [NSString stringWithFormat:@"在线%d人",model.onlineNumRoom.intValue+number];
    self.roomNameLab.text = model.name;
    self.roomID = [NSString stringWithFormat:@"%@",model.roomId];
    
//    NSString *imageLoc = [NSString stringWithFormat:@"%@%@",kImageLoction,model.url];
//    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:imageLoc]];
    
}

@end
