//
//  UserDefaults.h
//  PCdd
//
//  Created by mading shouyou on 2017/11/2.
//  Copyright © 2017年 mading shouyou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefaults : NSObject


///*
// * 存储应用第一次启动(首次启动添加公告弹窗)
// */
//+ (void)addLunchCount;
//
///*
// * 点击公告确认修改次数
// */
//+ (void)changeLunchCount;
//
//
///*
// * 删除启动次数
// */
//+ (void)deleateLunchCount;

/*
 * 添加用户信息数据
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
/*
 * 修改用户类型
 */
+ (void)upDataWithUserType:(NSString *)userType;
/*
 * 修改关于页面地址
 */
+ (void)upDataWithAboutUrl:(NSString *)aboutUrl;
/*
 * 修改首页lunch点击次数
 */
+ (void)upDataWithIndexLunchCount:(NSString *)indexLunchCount;
/*
 * 修改群聊房间lunch点击次数
 */
+ (void)upDataWithRoomLunchCount:(NSString *)roomLunchCount;
/*
 * 修改群聊房间下注lunch点击次数
 */
+ (void)upDataWithBetLunchCount:(NSString *)betLunchCount;
/*
 * 修改公告弹窗点击状态
 */
+ (void)changeLunchCountWithCount:(NSString *)count;

@end
