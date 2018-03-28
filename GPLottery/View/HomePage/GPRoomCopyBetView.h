//
//  GPRoomCopyBetView.h
//  GPLottery
//
//  Created by cc on 2018/3/28.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GPRoomCopyBetView : UIView

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (copy, nonatomic) void(^makeSuerBtnBlock)(void);
@property (copy, nonatomic) void(^cancelBtnBlock)(void);
@property (strong, nonatomic) NSMutableArray *userInfoArray;
@property (strong, nonatomic) NSMutableArray *betInfoArray;

- (instancetype)initWithFrame:(CGRect)frame;

@end
