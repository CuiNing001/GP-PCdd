//
//  RegexPattern.h
//  PCdd
//
//  Created by mading shouyou on 2017/11/2.
//  Copyright © 2017年 mading shouyou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegexPattern : NSObject

+ (BOOL) validateNickname:(NSString *)nickname;

+ (BOOL) validatePassword:(NSString *)passWord;

+ (BOOL) validateUserName:(NSString *)name;

@end
