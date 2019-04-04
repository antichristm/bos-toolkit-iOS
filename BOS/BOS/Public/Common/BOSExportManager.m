////  BOSExportManager.m
//  BOS
//
//  Created by BOS on 2018/12/27.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import "BOSExportManager.h"

@implementation BOSExportManager
+(void)selectKeys:(AccountListModel * )account title:(NSString * __nonnull)title limit:(NSString *)limit exist:(BOOL)exist completion:(void(^)(NSString * enPri))completion{
    @try {
        NSDictionary * keys = account.keys.mj_JSONObject;
        NSMutableArray * disposeKeys = keys.allKeys.mutableCopy;
        if (limit && limit.length > 0) {
            [disposeKeys enumerateObjectsUsingBlock:^(NSString *  _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
                if (exist) {
                    if (![key hasSuffix:limit]){
                        [disposeKeys removeObject:key];
                    }
                }else{
                    if ([key hasSuffix:limit]){
                        [disposeKeys removeObject:key];
                    }
                }
            }];
        }
        if (disposeKeys.count == 0) {
            if (completion) {
                completion(nil);
            }
            return;
        }
        [BOSExportManager selectKeys:disposeKeys title:title callback:^(NSInteger index) {
            NSString * key = disposeKeys[index];
            NSDictionary * info = keys[key];
            NSString * enPri = info[@"private"];
            if (completion) {
                completion(enPri);
            }
        }];
    } @catch (NSException *exception) {
        if (completion) {
            completion(nil);
        }
    } @finally {}
}
+(void)selectKeys:(NSArray<NSString *> * )accounts title:(NSString * __nonnull)title callback:(void(^)(NSInteger  index))callback{
    for (UIView * view in KeyWindow.subviews) {
        if ([view isKindOfClass:AccountKeyListAlertView.class]) {
            [view removeFromSuperview];
        }
    }
    AccountKeyListAlertView * alert = [[AccountKeyListAlertView alloc]init];
    alert.titleString = title;
    alert.dataArr = accounts;
    [alert showView];
    [alert setBlock:^(NSArray * _Nonnull selectArray) {
        NSString * index = selectArray.firstObject;
        if (callback) {
            callback(index.integerValue);
        }
    }];
}
+(void)verifyPassword:(NSString * )enPrivate completion:(void(^)(BOOL result,NSString * password,NSString * dePrivate))completion{
    PassWorldView * view = [[PassWorldView alloc]init];
    view.title = NSLocalizedString(@"账户密码", nil);
    [view showView];
    [view setPasswordBlock:^(NSString * _Nonnull password) {
        NSString * private = [[EOSTools shared]DecryptWith:enPrivate password:password];
        BOOL ver = [PassWordTool verifyPassword:password];
        BOOL result = NO;
        if (ver && private && private.length > 0) {
            result = YES;
        }else{
            result = NO;
        }
        if (completion) {
            completion(result,password,private);
        }
    }];
}
+(void)exportToAppWithAccount:(AccountListModel *)account appInfo:(NSDictionary *)appInfo completion:(void(^)(BOOL result))completion{
    NSString * appName = appInfo[@"appName"];
    NSString * hint = [NSString stringWithFormat:NSLocalizedString(@"%@请求", nil),appName?:NSLocalizedString(@"未知", nil)];
    [BOSExportManager selectKeys:account title:hint limit:BOS_ACTIVE_KEY exist:YES completion:^(NSString * _Nonnull enPri) {
        PassWorldView * alert = [[PassWorldView alloc]init];
        alert.title = NSLocalizedString(@"账户密码", nil);
        [alert showView];
        [alert setPasswordBlock:^(NSString * _Nonnull password) {
            @try {
                NSString * private = [[EOSTools shared]DecryptWith:enPri password:password];
                if (private.length > 0 && private && [PassWordTool verifyPassword:password]) {
                    NSString * scheme = appInfo[@"callback"];
                    NSString * action = appInfo[@"action"];
                    
                    NSAssert(scheme, NSLocalizedString(@"scheme为空", nil));
                    NSAssert(action, NSLocalizedString(@"action为空", nil));
                    
                    NSDictionary * param = @{
                                             @"action" : action,
                                             @"data" : @[
                                                     @{
                                                         @"account_name" : account.accountName,
                                                         @"keys" : @[private],
                                                         @"type" : @"BOS"
                                                         }
                                                     ]
                                             };
                    [BOSOtherCallManager exportToAppWith:param scheme:scheme completion:completion];
                }else{
                    [XWHUDManager showErrorTipHUD:NSLocalizedString(@"密码错误", nil)];
                    if (completion) {
                        completion(NO);
                    }
                }
            } @catch (NSException *exception) {
                NSLog(@"error-->%@",exception);
                if (completion) {
                    completion(YES);
                }
            } @finally {}
        }];
    }];
}
@end
