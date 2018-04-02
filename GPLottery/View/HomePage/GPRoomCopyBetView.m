//
//  GPRoomCopyBetView.m
//  GPLottery
//
//  Created by cc on 2018/3/28.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPRoomCopyBetView.h"
#import "GPBetCopyCell.h"

@interface GPRoomCopyBetView()<UITableViewDelegate,UITableViewDataSource>

@end;

@implementation GPRoomCopyBetView


- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        NSArray *viewArr = [[NSBundle mainBundle]loadNibNamed:@"GPRoomCopyBetView" owner:self options:nil];
        self = viewArr[0];
        self.frame = frame;
        
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.scrollEnabled = NO;
        
        self.userInfoArray = @[@"玩家 : ",@"期数 : ",@"类别 : ",@"金额 : "].mutableCopy;
        [self.tableView registerNib:[UINib nibWithNibName:@"GPBetCopyCell" bundle:nil] forCellReuseIdentifier:@"betCopyCell"];
    }
    return self;
}


// 确认跟投
- (IBAction)makeSuerButton:(UIButton *)sender {
    
    if (self.makeSuerBtnBlock) {
        
        self.makeSuerBtnBlock();
    }
}

// 取消跟投
- (IBAction)cancelButton:(UIButton *)sender {
    
    if (self.cancelBtnBlock) {
        
        self.cancelBtnBlock();
    }
    
}

#pragma mark - tableview代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.userInfoArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GPBetCopyCell *betCopyCell = [tableView dequeueReusableCellWithIdentifier:@"betCopyCell" forIndexPath:indexPath];
    
    betCopyCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    betCopyCell.userInfoLab.text = [NSString stringWithFormat:@"%@",self.userInfoArray[indexPath.row]];
    
    if (self.betInfoArray.count>0) {
        
        betCopyCell.betInfoLab.text = [NSString stringWithFormat:@"%@",self.betInfoArray[indexPath.row]];
    }
    
    betCopyCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return betCopyCell;
}

- (NSMutableArray *)userInfoArray{
    
    if (!_userInfoArray) {
        
        self.userInfoArray = [NSMutableArray array];
        
    }
    return _userInfoArray;
}

- (NSMutableArray *)betInfoArray{
    
    if (!_betInfoArray) {
        
        self.betInfoArray = [NSMutableArray array];
    }
    return _betInfoArray;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
