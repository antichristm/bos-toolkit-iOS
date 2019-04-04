////  PassWordTool.h
//  BOS
//
//  Created by BOS on 2018/12/17.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PassWordTool : NSObject

/**
 保存密码

 @param password 密码
 @return 结果
 */
+(BOOL)savePassWord:(NSString *)password;

/**
 获取密码

 @return 结果
 */
+(NSString *)readPassWord;

/**
 删除密码

 @return 结果
 */
+(BOOL)deletePassWord;

/**
 保存密保问题

 @param question 问题
 @return 结果
 */
+(BOOL)saveSecuritQuestion:(NSString *)question;

/**
 读取密保问题

 @return 问题
 */
+(NSString *)readSecuritQuestion;

/**
 删除密保问题

 @return 结果
 */
+(BOOL)deleteSecuritQuestion;


/**
 保存验证字符

 @param verify 验证字符
 @return 结果
 */
+(BOOL)saveSecuritVerify:(NSString *)verify;

/**
 读取验证字符

 @return 字符
 */
+(NSString *)readSecuritVerify;

/**
 删除验证字符

 @return 结果
 */
+(BOOL)deleteSecuritVerify;


/**
 检验密码h正确性

 @param password 密码
 @return 结果
 */
+(BOOL)verifyPassword:(NSString *)password;

/**
 是否存在密码和密保问题

 @return 结果
 */
+(BOOL)isExist;
@end

NS_ASSUME_NONNULL_END
