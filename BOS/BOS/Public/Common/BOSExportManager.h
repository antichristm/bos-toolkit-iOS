////  BOSExportManager.h
//  BOS
//
//  Created by BOS on 2018/12/27.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BOSExportManager : NSObject

/**
 选择账户相应的key

 @param account 账户
 @param title 弹窗标题
 @param limit 筛选权限
 @param exist 是否保留筛选权限
 @param completion 回调为空表示没有可导出权限
 */
+(void)selectKeys:(AccountListModel * )account title:(NSString * __nonnull)title limit:(NSString * __nullable)limit exist:(BOOL)exist completion:(void(^)(NSString * enPri))completion;

/**
 验证密码

 @param enPrivate 加密私钥
 @param completion 回调
 */
+(void)verifyPassword:(NSString * )enPrivate completion:(void(^)(BOOL result,NSString * password,NSString * dePrivate))completion;

+(void)exportToAppWithAccount:(AccountListModel *)account appInfo:(NSDictionary *)appInfo completion:(void(^)(BOOL result))completion;

@end

NS_ASSUME_NONNULL_END
