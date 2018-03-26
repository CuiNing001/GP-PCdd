//
//  GPMsgSystemCell.h
//  GPLottery
//
//  Created by cc on 2018/3/26.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPMessageModel.h"

@interface GPMsgSystemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIWebView *webView;

- (void)setDataWithModel:(GPMessageModel *)messageModel;

@end
