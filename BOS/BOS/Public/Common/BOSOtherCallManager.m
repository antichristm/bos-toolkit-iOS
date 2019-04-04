////  BOSOtherCallManager.m
//  BOS
//
//  Created by BOS on 2019/1/7.
//  Copyright © 2019年 BOS. All rights reserved.
//

#import "BOSOtherCallManager.h"
#define BOSOtherGetAccount @"getAccount"
#define BOSScheme @"bostoolkit"
#define BOSPrefix @"bostoolkit?param="
/**
 code
 10000 ： 成功
 10001 : scheme错误
 10002 : 参数格式错误
 */
@implementation BOSOtherCallManager
+(void)paramFormat:(NSURL *)url completion:(void(^)(NSDictionary * result))completion{
    NSDictionary * result;
    if (![url.scheme isEqualToString:BOSScheme]) {
        result = @{
                   @"code" : @"10001",
                   @"message" : NSLocalizedString(@"scheme错误", nil)
                   };
        if (completion) {
            completion(result);
        }
        return;
    }
    
    if (![url.absoluteString hasPrefix:BOSCallFormat]) {
        result = @{
                   @"code" : @"10002",
                   @"message" : NSLocalizedString(@"参数格式错误", nil)
                   };
        if (completion) {
            completion(result);
        }
        return;
    }
    
    NSString * paramString = [[url.absoluteString componentsSeparatedByString:BOSCallFormat].lastObject stringByRemovingPercentEncoding];
    NSDictionary * param = paramString.mj_JSONObject;
    if (!param) {
        result = @{
                   @"code" : @"10002",
                   @"message" : NSLocalizedString(@"参数格式错误", nil)
                   };
        if (completion) {
            completion(result);
        }
        return;
    }
    
    result = @{
               @"code" : @"10000",
               @"result" : param
               };
    if (completion) {
        completion(result);
    }
}
+(void)dispenseIncidentWith:(NSDictionary * __nonnull)param handler:(id)handler completion:(void(^)(BOOL  result))completion{
    @try {
        NSString * action = param[@"action"];
        if ([action isEqualToString:BOSOtherGetAccount]) {
            UIViewController * vc = (UIViewController *)handler;
            ThirdAppPullViewController * third = [[ThirdAppPullViewController alloc]init];
            third.param = param;
            [vc presentViewController:third animated:YES completion:nil];
            
            if (completion) {
                completion(YES);
            }
        }else{
            if (completion) {
                completion(NO);
            }
        }
    } @catch (NSException *exception) {
        if (completion) {
            completion(NO);
        }
    } @finally {}
}
+(void)exportToAppWith:(NSDictionary *)param scheme:(NSString *)scheme completion:(void(^)(BOOL result))completion{
    
    if (!scheme) {
        if (completion) {
            completion(NO);
        }
        return;
    }
    NSData * base58Data = [param.mj_JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSString * result = [NSString stringWithFormat:@"%@%@%@",scheme,BOSPrefix,base58Data.base58String];
    result = [result stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    result = [result stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSURL * url = [NSURL URLWithString:result];
    [BOSOtherCallManager openUrl:url completion:completion];
}
+(void)openUrl:(NSURL *)url completion:(void(^)(BOOL result))completion{
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication]openURL:url options:@{} completionHandler:completion];
    } else {
        if (completion) {
            completion([[UIApplication sharedApplication] openURL:url]);
        }
    }
}
@end
