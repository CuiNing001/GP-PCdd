//
//  GPRoomBetView.m
//  GPLottery
//
//  Created by cc on 2018/3/23.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPRoomBetView.h"
#import "GPBetContentCell.h"
#import "sys/utsname.h"

static int page = 1;
@interface GPRoomBetView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextFieldDelegate,UIScrollViewDelegate>

@property (assign, nonatomic) CGFloat pageWidth;

@end
@implementation GPRoomBetView


- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        NSArray *viewArr = [[NSBundle mainBundle]loadNibNamed:@"GPRoomBetView" owner:self options:nil];
        
        self = viewArr[0];
        
        self.frame = frame;
        
        [self loadSubView];
    }
    return self;
}

#pragma mark - 加载子控件
- (void)loadSubView{
    
    self.pageWidth = kSize_width-20;
    
    // 赔率说明按钮添加边框
    self.oddsBtn.layer.borderWidth = 1;
    self.oddsBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    
    // 设置collection view布局
    [self setCollectionFlowLayout];
    
    // 添加collection view代理
    [self addCollectionViewDelegate];
    
    // 添加textfield代理
    self.betTextField.delegate = self;
    
    // 添加scroll view 代理
    self.scrollView.delegate = self;
    
    //增加监听，当键盘出现时view上移
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    // 添加tap手势，回收键盘
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dissMissKeyBoard:)];
//    [self addGestureRecognizer:tap];
}

#pragma mark - 右切换页面按钮
- (IBAction)pageRightButton:(UIButton *)sender {
    
    if (self.pageRightBtnBlock) {
        
        self.pageRightBtnBlock();
    }
    
    if (page == 1) {
        
        [UIView animateWithDuration:0.5 animations:^{
            
            self.scrollView.contentOffset = CGPointMake(self.pageWidth, 0);
        }];
        
        page = 2;
        return;
        
    }else if (page == 2){
        
        [UIView animateWithDuration:0.5 animations:^{
            
            self.scrollView.contentOffset = CGPointMake(self.pageWidth*2, 0);
        }];
        
        page = 3;
        return;
        
    }else if (page == 3){
        
        [UIView animateWithDuration:0.5 animations:^{
            
            self.scrollView.contentOffset = CGPointMake(0, 0);
        }];
        
        page = 1;
        return;
    }
    
}

#pragma mark -左切换页面按钮
- (IBAction)pageLeftButton:(UIButton *)sender {
    
    if (self.pageLeftBtnBlock) {
        
        self.pageLeftBtnBlock();
    }
    
    if (page == 1) {
        
        [UIView animateWithDuration:0.5 animations:^{
            
            self.scrollView.contentOffset = CGPointMake(self.pageWidth*2, 0);
        }];
        
        page = 3;
        return;
        
    }else if (page == 2){
        
        [UIView animateWithDuration:0.5 animations:^{
            
            self.scrollView.contentOffset = CGPointMake(0, 0);
        }];
        
        page = 1;
        return;
        
    }else if (page == 3){
        
        [UIView animateWithDuration:0.5 animations:^{
            
            self.scrollView.contentOffset = CGPointMake(self.pageWidth, 0);
        }];
        
        page = 2;
        return;
    }
    

    
}

#pragma mark - 双倍投注按钮
- (IBAction)doubleBetButton:(UIButton *)sender {
    
    if (self.doubleBetBtnBlock) {
        
        self.doubleBetBtnBlock();
    }
}

#pragma mark - 最小投注按钮
- (IBAction)minBetButton:(UIButton *)sender {
    
    if (self.minBetBtnBlock) {
        
        self.minBetBtnBlock();
    }
}

#pragma mark - 赔率说明按钮
- (IBAction)oddsButton:(UIButton *)sender {
    
    if (self.oddsBtnBlock) {
        
        self.oddsBtnBlock();
    }
}

#pragma mark - 确定投注按钮
- (IBAction)makeSureBetButton:(UIButton *)sender {
    
    if (self.betBtnBlock) {
        
        self.betBtnBlock();
    }
}

