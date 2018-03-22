//
//  UserDefaults.m
//  PCdd
//
//  Created by mading shouyou on 2017/11/2.
//  Copyright © 2017年 mading shouyou. All rights reserved.
//

#import "UserDefaults.h"

@implementation UserDefaults


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
    [userDefault synchronize];
    NSLog(@"username:%@--password:%@--token:%@--nickname:%@--islogin%@--moneyNum:%@--userID%@--level%@--autograph:%@",username,password,token,nickname,islogin,moneyNum,userID,level,autograph);
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
    
    if (username!=nil && password!=nil && nickname!=nil && islogin!=nil && token!=nil && moneyNum!=nil && userID!=nil && level!=nil&&autograph!=nil) {
        
        userDic = @{@"loginName":username,
                    @"password":password,
                    @"nickname":nickname,
                    @"islogin":islogin,
                    @"token":token,
                    @"moneyNum":moneyNum,
                    @"userID":userID,
                    @"level":level,
                    @"autograph":autograph
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
    [userDefaults synchronize];


}


@end
