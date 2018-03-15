//
//  UserDefaults.h
//  PCdd
//
//  Created by mading shouyou on 2017/11/2.
//  Copyright © 2017年 mading shouyou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefaults : NSObject


/*
 * 添加数据
 */
+ (void)addDataWithUsername:(NSString *)username
                   password:(NSString *)password
                      token:(NSString *)token
                   nickname:(NSString *)nickname
                    islogin:(NSString *)islogin
                   moneyNum:(NSString *)moneyNum
                     userID:(NSString *)userID
                      level:(NSString *)level
                  autograph:(NSString *)autograph;
/*
 * 查询数据
 */
+ (NSMutableDictionary *)searchData;

/*
 * 删除数据
 */
+ (void)deleateData;
/*
 * 修改昵称
 */
+ (void)upDataWithNickname:(NSString *)nickname;
/*
 * 修改签名
 */
+ (void)upDataWithAutograph:(NSString *)autograph;
/*
 * 修改密码
 */
+ (void)upDataWithPassword:(NSString *)password;
/*
 * 修改等级
 */
+ (void)upDataWithLevel:(NSString *)level;

@end