#pragma mark - 关闭页面
- (IBAction)dissmissBetView:(UIButton *)sender {
    
    if (self.dissmissBtnBlock) {
        
        self.dissmissBtnBlock();
    }
    
}

#pragma mark - collection view添加代理
- (void)addCollectionViewDelegate{
    
    self.leftCollectionView.delegate = self;
    self.leftCollectionView.dataSource = self;
    
    self.middleCollectionView.delegate = self;
    self.middleCollectionView.dataSource = self;
    
    self.rightCollectionView.delegate = self;
    self.rightCollectionView.dataSource = self;
}

#pragma mark - collection view布局
- (void)setCollectionFlowLayout{
    
    // leftCollectionView 布局
    UICollectionViewFlowLayout *leftFlowLayout = [[UICollectionViewFlowLayout alloc]init];
    [leftFlowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    leftFlowLayout.minimumLineSpacing = 25;
    leftFlowLayout.minimumInteritemSpacing = 10;
    leftFlowLayout.itemSize = CGSizeMake((self.leftCollectionView.frame.size.width-60)/5, 50);
    leftFlowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    self.leftCollectionView.collectionViewLayout = leftFlowLayout;
    
    // middleCollectionView布局
    UICollectionViewFlowLayout *middleFlowLayout = [[UICollectionViewFlowLayout alloc]init];
    [middleFlowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    middleFlowLayout.minimumLineSpacing = 25;
    middleFlowLayout.minimumInteritemSpacing = 10;
    middleFlowLayout.itemSize = CGSizeMake((self.leftCollectionView.frame.size.width-60)/5, 50);
    middleFlowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    self.middleCollectionView.collectionViewLayout = middleFlowLayout;
    
    // rightCollectionView布局
    UICollectionViewFlowLayout *rightFlowLayout = [[UICollectionViewFlowLayout alloc]init];
    [rightFlowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    rightFlowLayout.minimumLineSpacing = 25;
    rightFlowLayout.minimumInteritemSpacing = 10;
    rightFlowLayout.itemSize = CGSizeMake((self.leftCollectionView.frame.size.width-30)/2, 50);
    rightFlowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    self.rightCollectionView.collectionViewLayout = rightFlowLayout;
    

    // 注册cell
    [self.leftCollectionView registerNib:[UINib nibWithNibName:@"GPBetContentCell" bundle:nil] forCellWithReuseIdentifier:@"betContentCell"];
    [self.middleCollectionView registerNib:[UINib nibWithNibName:@"GPBetContentCell" bundle:nil] forCellWithReuseIdentifier:@"betContentCell"];
    [self.rightCollectionView registerNib:[UINib nibWithNibName:@"GPBetContentCell" bundle:nil] forCellWithReuseIdentifier:@"betContentCell"];

    
    
}

#pragma mark - collection view 代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 15;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    GPBetContentCell *betContentCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"betContentCell" forIndexPath:indexPath];
    
    return betContentCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"+++++++%ld",indexPath.row);
    
//    self.betContentCell.bgView.layer.borderWidth = 0.5;
//    self.betContentCell.bgView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    
    
    
}

#pragma mark - textfield代理方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self.betTextField resignFirstResponder];
    
    [UIView animateWithDuration:1 animations:^{
        
        self.betBottom.constant = 10;
    }];
    
    return YES;
}

// 键盘出现时修改chatView底部约束
- (void)keyboardWillShow:(NSNotification *)aNotification{
    
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    
    // 调整chatview高度
    [UIView animateWithDuration:1 animations:^{
        
        // 获取设备型号
        struct utsname systemInfo;
        uname(&systemInfo);
        NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
        
        if ([deviceString isEqualToString:@"iPhone10,3"]) {
            
            // iphone X 需减掉底部安全区高度34
            self.betBottom.constant = keyboardRect.size.height-34;
        }else{
            
            self.betBottom.constant = keyboardRect.size.height;
        }
        
    }];
    
}

#pragma mark - scroll view 代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
