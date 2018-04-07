//
//  AppDelegate.m
//  GPLottery
//
//  Created by cc on 2018/3/11.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "AppDelegate.h"
#import "GPLoginViewController.h"

static NSString *appKey = @"65ae5c02bed5052256476fc4";
@interface AppDelegate ()<JMessageDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    

    // 初始化极光IM
    [JMessage setupJMessage:launchOptions appKey:appKey channel:@"iOS" apsForProduction:NO category:nil messageRoaming:NO];
    
    
    [JMessage registerForRemoteNotificationTypes:UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge categories:nil];
    
    // 添加极光监听事件通知
    [JMessage addDelegate:self withConversation:nil];
    
    //延迟加载VersionBtn - 避免wimdow还没出现就往上加控件造成的crash
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setVersionBtn];
    });
    
    // 禁止自动休眠
    [UIApplication sharedApplication].idleTimerDisabled=YES;
    
    
    return YES;
}

//获取DeviceToken成功
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    NSLog(@"|^^^^^^^^APPDELEGATE^^^^^^^^^^^|DeviceToken: {%@}",deviceToken);
    
    [JMessage registerDeviceToken:deviceToken];

}

/*
 * 功能：禁止横屏
 */
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}

// 当前登录用户被踢、非客户端修改密码强制登出、登录状态异常、被删除、被禁用、信息变更等事件
- (void)onReceiveUserLoginStatusChangeEvent:(JMSGUserLoginStatusChangeEvent *)event{

    if (event.eventType == kJMSGEventNotificationLoginKicked) {

        NSLog(@"^^^appdelegate^^^用户被登出^^^^^^^");
        
        [self.window.rootViewController.navigationController popToRootViewControllerAnimated:YES];

//        [self alertViewWithTitle:@"提醒" message:@"账号在其他设备登陆"];loginVC

        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提醒" message:@"账号在其他设备登陆" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            // 删除本地数据
            [UserDefaults deleateData];
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            GPLoginViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
            
            loginVC.hidesBottomBarWhenPushed = YES;
   
            // 创建单聊会话成功
            [self.window.rootViewController presentViewController:loginVC animated:YES completion:nil];
        }];
        
        [alertVC addAction:action];
        
        [self.window.rootViewController presentViewController:alertVC animated:YES completion:nil];
    }
}


#pragma mark - 添加全局按钮
-(void)setVersionBtn{
    
    self.btn = [MNAssistiveBtn mn_touchWithType:MNAssistiveTouchTypeNone
                                                     Frame:CGRectMake(0, 200, 50, 50)
                                                     title:nil
                                                titleColor:[UIColor whiteColor]
                                                 titleFont:[UIFont systemFontOfSize:11]
                                           backgroundColor:nil
                                           backgroundImage:[UIImage imageNamed:@"global_btn"]];
    
    [self.btn addTarget:self action:@selector(turnToService:) forControlEvents:UIControlEventTouchUpInside];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    [window addSubview:self.btn];
    
}
#pragma mark - 跳转客服
- (void)turnToService:(UIButton *)sender{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    GPServiceViewController *serviceVC = [storyboard instantiateViewControllerWithIdentifier:@"serviceVC"];
    
    serviceVC.hidesBottomBarWhenPushed = YES;
    
   
    
    // 创建单聊会话成功
    [self.window.rootViewController presentViewController:serviceVC animated:YES completion:nil];
    
}

#pragma mark - 提醒框
- (void)alertViewWithTitle:(NSString *)title message:(NSString *)message{
    
    UIAlertController *alert  = [UIAlertController alertControllerWithTitle:title
                                                                    message:message
                                                             preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction     *action = [UIAlertAction actionWithTitle:@"确定"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           
                                                           [JMSGUser logout:nil];
                                                           // 删除本地数据
                                                           [UserDefaults deleateData];
                                                       }];
    
    [alert addAction:action];
    
    [self.window.rootViewController presentViewController:alert
                       animated:YES
                     completion:nil];
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    // 开启自动休眠
    [UIApplication sharedApplication].idleTimerDisabled=NO;
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    // 禁止自动休眠
    [UIApplication sharedApplication].idleTimerDisabled=YES;
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
