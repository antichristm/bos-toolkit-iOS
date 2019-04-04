////  BOSImportManager.h
//  BOS
//
//  Created by BOS on 2018/12/21.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, BOSImportType) {
    BOSImportTypeKeyStore,
    BOSImportTypePrivate
};

/**
 code
 10000 ： 成功
 10001 : 参数为空
 10002 : 参数不全
 10003 : 账户不存在
 10004 : 已经导入
 10005 : 密码错误
 10006 : 网络错误
 10007 : 无效的key
 11000 : 未知错误
 */

@interface BOSImportManager : NSObject

/**
 导入账户

 @param type 导入类型
 @param info 导入内容 @{@"content" : 内容 ，@"password" : 密码 （BOSImportTypeKeyStore类型需要）
 }
 @param locPass 本地密码
 @param completion 回调
 */
+(void)importWithType:(BOSImportType)type info:(NSDictionary *)info locPass:(NSString *)password completion:(void(^)(NSDictionary * info))completion;


/**
 获取到的云端数据同步到本地

 @param accounts 云端账户数组
@param completion 回调
 */
+(void)synchronizationFromCloudAccounts:(NSArray <AccountListModel *>*)accounts completion:(void(^)(NSDictionary * info))completion;
/**
 结果提示

 @param code 状态码
 @param message 展示信息  （默认有值可不传）
 */
+(void)showFailMessage:(NSInteger)code message:(NSString * _Nullable)message;

@end

NS_ASSUME_NONNULL_END
