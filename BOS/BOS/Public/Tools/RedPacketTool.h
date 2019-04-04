////  RedPacketTool.h
//  BOS
//
//  Created by BOS on 2018/12/24.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, RedPacketType) {
    /**普通红包*/
    RedPacketTypeNormal = 1,
    /**随机红包*/
    RedPacketTypeRandom,
    /**建账号专用红包*/
    RedPacketTypeCreateAccount,
};
/**
 红包工具
 */
@interface RedPacketTool : NSObject


/**
 创建红包

 @param type 红包类型
 @param ID 红包ID
 @param count 红包个数
 @param pubKey 红包公钥
 @param greetings 红包祝福语
 @param selfName 当前账号名
 @param privateKey 当前私钥
 @param permission 当前权限
 @param amount 红包金额
 @param success 成功回调block
 @param failure 失败回调block
 */
+ (void)CreateRedPacketWithRedType:(RedPacketType)type ID:(NSString *)ID count:(int)count publicKey:(NSString *)pubKey greetings:(NSString *)greetings selfAccountName:(NSString *)selfName selfPrivateKey:(NSString *)privateKey currentPermission:(NSString *)permission amount:(NSString *)amount success:(void (^)(id responseObject))success failure:(void (^)(id failure, id message))failure;

+ (void)GetRedPacketWithRedID:(NSString *)redID redPacketPrivateKey:(NSString *)redPrivatekey receiver:(NSString *)receiver success:(void (^)(id responseObject))success failure:(void (^)(id failure, id message))failure;

+ (void)CreatAccountWithRedID:(NSString *)ID redPacketPriKey:(NSString *)redPrivatekey newAccountName:(NSString *)newAccountName accoountOwnerPublicKey:(NSString *)ownerKey accountActivePublicKey:(NSString *)activeKey success:(void (^)(id responseObject))success failure:(void (^)(id failure, id message))failure;

+ (void)createAccountFromTransferWithNewAccountName:(NSString *)newAccountName ownerPublicKey:(NSString *)ownerPublickey activePublicKey:(NSString *)activePublicKey selfAccountName:(NSString *)selfName selfPrivateKey:(NSString *)privateKey currentPermission:(NSString *)permission amount:(NSString *)amount success:(void (^)(id responseObject))success failure:(void (^)(id failure, id message))failure;

@end

NS_ASSUME_NONNULL_END
