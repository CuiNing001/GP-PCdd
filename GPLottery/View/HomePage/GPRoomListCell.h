//
//  GPRoomListCell.h
//  GPLottery
//
//  Created by cc on 2018/3/22.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPRoonListModel.h"

@interface GPRoomListCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel     *onlineNumRoomLab;  // 在线人数
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;       // 背景图
@property (weak, nonatomic) IBOutlet UILabel     *roomNameLab;       // 房间名
@property (strong, nonatomic) NSString           *roomID;            // 房间id

- (void)setDataWithModel:(GPRoonListModel *)model;

@end
