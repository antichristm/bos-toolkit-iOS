////  BOSImportManager.m
//  BOS
//
//  Created by BOS on 2018/12/21.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import "BOSImportManager.h"
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
@implementation BOSImportManager
+(void)importWithType:(BOSImportType)type info:(NSDictionary *)info locPass:(NSString *)password completion:(void(^)(NSDictionary * info))completion{
    @try {
        if (!info) {
            NSDictionary * info = @{@"code" : @"10001"};
            if (completion) {
                completion(info);
            }
        }
        switch (type) {
            case 0:{
                NSString * enPrivate = info[@"content"];
                NSString * keyStorePass = info[@"password"];
                enPrivate = [enPrivate stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                keyStorePass = [keyStorePass stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                if (!enPrivate || enPrivate.length == 0) {
                    NSDictionary * info = @{@"code" : @"10001"};
                    if (completion) {
                        completion(info);
                    }
                    return;
                }
                
                if (!keyStorePass  || keyStorePass.length == 0) {
                    NSDictionary * info = @{@"code" : @"10001"};
                    if (completion) {
                        completion(info);
                    }
                    return;
                }
                
                NSString * private = [[EOSTools shared]DecryptKeystoreWith:enPrivate password:keyStorePass];
                if (private && private.length > 0) {
                    [BOSImportManager importPrivate:private password:password completion:completion];
                }else{
                    NSDictionary * info = @{@"code" : @"10005"};
                    if (completion) {
                        completion(info);
                    }
                    return;
                }
            }
                
                break;
                
            case 1:{
                NSString * private = info[@"content"];
                if (!private) {
                    NSDictionary * info = @{@"code" : @"10001"};
                    if (completion) {
                        completion(info);
                    }
                    return;
                }
                [BOSImportManager importPrivate:private password:password completion:completion];
            }
                
                break;
                
            default:
                break;
        }
    } @catch (NSException *exception) {
        NSDictionary * info = @{@"code" : @"10002"};
        if (completion) {
            completion(info);
        }
    } @finally {}
}
+(void)importPrivate:(NSString *)private password:(NSString *)password completion:(void(^)(NSDictionary * info))completion{
    private = [private stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    private = [private stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    private = [private stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSString * publick = [[EOSTools shared]getAddress:private];
    if (!publick) {
        NSDictionary * info = @{@"code" : @"10007"};
        if (completion) {
            completion(info);
        }
        return;
    }
    NSDictionary * param = @{@"public_key":publick?:@""};
    
    EOS_API_get_key_accounts(param, ^(id  _Nonnull responseObject) {
        NSArray * accounts = responseObject[@"account_names"];
        
        if (accounts.count == 0) {
            NSDictionary * info = @{@"code" : @"10003"};
            if (completion) {
                completion(info);
            }
            return;
            
        }else{
            [BOSImportManager addAccountsWithPrivate:private password:password accounts:accounts completion:completion];
        }
    }, ^(id  _Nonnull failure, id  _Nonnull message) {
        NSDictionary * info = @{@"code" : @"10006" , @"data" : failure};
        if (completion) {
            completion(info);
        }
    });
}

+(void)addAccountsWithPrivate:(NSString *)private password:(NSString *)password accounts:(NSArray <NSString *> *)accounts completion:(void(^)(NSDictionary * info))completion{
    
    NSString * publick = [[EOSTools shared]getAddress:private];
    dispatch_semaphore_t  semaphore = dispatch_semaphore_create(0);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    NSMutableArray * results = [NSMutableArray arrayWithCapacity:accounts.count];
    for (NSString * account in accounts) {
        EOS_API_get_account(@{@"account_name" : account}, ^(id  _Nonnull responseObject) {
            
            EOSAccountModel * accountModel = [EOSAccountModel initModelWithObject:responseObject];
            NSArray * locAccounts = [[BOSWCDBManager sharedManager]BOSSelectAccountWhereAccountName:account];
            NSArray * permissionInfos = [accountModel verificationKeyWithPublic:publick];
            NSMutableArray * permissions = [NSMutableArray arrayWithCapacity:permissionInfos.count];
            for (NSDictionary * permissionInfo in permissionInfos) {
                NSString * permission = permissionInfo[@"perm_name"];
                [permissions addObject:permission];
            }
            if (locAccounts.count) {
                //本地有账户
                AccountListModel * locModel = locAccounts.firstObject;
                NSMutableArray * nullPermissions = [NSMutableArray array];
                for (NSString * permission in permissions) {
                    if (![locModel verificationKeyWithPublic:publick permission:permission]) {
                        [nullPermissions addObject:permission];
                    }
                }
                
                if (nullPermissions.count > 0) {
                    // 本地有此账户但没这些key - 添加key
                    [BOSImportManager addAccountPermissionWithAccount:locAccounts.firstObject private:private password:password permissions:nullPermissions completion:^(NSDictionary *info) {
                        [results addObject:info];
                        dispatch_semaphore_signal(semaphore);
                    }];
                }else{
                    //本地账户已有该权限
                    NSDictionary * info =  @{@"code" : @"10004"};
                    [results addObject:info];
                    dispatch_semaphore_signal(semaphore);
                }
            }else{
                //本地无此账户 - 添加账户
                [BOSImportManager insertAccountWithPrivate:private  accountName:account password:password permissions:permissions  completion:^(NSDictionary *info) {
                    [results addObject:info];
                    dispatch_semaphore_signal(semaphore);
                }];
            }
        }, ^(id  _Nonnull failure, id  _Nonnull message) {
            NSDictionary * info = @{@"code" : @"10006" , @"data" : failure};
            [results addObject:info];
            dispatch_semaphore_signal(semaphore);
        });
    }
    
    dispatch_group_notify(group, queue, ^{
        for(NSInteger index = 0; index < accounts.count; index++) {
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [XWHUDManager hide];
            if (results.count == 0) {
                NSDictionary * info = @{@"code" : @"10000"};
                if (completion) {
                    completion(info);
                }
            }else{
                NSLog(@"%@",results);
                NSDictionary * info = results.firstObject;
                if (completion) {
                    completion(info);
                }
            }
            NSLog(@"成功");
        });
    });
    
}
/**
 添加账户
 
 @param private 私钥
 @param accountName 账户名
 @param permissions 私钥对应权限数组
 @param completion 回调
 */
+(void)insertAccountWithPrivate:(NSString * __nonnull)private accountName:(NSString * __nonnull)accountName  password:(NSString *)password permissions:(NSArray <NSString *>*)permissions completion:(void(^)(NSDictionary * info))completion{
    @try {
        if (![PassWordTool verifyPassword:password]) {
            NSDictionary * info = @{@"code" : @"10005"};
            if (completion) {
                completion(info);
            }
            return;
        }
        NSString * publick = [[EOSTools shared]getAddress:private];
        NSString * enPrivate = [[EOSTools shared]EncryptWith:private password:password];
        NSMutableDictionary * keys = [NSMutableDictionary dictionary];
        for (NSString * permission in permissions) {
            NSString * key = [NSString stringWithFormat:@"%@_%@",publick,permission];
            NSDictionary * keyInfo = @{
                                       @"permission" : permission,
                                       @"private" : enPrivate
                                       };
            
            [keys setObject:keyInfo forKey:key];
        }
        NSString * keysString = [BOSTools jsonStringFromDictionary:keys];
        NSDictionary * dict = @{
                                @"keys":keysString,
                                @"accountName" : accountName,
                                @"creatTimestamp" : [BOSTools getNowTimeTimestamp]
                                };
        AccountListModel * model = [AccountListModel initModelWithObject:dict];
        BOOL result = [[BOSWCDBManager sharedManager]BOSInsertObjectToTable:BOSDBAccountTableName model:model];
        if (result) {
            NSDictionary * info = @{@"code" : @"10000"};
            if (completion) {
                completion(info);
            }
        }else{
            NSDictionary * info = @{@"code" : @"11000"};
            if (completion) {
                completion(info);
            }
        }
    } @catch (NSException *exception) {
        NSLog(@"--->%@",exception);
    } @finally {}
}
+(void)addAccountPermissionWithAccount:(AccountListModel *)model private:(NSString * __nonnull)private password:(NSString *)password permissions:(NSArray <NSString *>*)permissions completion:(void(^)(NSDictionary * info))completion{
    
    @try {
        if (![PassWordTool verifyPassword:password]) {
            NSDictionary * info = @{@"code" : @"10005"};
            if (completion) {
                completion(info);
            }
            return;
        }
        NSString * publick = [[EOSTools shared]getAddress:private];
        NSString * enPrivate = [[EOSTools shared]EncryptWith:private password:password];
        NSMutableDictionary * originKeys = [model.keys.mj_JSONObject mutableCopy];
        
        for (NSString * permission in permissions) {
            NSString * key = [NSString stringWithFormat:@"%@_%@",publick,permission];
            NSDictionary * keyInfo = @{
                                       @"permission" : permission,
                                       @"private" : enPrivate
                                       };
            
            [originKeys setObject:keyInfo forKey:key];
        }
        NSString * keysString = originKeys.mj_JSONString;
        model.keys = keysString;
        
        BOOL result = [[BOSWCDBManager sharedManager]BOSUpdateAccountWithModel:model];
        if (result) {
            NSDictionary * info = @{@"code" : @"10000"};
            if (completion) {
                completion(info);
            }
        }else{
            NSDictionary * info = @{@"code" : @"11000"};
            if (completion) {
                completion(info);
            }
        }
    } @catch (NSException *exception) {
        NSLog(@"添加权限失败--->%@",exception);
    } @finally {}
    
}
+(void)synchronizationFromCloudAccounts:(NSArray <AccountListModel *>*)accounts completion:(void(^)(NSDictionary * info))completion{
    @try {
        if (accounts.count == 0) {
            NSDictionary * info = @{@"code" : @"10000"};
            if (completion) {
                completion(info);
            }
            return;
        }
        NSMutableArray * updates = [NSMutableArray arrayWithCapacity:accounts.count];
        for (AccountListModel * selectModel in accounts) {
            AccountListModel * locAccount = [[BOSWCDBManager sharedManager]BOSSelectAccountWhereAccountName:selectModel.accountName].firstObject;
            if (locAccount) {
                NSDictionary * cloudKeys = selectModel.keys.mj_JSONObject;
                NSMutableDictionary * locKeys = [locAccount.keys.mj_JSONObject mutableCopy];
                [locKeys addEntriesFromDictionary:cloudKeys];
                locAccount.keys = locKeys.mj_JSONString;
                [updates addObject:locAccount];
            }else{
                [updates addObject:selectModel];
            }
            selectModel.cloudBackups = NSLocalizedString(@"已备份", nil);
            selectModel.locExsit = NSLocalizedString(@"已导入", nil);
        }
        
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_group_t group = dispatch_group_create();
        
        //遍历要更新的账户
        for (AccountListModel * account in updates) {
            NSDictionary * param = @{
                                     @"account_name" : account.accountName
                                     };
            //查询账户信息
            EOS_API_get_account(param, ^(id  _Nonnull responseObject) {
                EOSAccountModel * accountModel = [EOSAccountModel initModelWithObject:responseObject];
                NSMutableDictionary * keys = [account.keys.mj_JSONObject mutableCopy];
                NSMutableDictionary * newKeys = [NSMutableDictionary dictionary];
                //遍历账户的keys
                for (NSString * key in keys.allKeys) {
                    //查询当前公钥对应的权限
                    NSDictionary * keyInfo = keys[key];
                    NSString * enPri = keyInfo[@"private"];
                    NSString * oldPer = keyInfo[@"permission"];
                    NSString * k = [key componentsSeparatedByString:@"_"].firstObject;
                    NSArray * pers =  [accountModel verificationKeyWithPublic:k];
                    NSArray * perNames = [pers valueForKey:@"perm_name"];
                    if (pers.count == 0) {
                        NSString * pub_per = [NSString stringWithFormat:@"%@_%@",k,NSLocalizedString(@"无效权限", nil)];
                        NSMutableDictionary * infoItem = [NSMutableDictionary dictionary];
                        [infoItem setObject:enPri forKey:@"private"];
                        [infoItem setObject:oldPer forKey:@"permission"];
                        [newKeys setObject:infoItem forKey:pub_per];
                    }else{
                        for (NSString * per in perNames) {
                            NSMutableDictionary * infoItem = [NSMutableDictionary dictionary];
                            NSString * pub_per = [NSString stringWithFormat:@"%@_%@",k,per];
                            [infoItem setObject:enPri forKey:@"private"];
                            [infoItem setObject:per forKey:@"permission"];
                            [newKeys setObject:infoItem forKey:pub_per];
                        }
                    }
                }
                account.keys = newKeys.mj_JSONString;
                dispatch_semaphore_signal(semaphore);
            }, ^(id  _Nonnull failure, id  _Nonnull message) {
                dispatch_semaphore_signal(semaphore);
            });
        }
        dispatch_group_notify(group, queue, ^{
            for(NSInteger index = 0; index < updates.count; index++) {
                dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            }
            
            BOOL result = [[BOSWCDBManager sharedManager]BOSUpdateAccounts:updates];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSDictionary * info;
                if (result) {
                    info   = @{@"code" : @"10000"};
                }else{
                    info = @{@"code" : @"11000"};
                }
                if (completion) {
                    completion(info);
                }
            });
        });
        
    } @catch (NSException *exception) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary * info = @{@"code" : @"11000"};
            if (completion) {
                completion(info);
            }
        });
    } @finally {}
}
+(void)showFailMessage:(NSInteger)code message:(NSString *)message{
    /**
     code
     10000 ： 成功
     10001 : 参数为空
     10002 : 参数不全
     10003 : 账户不存在
     10004 : 已经导入
     10005 : 密码错误
     10006 : 网络错误
     11000 : 未知错误
     */
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (code) {
            case 10000:{
                [XWHUDManager showTipHUD:message?:NSLocalizedString(@"导入成功", nil)];
            }
                
                break;
                
            case 10001:
                [XWHUDManager showTipHUD:message?:NSLocalizedString(@"参数为空", nil)];
                break;
                
            case 10002:{
                [XWHUDManager showTipHUD:message?:NSLocalizedString(@"参数不全", nil)];
            }
                
                
                break;
                
            case 10003:{
                [XWHUDManager showTipHUD:message?:NSLocalizedString(@"账户不存在", nil)];
            }
                
                break;
                
            case 10004:{
                [XWHUDManager showTipHUD:message?:NSLocalizedString(@"已经导入", nil)];
            }
                
                break;
                
            case 10005:{
                [XWHUDManager showTipHUD:message?:NSLocalizedString(@"密码错误", nil)];
            }
                
                break;
                
            case 10006:{
                [XWHUDManager showTipHUD:message?:NSLocalizedString(@"网络错误", nil)];
            }
                
                break;
                
            case 10007:{
                [XWHUDManager showTipHUD:message?:NSLocalizedString(@"无效的key", nil)];
            }
                
                break;
                
            case 11000:{
                [XWHUDManager showTipHUD:message?:NSLocalizedString(@"未知错误", nil)];
            }
                
                break;
                
            default:{
                [XWHUDManager showTipHUD:message?:NSLocalizedString(@"未知错误", nil)];
            }
                break;
        }
    });
}
@end
