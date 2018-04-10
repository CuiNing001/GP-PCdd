//
//  UserDefaults.m
//  PCdd
//
//  Created by mading shouyou on 2017/11/2.
//  Copyright © 2017年 mading shouyou. All rights reserved.
//

#import "UserDefaults.h"

@implementation UserDefaults


///*
// * 存储页面启动次数
// */
//+ (void)addLunchCount{
//    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//    [userDefault setObject:@"1" forKey:@"count"];
//    [userDefault synchronize];
//}
//
///*
// * 点击公告确认修改次数
// */
//+ (void)changeLunchCount{
//
//    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//    [userDefault setObject:@"2" forKey:@"count"];
//    [userDefault synchronize];
//}
//
///*
// * 删除启动次数
// */
//+ (void)deleateLunchCount{
//
//    NSUserDefaults *userDefale = [NSUserDefaults standardUserDefaults];
//    [userDefale removeObjectForKey:@"count"];
//    [userDefale synchronize];
//}

/*
 * 添加数据
 * username:用户名
 * password:密码
 * token   :服务器返回的token
 * nickname:昵称
 * islogin :登录状态（1==已登录，0==未登录）
 * type    :充值渠道
 * type    :环信登录ID
 * level   :等级
 * autograph:签名
 * userType:用户类型1：普通用户，4：代理用户
 * aboutUrl:个人中心关于地址
 * indexLunchCount:首页导航页点击次数
 * roomLunchCount :房间导航页点击次数
 * betLunchCount  :下注导航页点击次数
 */
+ (void)addDataWithUsername:(NSString *)username
                   password:(NSString *)password
                      token:(NSString *)token
                   nickname:(NSString *)nickname
                    islogin:(NSString *)islogin
                   moneyNum:(NSString *)moneyNum
                     userID:(NSString *)userID
                      level:(NSString *)level
                  autograph:(NSString *)autograph
{

    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:username forKey:@"loginName"];
    [userDefault setObject:password forKey:@"password"];
    [userDefault setObject:token    forKey:@"token"];
    [userDefault setObject:nickname forKey:@"nickname"];
    [userDefault setObject:islogin  forKey:@"islogin"];
    [userDefault setObject:moneyNum forKey:@"moneyNum"];
    [userDefault setObject:userID   forKey:@"userID"];
    [userDefault setObject:level    forKey:@"level"];
    [userDefault setObject:autograph forKey:@"autograph"];
    [userDefault setObject:@"1"     forKey:@"userType"];
    [userDefault setObject:@"aboutUrl" forKey:@"aboutUrl"];
    [userDefault setObject:@"1" forKey:@"indexLunchCount"];
    [userDefault setObject:@"1" forKey:@"roomLunchCount"];
    [userDefault setObject:@"1" forKey:@"betLunchCount"];
    [userDefault setObject:@"1" forKey:@"noticeAlertCount"];
    [userDefault synchronize];
    NSLog(@"username:%@--password:%@--token:%@--nickname:%@--islogin%@--moneyNum:%@--userID%@--level%@--autograph:%@",username,password,token,nickname,islogin,moneyNum,userID,level,autograph);
}

/*
 * 修改公告弹窗点击状态
 */
+ (void)changeLunchCountWithCount:(NSString *)count{
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:count forKey:@"noticeAlertCount"];
    [userDefault synchronize];
}

/*
 * 修改昵称
 * nickname:昵称
 */
+ (void)upDataWithNickname:(NSString *)nickname
{
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:nickname forKey:@"nickname"];
    [userDefault synchronize];
    
}

/*
 * 修改签名
 * autograph:签名
 */
+ (void)upDataWithAutograph:(NSString *)autograph{
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:autograph forKey:@"autograph"];
    [userDefault synchronize];
}

/*
 * 修改密码
 * password:昵称
 */
+ (void)upDataWithPassword:(NSString *)password
{
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:password forKey:@"password"];
    [userDefault synchronize];
    
}

/*
 * 修改等级
 */
+ (void)upDataWithLevel:(NSString *)level
{
    NSUserDefaults *userDefaule = [NSUserDefaults standardUserDefaults];
    [userDefaule setObject:level forKey:@"level"];
    [userDefaule synchronize];

}

/*
 * 修改用户类型
 */
+ (void)upDataWithUserType:(NSString *)userType{
    
    NSUserDefaults *userDefaule = [NSUserDefaults standardUserDefaults];
    [userDefaule setObject:userType forKey:@"userType"];
    [userDefaule synchronize];
}

/*
 * 修改关于页面地址
 */
+ (void)upDataWithAboutUrl:(NSString *)aboutUrl{
    
    NSUserDefaults *userDefaule = [NSUserDefaults standardUserDefaults];
    [userDefaule setObject:aboutUrl forKey:@"aboutUrl"];
    [userDefaule synchronize];
}

/*
 * 修改首页lunch点击次数
 */
