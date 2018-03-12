//
//  RegexPattern.m
//  PCdd
//
//  Created by mading shouyou on 2017/11/2.
//  Copyright © 2017年 mading shouyou. All rights reserved.
//

#import "RegexPattern.h"

@implementation RegexPattern

/*
 * return > 0 格式正确
 * return = 0 格式错误
 */

/*
 * 用户名：数字或英文字母4-20个字符
 */
+ (BOOL) validateUserName:(NSString *)name
{
    NSString        *userNameRegex = @"[A-Za-z0-9]{4,20}";
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];
    BOOL B = [userNamePredicate evaluateWithObject:name];
    return B;
}

/*
 * 昵称：4-10个字符以内
 */
+ (BOOL) validateNickname:(NSString *)nickname
{
    NSString        *nicknameRegex = @"^.{4,10}$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nicknameRegex];
    return [passWordPredicate evaluateWithObject:nickname];
}


/*
 * 密码：6-20个字符以内
 */
+ (BOOL) validatePassword:(NSString *)passWord
{
    NSString        *passWordRegex = @"^.{6,20}$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:passWord];
}





@end
