//
//  GPChooseBankCell.h
//  GPLottery
//
//  Created by cc on 2018/3/19.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GPChooseBankCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *bankNameLab;


- (void)setDataWithBankName:(NSString *)bankName;

@end
