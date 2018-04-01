//
//  GPLinePayRecoedCell.m
//  GPLottery
//
//  Created by cc on 2018/3/31.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPLinePayRecoedCell.h"

@implementation GPLinePayRecoedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDataWithModel:(GPLinePayRecordModel *)model{
    
    // 转账类型
    if (model.type.integerValue == 1) {
        
        self.transferLab.text = @"支付宝";
    }else{
        self.transferLab.text = @"银行转账";
    }
    // 审核状态
    if (model.status.integerValue == 0) {
        
        self.statusLab.text = @"正在审核";
        
    }else if (model.status.integerValue == 1){
        
        self.statusLab.text = @"审核通过";
    }else if (model.status.integerValue == 2){
        
        self.statusLab.text = @"拒绝";
    }
    // 银行
    self.bankNameLab.text = model.bankName;
    // 收款人
    self.receiveAccountNameLab.text = model.receiveAccountName;
    // 开户行
    self.receiveBankAddressLab.text = model.receiveBankAddress;
    // 收款账号
    self.receiveBankCardLab.text = model.receiveBankCardAccount;
    // 存款人姓名
    self.accountNameLab.text = model.accountName;
    // 存款人卡号
    self.bankCardAccountLab.text = [NSString stringWithFormat:@"***************%@",model.bankCardAccount];
    // 支付金额
    self.amountLab.text = model.amount;
    // 存款时间
    self.dateTimeLab.text = model.dateTime;
    // 存款方式
    // 转账类型
    if (model.type.integerValue == 1) {
        
        self.transferTypeLab.text = @"支付宝";
    }else{
        self.transferTypeLab.text = @"银行转账";
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
