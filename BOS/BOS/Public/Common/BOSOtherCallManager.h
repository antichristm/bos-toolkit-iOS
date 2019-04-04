////  BOSOtherCallManager.h
//  BOS
//
//  Created by BOS on 2019/1/7.
//  Copyright © 2019年 BOS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/**
 code
 10000 ： 成功
 10001 : scheme错误
 10002 : 参数格式错误
 */
@interface BOSOtherCallManager : NSObject

/**
 参数格式化

 @param url 原始url
 @param completion 回调
 */
+(void)paramFormat:(NSURL *)url completion:(void(^)(NSDictionary * result))completion;

/**
 事件处理

 @param param 格式化后的参数
 @param handler 处理者
 */
+(void)dispenseIncidentWith:(NSDictionary * __nonnull)param handler:(id)handler completion:(void(^)(BOOL  result))completion;

/**
 回调第三方

 @param param 回传参数
 @param scheme 第三方scheme
 @param completion 结果回调
 */
+(void)exportToAppWith:(NSDictionary * __nullable)param scheme:(NSString *)scheme completion:( void(^ _Nullable )(BOOL result) )completion;


+(void)openUrl:(NSURL *)url completion:(void(^)(BOOL result))completion;
@end

NS_ASSUME_NONNULL_END
