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
 */
+ (void)addDataWithUsername:(NSString *)username
                   password:(NSString *)password
                      token:(NSString *)token
                   nickname:(NSString *)nickname
                    islogin:(NSString *)islogin
                       type:(NSString *)type
                       xhID:(NSString *)xhID
                      level:(NSString *)level
{

    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:username forKey:@"loginName"];
    [userDefault setObject:password forKey:@"password"];
    [userDefault setObject:token    forKey:@"token"];
    [userDefault setObject:nickname forKey:@"nickname"];
    [userDefault setObject:islogin  forKey:@"islogin"];
    [userDefault setObject:type     forKey:@"type"];
    [userDefault setObject:xhID     forKey:@"xhID"];
    [userDefault setObject:level    forKey:@"level"];
    [userDefault synchronize];
    NSLog(@"username:%@--password:%@--token:%@--nickname:%@--islogin%@--type:%@--hxID%@--level%@",username,password,token,nickname,islogin,type,xhID,level);
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
    NSString *type     = [userDefaults objectForKey:@"type"];
    NSString *xhID     = [userDefaults objectForKey:@"xhID"];
    NSString *level    = [userDefaults objectForKey:@"level"];
    
    if (username!=nil && password!=nil && nickname!=nil && islogin!=nil && token!=nil && type!=nil && xhID!=nil && level!=nil) {
        userDic = @{@"loginName":username,
                    @"password":password,
                    @"nickname":nickname,
                    @"islogin":islogin,
                    @"token":token,
                    @"type":type,
                    @"xhID":xhID,
                    @"level":level
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
    [userDefaults removeObjectForKey:@"type"];
    [userDefaults removeObjectForKey:@"xhID"];
    [userDefaults removeObjectForKey:@"level"];
    [userDefaults synchronize];


}


@end
