//
//  UserDefaults.h
//  PCdd
//
//  Created by mading shouyou on 2017/11/2.
//  Copyright © 2017年 mading shouyou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefaults : NSObject

/* ^^^^^^用户消息读取状态^^^^^^ */

/*
 * @param:idArray:存储noticeMsg读取状态
 */
+ (void)addNoticeStautsWithidArray:(NSMutableArray *)idArray;

/*
 * 获取noticeMsg读取状态
 */
+ (NSMutableArray *)searchNoticeStauts;

/*
 * 修改idArray
 */
+ (void)upDataNoticeStautsWithMsgId:(NSString *)msgId;

/*
 * 删除未读消息读取状态
 */
+ (void)deleateNoticeStauts;


/* ^^^^^^用户基础信息^^^^^^ */

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

/*
 * 查询用户名
 */
+ (NSString *)searchLoginName;

@end