+ (void)upDataWithIndexLunchCount:(NSString *)indexLunchCount{
    
    NSUserDefaults *userDefaule = [NSUserDefaults standardUserDefaults];
    [userDefaule setObject:indexLunchCount forKey:@"indexLunchCount"];
    [userDefaule synchronize];
}
/*
 * 修改群聊房间lunch点击次数
 */
+ (void)upDataWithRoomLunchCount:(NSString *)roomLunchCount{
    
    NSUserDefaults *userDefaule = [NSUserDefaults standardUserDefaults];
    [userDefaule setObject:roomLunchCount forKey:@"roomLunchCount"];
    [userDefaule synchronize];
}
/*
 * 修改群聊房间下注lunch点击次数
 */
+ (void)upDataWithBetLunchCount:(NSString *)betLunchCount{
    
    NSUserDefaults *userDefaule = [NSUserDefaults standardUserDefaults];
    [userDefaule setObject:betLunchCount forKey:@"betLunchCount"];
    [userDefaule synchronize];
}

/*
 * 查询数据
 * username:用户名
 * password:密码
 * token   :服务器返回的token
 * nickname:昵称
 * islogin :登录状态（1==已登录，0==未登录）
 * type    :充值渠道
 * type    :环信登录ID
 * level   :等级
 * autograph:签名
 * userType:用户类型1：普通用户，4：代理用户
 * aboutUrl:个人中心关于地址
 */
+ (NSMutableDictionary *)searchData
{
    
    NSMutableDictionary *userDic = [NSMutableDictionary new];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *username = [userDefaults objectForKey:@"loginName"];
    NSString *password = [userDefaults objectForKey:@"password"];
    NSString *nickname = [userDefaults objectForKey:@"nickname"];
    NSString *islogin  = [userDefaults objectForKey:@"islogin"];
    NSString *token    = [userDefaults objectForKey:@"token"];
    NSString *moneyNum = [userDefaults objectForKey:@"moneyNum"];
    NSString *userID   = [userDefaults objectForKey:@"userID"];
    NSString *level    = [userDefaults objectForKey:@"level"];
    NSString *autograph = [userDefaults objectForKey:@"autograph"];
    NSString *userType = [userDefaults objectForKey:@"userType"];
    NSString *aboutUrl = [userDefaults objectForKey:@"aboutUrl"];
    NSString *indexLunchCount = [userDefaults objectForKey:@"indexLunchCount"];
    NSString *roomLunchCount = [userDefaults objectForKey:@"roomLunchCount"];
    NSString *betLunchCount = [userDefaults objectForKey:@"betLunchCount"];
    NSString *noticeAlertCount = [userDefaults objectForKey:@"noticeAlertCount"];
    
    if (username!=nil && password!=nil && nickname!=nil && islogin!=nil && token!=nil && moneyNum!=nil && userID!=nil && level!=nil&&autograph!=nil &&userType!=nil &&aboutUrl!=nil && indexLunchCount!=nil && roomLunchCount!=nil && betLunchCount!=nil && noticeAlertCount!=nil) {
        
        userDic = @{@"loginName":username,
                    @"password":password,
                    @"nickname":nickname,
                    @"islogin":islogin,
                    @"token":token,
                    @"moneyNum":moneyNum,
                    @"userID":userID,
                    @"level":level,
                    @"autograph":autograph,
                    @"userType":userType,
                    @"aboutUrl":aboutUrl,
                    @"indexLunchCount":indexLunchCount,
                    @"roomLunchCount":roomLunchCount,
                    @"betLunchCount":betLunchCount,
                    @"noticeAlertCount":noticeAlertCount
                    }.mutableCopy;
    }
     return userDic;

}
/*
 * 删除数据
 * username:用户名
 * password:密码
 * token   :服务器返回的token
 * nickname:昵称
 * islogin :登录状态（1==已登录，0==未登录）
 * type    :充值渠道
 * type    :环信登录ID
 * level   :等级
 * userType:用户类型1：普通用户，4：代理用户
 * aboutUrl:个人中心关于地址
 */
+ (void)deleateData
{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"loginName"];
    [userDefaults removeObjectForKey:@"password"];
    [userDefaults removeObjectForKey:@"token"];
    [userDefaults removeObjectForKey:@"nickname"];
    [userDefaults removeObjectForKey:@"islogin"];
    [userDefaults removeObjectForKey:@"moneyNum"];
    [userDefaults removeObjectForKey:@"userID"];
    [userDefaults removeObjectForKey:@"level"];
    [userDefaults removeObjectForKey:@"autograph"];
    [userDefaults removeObjectForKey:@"userType"];
    [userDefaults removeObjectForKey:@"aboutUrl"];
    [userDefaults removeObjectForKey:@"indexLunchCount"];
    [userDefaults removeObjectForKey:@"roomLunchCount"];
    [userDefaults removeObjectForKey:@"betLunchCount"];
    [userDefaults removeObjectForKey:@"noticeAlertCount"];
    [userDefaults synchronize];


}


@end
