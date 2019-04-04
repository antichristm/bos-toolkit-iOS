//
//  EOSTools.h
//  BOS
//
//  Created by 梁唐 on 2018/12/11.
//  Copyright © 2018 lingling. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EOSTools : NSObject


+ (instancetype)shared;
/**私钥 公钥*/
- (EOSKeyModel *)getEOSKey;

/**
 通过私钥获取地址

 @param wif 私钥
 @return 地址
 */
- (NSString *)getAddress:(NSString *)wif;

/**
 AES 加密

 @param content 加密内容
 @param password 密码
 @return 加密结果
 */
- (NSString *)EncryptWith:(NSString *)content password:(NSString *)password;

/**
 AES 解密
 
 @param content 解密内容
 @param password 密码
 @return 解密结果
 */
- (NSString *)DecryptWith:(NSString *)content password:(NSString *)password;
- (NSString *)EncryptKeystoreWith:(NSString *)content password:(NSString *)password;
- (NSString *)DecryptKeystoreWith:(NSString *)content password:(NSString *)password;

/**
 合约操作

 @param actions 方法数组
 @[
  @{
     @"code":@"eosio.token",
     @"action":@"deleteauth",
     @"args":@{
     @"account":@"eos",
     @"permission":@"11"
     }
 
 },
  @{
     @"code":@"eosio",
     @"action":@"deleteauth",
     @"args":@{
     @"account":@"eos",
     @"permission":@"1"
     }
 }
 ]
 
 @param actor 发起者
 @param permission 权限
 @param privateKey 私钥
 @param success 成功
 @param failure 失败
 */
- (void)eosActions:(NSArray *)actions actor:(NSString *)actor permission:(NSString *)permission privateKey:(NSString *)privateKey success:(void (^)(id responseObject))success failure:(void (^)(id failure, id message))failure;


- (NSString *)signedTransaction:(NSMutableData *)pack privateKey:(NSString *)pri_key;

@end

NS_ASSUME_NONNULL_END
