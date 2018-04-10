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
#import "GPOddsInfoModel.h"

static int page = 1;
@interface GPRoomBetView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextFieldDelegate,UIScrollViewDelegate>

@property (assign, nonatomic) CGFloat pageWidth;
@property (strong, nonatomic) NSString *cellIdentifier;


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
    
    self.cellIdentifierDic = [NSMutableDictionary new];
    
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
    
    self.pageOneDataArray = [NSMutableArray array];
    self.pageTwoDataArray = [NSMutableArray array];
    self.pageThreeDataArray = [NSMutableArray array];
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
        
        self.betBtnBlock(self.betTextField.text);
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
//    self.leftCollectionView.delaysContentTouches = false;
    
    // middleCollectionView布局
    UICollectionViewFlowLayout *middleFlowLayout = [[UICollectionViewFlowLayout alloc]init];
    [middleFlowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    middleFlowLayout.minimumLineSpacing = 25;
    middleFlowLayout.minimumInteritemSpacing = 10;
    middleFlowLayout.itemSize = CGSizeMake((self.leftCollectionView.frame.size.width-60)/7, 50);
    middleFlowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    self.middleCollectionView.collectionViewLayout = middleFlowLayout;
//    self.middleCollectionView.delaysContentTouches = false;
    self.middleCollectionView.allowsMultipleSelection = NO;
    
    // rightCollectionView布局
    UICollectionViewFlowLayout *rightFlowLayout = [[UICollectionViewFlowLayout alloc]init];
    [rightFlowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    rightFlowLayout.minimumLineSpacing = 25;
    rightFlowLayout.minimumInteritemSpacing = 10;
    rightFlowLayout.itemSize = CGSizeMake(80, 80);
    rightFlowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    self.rightCollectionView.collectionViewLayout = rightFlowLayout;
//    self.rightCollectionView.delaysContentTouches = false;
    
//    self.cellIdentifier = [NSString stringWithFormat:@"betContentCell"];
//    // 注册cell
//    [self.leftCollectionView registerNib:[UINib nibWithNibName:@"GPBetContentCell" bundle:nil] forCellWithReuseIdentifier:self.cellIdentifier];
//    [self.middleCollectionView registerNib:[UINib nibWithNibName:@"GPBetContentCell" bundle:nil] forCellWithReuseIdentifier:self.cellIdentifier];
//    [self.rightCollectionView registerNib:[UINib nibWithNibName:@"GPBetContentCell" bundle:nil] forCellWithReuseIdentifier:self.cellIdentifier];

    
    
}

#pragma mark - collection view 代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (collectionView.tag == 999) { // page1
        
        return self.pageOneDataArray.count;
        
    }else if (collectionView.tag == 998){ // page2
        
        return self.pageTwoDataArray.count;
        
    }else if (collectionView.tag == 997){ // page3
        
        return self.pageThreeDataArray.count;
    }
    
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView.tag == 999) { // page1
        
        NSString *pageOneIdentifier = [NSString stringWithFormat:@"one%ld",indexPath.row];
        
        [self.leftCollectionView registerNib:[UINib nibWithNibName:@"GPBetContentCell" bundle:nil] forCellWithReuseIdentifier:pageOneIdentifier];
        
        GPBetContentCell *betContentCell = [collectionView dequeueReusableCellWithReuseIdentifier:pageOneIdentifier forIndexPath:indexPath];
        
        GPOddsInfoModel *oddsModel = self.pageOneDataArray[indexPath.row];
        
        [betContentCell setDataWithMode:oddsModel];
        
        return betContentCell;
        
    }else if (collectionView.tag == 998){ // page2
        
        NSString *pageTwoIdentifier = [NSString stringWithFormat:@"two%ld",indexPath.row];
        
        [self.middleCollectionView registerNib:[UINib nibWithNibName:@"GPBetContentCell" bundle:nil] forCellWithReuseIdentifier:pageTwoIdentifier];
        
        GPBetContentCell *betContentCell = [collectionView dequeueReusableCellWithReuseIdentifier:pageTwoIdentifier forIndexPath:indexPath];
        
        GPOddsInfoModel *oddsModel = self.pageTwoDataArray[indexPath.row];
        
        [betContentCell setDataWithMode:oddsModel];
        
        return betContentCell;
        
    }else{ // page3
        
        NSString *pageThreeIdentifier = [NSString stringWithFormat:@"three%ld",indexPath.row];
        
        [self.rightCollectionView registerNib:[UINib nibWithNibName:@"GPBetContentCell" bundle:nil] forCellWithReuseIdentifier:pageThreeIdentifier];
        
        GPBetContentCell *betContentCell = [collectionView dequeueReusableCellWithReuseIdentifier:pageThreeIdentifier forIndexPath:indexPath];
        
        GPOddsInfoModel *oddsModel = self.pageThreeDataArray[indexPath.row];
        
        if (self.pageThreeDataArray.count>0) {
            
            if (indexPath.row == 0) {
                
                betContentCell.nameLab.backgroundColor = [UIColor redColor];
                betContentCell.nameLab.layer.masksToBounds = YES;
                betContentCell.nameLab.layer.cornerRadius = 20;
            }else if (indexPath.row == 1){
                
                betContentCell.nameLab.backgroundColor = [UIColor greenColor];
                betContentCell.nameLab.layer.masksToBounds = YES;
                betContentCell.nameLab.layer.cornerRadius = 20;
            }else if (indexPath.row == 2){
                
                betContentCell.nameLab.backgroundColor = [UIColor blueColor];
                betContentCell.nameLab.layer.masksToBounds = YES;
                betContentCell.nameLab.layer.cornerRadius = 20;
            }else{
                
                betContentCell.nameLab.backgroundColor = [UIColor orangeColor];
                betContentCell.nameLab.layer.masksToBounds = YES;
                betContentCell.nameLab.layer.cornerRadius = 20;
            }
        }
        
        [betContentCell setDataWithMode:oddsModel];
        
        
        
        return betContentCell;
    }
}

