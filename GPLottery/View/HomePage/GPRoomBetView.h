//
//  GPRoomBetView.h
//  GPLottery
//
//  Created by cc on 2018/3/23.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GPRoomBetView : UIView

@property (weak, nonatomic) IBOutlet UIView *scrollBgView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *leftView;   // page1
@property (weak, nonatomic) IBOutlet UIView *middleView; // page2
@property (weak, nonatomic) IBOutlet UIView *rightView;  // page3

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *betBottom; // betViewBottom

@property (weak, nonatomic) IBOutlet UIButton *pageRightBtn;     // 右翻页
@property (weak, nonatomic) IBOutlet UIButton *pageLeftBtn;      // 左翻页
@property (weak, nonatomic) IBOutlet UIButton *oddsBtn;          // 赔率说明
@property (weak, nonatomic) IBOutlet UITextField *betTextField;  // 输入框

@property (weak, nonatomic) IBOutlet UILabel *leftViewResultLab;     // page1中奖结果
@property (weak, nonatomic) IBOutlet UILabel *middleViewResultLab;   // page2中奖结果
@property (weak, nonatomic) IBOutlet UILabel *rightViewResultLab;    // page3中奖结果
@property (weak, nonatomic) IBOutlet UICollectionView *leftCollectionView;    // page1投注内容
@property (weak, nonatomic) IBOutlet UICollectionView *middleCollectionView;  // page2投注内容
@property (weak, nonatomic) IBOutlet UICollectionView *rightCollectionView;   // page3投注内容

@property (copy, nonatomic) void(^pageRightBtnBlock)(void);  // 右切换页面按钮
@property (copy, nonatomic) void(^pageLeftBtnBlock)(void);   // 左切换页面按钮
@property (copy, nonatomic) void(^oddsBtnBlock)(void);       // 赔率说明按钮
@property (copy, nonatomic) void(^minBetBtnBlock)(void);     // 最小投注按钮
@property (copy, nonatomic) void(^doubleBetBtnBlock)(void);  // 双倍投注按钮
@property (copy, nonatomic) void(^betBtnBlock)(NSString *);        // 投注按钮
@property (copy, nonatomic) void(^dissmissBtnBlock)(void);   // 关闭页面按钮
@property (copy, nonatomic) void(^selecetItemBlock)(NSString *playId,NSString *minAmount,NSString *maxAmount,NSString *playingType); // cell点击

@property (strong, nonatomic) NSMutableArray *pageOneDataArray;   // page1数据源
@property (strong, nonatomic) NSMutableArray *pageTwoDataArray;   // page2数据源
@property (strong, nonatomic) NSMutableArray *pageThreeDataArray; // page3数据源

@property (strong, nonatomic) NSString *nameStr;
@property (strong, nonatomic) NSString *oddsStr;

@property (strong, nonatomic) NSMutableDictionary *cellIdentifierDic;


- (instancetype)initWithFrame:(CGRect)frame;

@end
