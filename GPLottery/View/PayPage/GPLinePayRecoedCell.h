//
//  GPLinePayRecoedCell.h
//  GPLottery
//
//  Created by cc on 2018/3/31.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPLinePayRecordModel.h"

@interface GPLinePayRecoedCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *transferLab; // 0网银，1柜台
@property (weak, nonatomic) IBOutlet UILabel *statusLab;   // 0正在审核，1审核通过，2拒绝
@property (weak, nonatomic) IBOutlet UILabel *bankNameLab; // 银行
@property (weak, nonatomic) IBOutlet UILabel *receiveAccountNameLab; // 收款人
@property (weak, nonatomic) IBOutlet UILabel *receiveBankAddressLab; // 开户行
@property (weak, nonatomic) IBOutlet UILabel *receiveBankCardLab;    // 收款账号
@property (weak, nonatomic) IBOutlet UILabel *accountNameLab;  // 存款人姓名
@property (weak, nonatomic) IBOutlet UILabel *bankCardAccountLab; // 用户卡号后四位
@property (weak, nonatomic) IBOutlet UILabel *amountLab;  // 支付金额
@property (weak, nonatomic) IBOutlet UILabel *dateTimeLab; // 存款时间
@property (weak, nonatomic) IBOutlet UILabel *transferTypeLab; // 存款方式

- (void)setDataWithModel:(GPLinePayRecordModel *)model;

@end
