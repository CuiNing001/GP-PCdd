//
//  AFNetManager.h
//  PCdd
//
//  Created by mading shouyou on 2017/10/31.
//  Copyright © 2017年 mading shouyou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@interface AFNetManager : NSObject

// GET请求
+ (void)requestGETWithURLStr:(NSString *)urlStr paramDic:(NSDictionary *)paramDic finish:(void (^)(id responserObject))finish enError:(void (^)(NSError *error))enError;

// POST请求
+ (void)requestPOSTWithURLStr:(NSString *)urlStr paramDic:(NSDictionary *)paramDic token:(NSString *)token finish:(void(^)(id responserObject))finish enError:(void(^)(NSError *error))enError;

@end
