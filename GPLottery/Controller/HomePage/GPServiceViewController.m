//
//  GPServiceViewController.m
//  GPLottery
//
//  Created by cc on 2018/3/22.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "GPServiceViewController.h"
#import "GPServiceReciveCell.h"
#import "GPServiceSenderCell.h"
#import <TZImagePickerController/TZImagePickerController.h>
#import "sys/utsname.h"
#import "GPServiceSenderCell.h"
#import "GPMessageModel.h"
#import "GPServiceReciveCell.h"
#import "GPServiceLageImageView.h"

@interface GPServiceViewController ()<UITableViewDelegate,UITableViewDataSource,TZImagePickerControllerDelegate,UITextViewDelegate,JMSGMessageDelegate,JMSGConversationDelegate,JMessageDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHeight;  // 距离底部高度
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextView *inputTextView;
@property (strong, nonatomic) GPInfoModel        *infoModel;            // 本地数据
@property (strong, nonatomic) MBProgressHUD      *progressHUD;
@property (strong, nonatomic) NSString           *token;
@property (strong, nonatomic) NSMutableArray     *msgDataArray;         // 消息数据
@property (strong, nonatomic) NSData *imageData; // 图片数据
@property (strong, nonatomic) GPServiceLageImageView *largeImageView;   // 加载大图

@end

@implementation GPServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self loadData];
    [self loadSubView];
}
- (IBAction)dissmissButton:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    
    
}


- (void)loadData{
    
    [self joinSingleChatRoom];
}

- (void)loadServiceNetData{
    
    [self.progressHUD showAnimated:YES];
    
    [self loadUserDefaultsData];
    
    NSString *serviceLoc = [NSString stringWithFormat:@"%@1/welcome",kBaseLocation];
    
    // 请求登陆接口
    __weak typeof(self)weakSelf = self;
    [AFNetManager requestPOSTWithURLStr:serviceLoc paramDic:nil token:self.token finish:^(id responserObject) {
        
        NSLog(@"|SERVICE-VC|success:%@",responserObject);
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        GPRespondModel *respondModel = [GPRespondModel new];
        
        [respondModel setValuesForKeysWithDictionary:responserObject];
        
        if (respondModel.code.integerValue == 9200) {
            
//            [ToastView toastViewWithMessage:respondModel.msg timer:1.5];
            
            
        }else{
            
            [ToastView toastViewWithMessage:respondModel.msg timer:2.5];
        }
        
    } enError:^(NSError *error) {
        
        [weakSelf.progressHUD hideAnimated:YES];
        
        [ToastView toastViewWithMessage:@"数据连接出错，请稍后再试" timer:3.0];
        
    }];
}

#pragma mark - 加入房间
- (void)joinSingleChatRoom{
    
    NSString *usernameSingle = kAdminUsername;
    // 获取单聊会话
    [JMSGConversation singleConversationWithUsername:usernameSingle];
    
    // 未获取到对应单聊会话
    if ([JMSGConversation singleConversationWithUsername:usernameSingle]) {
        
        // 创建单聊会话
        [JMSGConversation createSingleConversationWithUsername:usernameSingle completionHandler:^(id resultObject, NSError *error) {
            
            NSLog(@"^^^^^^^^^^^^^^^创建单聊会话^^^^^^^^^^^^^^^^^^%@",resultObject);
            
            if (!error) {
                [ToastView toastViewWithMessage:@"加入房间成功" timer:3.0];
                
                [self loadServiceNetData];
                
            }else{
                
                // 创建单聊会话失败
                [ToastView toastViewWithMessage:@"加入房间失败，请稍后再试" timer:3.0];
            }
        }];
    }else{
        // 获取到对应单聊会话
        [ToastView toastViewWithMessage:@"加入房间成功" timer:3.0];
        
        [self loadServiceNetData];
    }
    
}