// 是否允许选中
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
}


// 点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"+++++++%ld",indexPath.row);
    
    if (collectionView.tag == 999) { // page1
        
        // 获取当前选中的item
        GPBetContentCell *betCell = (GPBetContentCell *)[self.leftCollectionView cellForItemAtIndexPath:indexPath];
        // 修改选中item的UI
        betCell.bgView.layer.borderWidth = 0.5;
        betCell.bgView.layer.borderColor = [UIColor whiteColor].CGColor;
        
        GPOddsInfoModel *oddsModel = self.pageOneDataArray[indexPath.row];
        self.leftViewResultLab.text = [NSString stringWithFormat:@"中奖和值[%@]",oddsModel.winNumber];
        self.nameStr = oddsModel.name;
        self.oddsStr = oddsModel.odds;
        
        if (self.selecetItemBlock) {
            
            self.selecetItemBlock(oddsModel.playingId,oddsModel.minAmout,oddsModel.maxAmout,oddsModel.name);
        }
        
        NSLog(@"|BETVIEW|-name:%@-odds:%@",self.nameStr,self.oddsStr);
        
        
    }else if (collectionView.tag == 998){ // page2
        
        // 获取当前选中的item
        GPBetContentCell *betCell = (GPBetContentCell *)[self.middleCollectionView cellForItemAtIndexPath:indexPath];
        // 修改选中item的UI
        betCell.bgView.layer.borderWidth = 0.5;
        betCell.bgView.layer.borderColor = [UIColor whiteColor].CGColor;
        
        GPOddsInfoModel *oddsModel = self.pageTwoDataArray[indexPath.row];
        self.middleViewResultLab.text = [NSString stringWithFormat:@"中奖号码[%@]",oddsModel.winNumber];
        self.nameStr = oddsModel.name;
        self.oddsStr = oddsModel.odds;
        
        if (self.selecetItemBlock) {
            
            self.selecetItemBlock(oddsModel.playingId,oddsModel.minAmout,oddsModel.maxAmout,oddsModel.name);
        }
        
        NSLog(@"|BETVIEW|-name:%@-odds:%@",self.nameStr,self.oddsStr);
        
    }else if (collectionView.tag == 997){ // page3
        
        // 获取当前选中的item
        GPBetContentCell *betCell = (GPBetContentCell *)[self.rightCollectionView cellForItemAtIndexPath:indexPath];
        // 修改选中item的UI
        betCell.bgView.layer.borderWidth = 0.5;
        betCell.bgView.layer.borderColor = [UIColor whiteColor].CGColor;
        
        GPOddsInfoModel *oddsModel = self.pageThreeDataArray[indexPath.row];
        self.rightViewResultLab.text = [NSString stringWithFormat:@"中奖和值[%@]",oddsModel.winNumber];
        self.nameStr = oddsModel.name;
        self.oddsStr = oddsModel.odds;
        
        if (self.selecetItemBlock) {
            
            self.selecetItemBlock(oddsModel.playingId,oddsModel.minAmout,oddsModel.maxAmout,oddsModel.name);
        }
        
        NSLog(@"|BETVIEW|-name:%@-odds:%@",self.nameStr,self.oddsStr);
    }
    
    
}

// 取消未选中item的点击状态
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    GPBetContentCell *betCell = (GPBetContentCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    betCell.bgView.layer.borderWidth = 0;
    betCell.bgView.layer.borderColor = [UIColor clearColor].CGColor;
    
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
    
    // 根据scrollview偏移量绑定相对应的page
    CGPoint page1 = CGPointMake(0, 0);
    CGPoint page2 = CGPointMake(self.pageWidth, 0);
    CGPoint page3 = CGPointMake(self.pageWidth*2, 0);
    
    if (scrollView.contentOffset.x == page1.x) {
        
        page = 1;
    }else if (scrollView.contentOffset.x == page2.x){
        
        page = 2;
    }else if (scrollView.contentOffset.x == page3.x){
        
        page = 3;
    }
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
