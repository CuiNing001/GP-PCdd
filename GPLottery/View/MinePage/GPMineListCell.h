//
//  GPMineListCell.h
//  GPLottery
//
//  Created by cc on 2018/3/13.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GPMineListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *mineListImage;
@property (weak, nonatomic) IBOutlet UILabel     *mineListText;
@property (weak, nonatomic) IBOutlet UILabel     *mineListMoney;

/*
 * @prama image:图标
 * @prame text :文字
 * @prame money:金额 (可为空)
 */
- (void)setDataWithImage:(NSString *)image text:(NSString *)text money:(NSString *)money;

@end