- (void)loadSubView{
    
//    [self joinSingleChatRoom];
    
    self.title = @"客服";
    
    // 添加极光监听事件通知
    [JMessage addDelegate:self withConversation:nil];
    
    // 初始化加载框
    self.progressHUD = [[MBProgressHUD alloc]initWithFrame:CGRectMake(0, 0, kSize_width, kSize_height)];
    [self.view addSubview:_progressHUD];
    
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    
    // tableView样式
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    // tableview下滑取消键盘
    self.tableView.keyboardDismissMode  = UIScrollViewKeyboardDismissModeInteractive;
    
    // textView代理
    self.inputTextView.delegate = self;
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    // 添加点击事件
//    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(dissmissKeyboard:)];
//    [self.view addGestureRecognizer:recognizer];
//    tap.delegate = self;
    
    // 注册发送cell
    [self.tableView registerNib:[UINib nibWithNibName:@"GPServiceSenderCell" bundle:nil] forCellReuseIdentifier:@"serviceSenderCell"];
    
    // 注册接收cell
    [self.tableView registerNib:[UINib nibWithNibName:@"GPServiceReciveCell" bundle:nil] forCellReuseIdentifier:@"serviceReceiveCell"];
    
    // 加载大图
    self.largeImageView = [[GPServiceLageImageView alloc]initWithFrame:CGRectMake(0, 0, kSize_width, kSize_height)];
    [self.view addSubview:self.largeImageView];
    self.largeImageView.hidden = YES;
    __weak typeof(self)weakSelf = self;
    self.largeImageView.dissmissBlock = ^{
      
        weakSelf.largeImageView.hidden = YES;

    };

}

#pragma mark -  键盘出现时修改chatView底部约束
- (void)keyboardWillShow:(NSNotification *)aNotification
{
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
            self.bottomHeight.constant = keyboardRect.size.height-34;
        }else{
            
            self.bottomHeight.constant = keyboardRect.size.height;
        }
        
    }];
    
}

- (void)keyboardWillHide:(NSNotification *)aNotification{
    
    // 取消键盘后还原view的frame
    [UIView animateWithDuration:0.5 animations:^{
        
        self.bottomHeight.constant = 0;
    }];
}

#pragma mark - 加载本地数据
- (void)loadUserDefaultsData{
    
    NSMutableDictionary *infoDic = [UserDefaults searchData];
    
    self.infoModel               = [[GPInfoModel alloc]init];
    
    [self.infoModel setValuesForKeysWithDictionary:infoDic];
    
    self.token   = self.infoModel.token;
    
}
- (void)createMessageAsyncWithMediaContent:(JMSGMediaAbstractContent *)content
                         completionHandler:(JMSGCompletionHandler JMSG_NULLABLE)handler{
    
  
    
    NSLog(@"|===============|%@",content.originMediaLocalPath);
}

#pragma mark - 图片选择器
- (void)chooseImage{
    
    // 初始化照片选择器
    TZImagePickerController *imagePickerVC = [[TZImagePickerController alloc]initWithMaxImagesCount:1 delegate:self];
    
    imagePickerVC.allowPickingVideo               = NO;  // 设置不能选择视频
    imagePickerVC.sortAscendingByModificationDate = NO;  // 设置按时间排序照片，拍照按钮在第一个
    imagePickerVC.allowPickingOriginalPhoto       = NO;  // 设置不能发送原图
    
    // 选择图片后回调
    [imagePickerVC setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
        // 获取图片
        UIImage *selectImage = photos.firstObject;
        
//        NSDictionary *contentDic = @{@"image":selectImage,@"type":@"image"};
        
        // 转换为data
        self.imageData = UIImagePNGRepresentation(selectImage);
        
//        // image消息的实例对象
        JMSGImageContent *imageContent = [[JMSGImageContent alloc]initWithImageData:self.imageData];
//
        [JMSGMessage createSingleMessageWithContent:imageContent username:kAdminUsername];
        
        [JMSGMessage sendSingleImageMessage:self.imageData toUser:kAdminUsername];
    
        [self.tableView reloadData];
        
        
        
    }];
    
    // 模态图片选择界面
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}



#pragma mark - 发送消息结果回调
- (void)onSendMessageResponse:(JMSGMessage *)message error:(NSError *)error{

    if (!error) {
        
        if (message.contentType == kJMSGContentTypeText) {
            
            JMSGTextContent *textContent = (JMSGTextContent *)message.content;
            
            NSString *msgText = textContent.text;
            
            NSLog(@"|SERVICE-VC|-|send-success|%@",msgText);
            [ToastView toastViewWithMessage:@"文字发送成功" timer:3.0];
            
        }else if (message.contentType == kJMSGContentTypeImage){
            
            NSLog(@"|SERVICE-VC|-|send-success|");
            
            [ToastView toastViewWithMessage:@"图片发送成功" timer:3.0];
            
        }
 
        [self.msgDataArray addObject:message];
        [self.tableView reloadData];
    }else{
        
        NSLog(@"|SERVICE-VC|-|send-error|%@",error);
        [ToastView toastViewWithMessage:@"发送失败" timer:3.0];
    }
}

#pragma mark - 接收消息回调
- (void)onReceiveMessage:(JMSGMessage *)message error:(NSError *)error{
    
    if (!error) {   // 消息接收成功
        
        NSLog(@"|RECEIVE-VC|接收消息成功");
        // 单聊
        if (message.targetType == kJMSGConversationTypeSingle) {

            [self.msgDataArray addObject:message];
            
            [self.tableView reloadData];
        }
        
    }else{  // 消息接收失败
        
        NSLog(@"|RECEIVE-VC|接收消息失败error%ld",(long)error.code);
    }

}



#pragma mark - 获取图片
- (IBAction)addImage:(UIButton *)sender {
    
    [self chooseImage];
}

#pragma mark - 放大过程中出现的缓慢动画
- (void)shakeToShow:(UIView*)aView{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.3;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
    self.largeImageView.hidden = NO;
}

#pragma mark - 点击空白处回收键盘
//- (void)dissmissKeyboard:(UITapGestureRecognizer *)tap{
//
//    [self.inputTextView resignFirstResponder];
//
//    // 取消键盘后还原view的frame
//    [UIView animateWithDuration:0.5 animations:^{
//
//        self.bottomHeight.constant = 0;
//    }];
//}

#pragma mark - textview代理方法
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        
        // 发送消息
        JMSGTextContent *content = [[JMSGTextContent alloc]initWithText:self.inputTextView.text];
        JMSGMessage *sendMessage = [JMSGMessage createSingleMessageWithContent:content username:kAdminUsername];
        [JMSGMessage sendMessage:sendMessage];
        NSError *error;
        [self onSendMessageResponse:sendMessage error:error];
        
        
        // 发送成功后回收键盘，清空输入框
        self.inputTextView.text = @"";
        [textView resignFirstResponder];
        // 取消键盘后还原view的frame
        [UIView animateWithDuration:0.5 animations:^{

            self.bottomHeight.constant = 0;
        }];
        return NO;
    }
    return YES;
}

#pragma mark - tableview代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.msgDataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JMSGMessage *sendMessage = self.msgDataArray[indexPath.row];
    
    if (sendMessage.contentType == kJMSGContentTypeText) {
        
        return 120;
    }else{
        
        return 200;
    }
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JMSGMessage *sendMessage = self.msgDataArray[indexPath.row];
    
    if (![sendMessage.fromType isEqualToString:@"admin"]) {
        
        GPServiceSenderCell *serviceSenderCell = [tableView dequeueReusableCellWithIdentifier:@"serviceSenderCell" forIndexPath:indexPath];
        
//        serviceSenderCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        serviceSenderCell.backgroundColor = [UIColor clearColor];
        
        [serviceSenderCell setDataWithMessage:sendMessage];
        
        return serviceSenderCell;
    }else{
        
        GPServiceReciveCell *serviceReceiveCell = [tableView dequeueReusableCellWithIdentifier:@"serviceReceiveCell" forIndexPath:indexPath];
        
//        serviceReceiveCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        serviceReceiveCell.backgroundColor = [UIColor clearColor];
        
        [serviceReceiveCell setDataWithMessage:sendMessage];
        
        return serviceReceiveCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    JMSGMessage *sendMessage = self.msgDataArray[indexPath.row];

    if (sendMessage.contentType == kJMSGContentTypeImage) {
        
        self.largeImageView.hidden = NO;
        [self shakeToShow:self.largeImageView];
        
        [self.largeImageView setImageDataWithMessage:sendMessage];
    }
    
}



#pragma mark - 懒加载
- (NSMutableArray *)msgDataArray{
    
    if (!_msgDataArray) {
        
        self.msgDataArray = [NSMutableArray array];
        
    }
    return _msgDataArray;
}

#pragma mark - dealloc
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
