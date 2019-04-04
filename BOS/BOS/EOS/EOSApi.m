//
//  EOSApi.m
//  BOS
//
//  Created by 梁唐 on 2018/12/11.
//  Copyright © 2018 lingling. All rights reserved.
//

#import "EOSApi.h"


@interface EOSApi ()
@property (nonatomic, strong) AFHTTPSessionManager *manager;
@property (nonatomic, strong) AFURLSessionManager *bodyManager;
@end

@implementation EOSApi

+ (instancetype)shared {
    static id __staticObject;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __staticObject = [EOSApi new];
    });
    return __staticObject;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.manager = [AFHTTPSessionManager manager];
        self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [self.manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        self.manager.requestSerializer.timeoutInterval = 30.f;
        [self.manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        NSURLSessionConfiguration * config  = [NSURLSessionConfiguration defaultSessionConfiguration];
        config.timeoutIntervalForRequest = 15.;
        self.bodyManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:config];
    }
    return self;
}

- (void)postWithIp:(NSString *)ip Path:(NSString *)path params:(id)params body:(id)body success:(void (^)(id responseObject))success failure:(void (^)(id failure, id message))failure {
    __weak typeof(self) weakSelf = self;
    
    NSString *URLString = [NSString stringWithFormat:@"%@%@", ip ,path];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:URLString parameters:params error:nil];
    request.timeoutInterval = 15.;
    // 设置body
    if (body) {
        [request setHTTPBody:[self objectToJsonStr:body]];
    }
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                 @"text/html",
                                                 @"text/json",
                                                 @"text/javascript",
                                                 @"text/plain",
                                                 nil];
    self.bodyManager.responseSerializer = responseSerializer;
    
    
    [[self.bodyManager dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            if (responseObject) {
                NSError *err;
                NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&err];
                
                if (err) {
                    NSLog(@"%@",err);
                    NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSASCIIStringEncoding];
                    NSDictionary *dict = [weakSelf dictionaryWithJsonString:string];
                    if (success) {
                        success([weakSelf processDictionaryIsNSNull:dict]);
                    }
                }else{
                    if (success) {
                        success([weakSelf processDictionaryIsNSNull:result]);
                    }
                }
            }
        } else {
            NSData * resultData = (NSData *)responseObject;
            if (resultData && resultData.length > 0) {
                NSError *err;
                NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&err];
                NSDictionary *dic = [weakSelf processDictionaryIsNSNull:result];
                NSLog(@"ip : %@", URLString);
                NSLog(@"postWithIp--->%@",dic);
                if (dic[@"error"]) {
                    NSString *message = dic[@"error"][@"code"];
                    if (failure) {
                        failure(dic,[EOSErrorManager errorWithErrorCode:message.integerValue]);
                    }
                } else {
                    if (failure) {
                        failure(dic,[EOSErrorManager errorWithErrorCode:0]);
                    }
                }
            }else{
                if (failure) {
                    failure(NSLocalizedString(@"请检查你的网络！", nil),[EOSErrorManager errorWithErrorCode:0]);
                }
            }
        }
    }] resume];
}

- (NSData *)objectToJsonStr:(id)object{
    NSData *data=[NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
}



- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

- (id)processDictionaryIsNSNull:(id)obj{
    const NSString *blank = @"";
    if ([obj isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *dt = [(NSMutableDictionary*)obj mutableCopy];
        for(NSString *key in [dt allKeys]) {
            id object = [dt objectForKey:key];
            if([object isKindOfClass:[NSNull class]]) {
                [dt setObject:blank
                       forKey:key];
            }
            else if ([object isKindOfClass:[NSString class]]){
                NSString *strobj = (NSString*)object;
                if ([strobj isEqualToString:@"<null>"]) {
                    [dt setObject:blank
                           forKey:key];
                }
            }
            else if ([object isKindOfClass:[NSArray class]]){
                NSArray *da = (NSArray*)object;
                da = [self processDictionaryIsNSNull:da];
                [dt setObject:da
                       forKey:key];
            }
            else if ([object isKindOfClass:[NSDictionary class]]){
                NSDictionary *ddc = (NSDictionary*)object;
                ddc = [self processDictionaryIsNSNull:object];
                [dt setObject:ddc forKey:key];
            }
        }
        return [dt copy];
    }
    else if ([obj isKindOfClass:[NSArray class]]){
        NSMutableArray *da = [(NSMutableArray*)obj mutableCopy];
        for (int i=0; i<[da count]; i++) {
            NSDictionary *dc = [obj objectAtIndex:i];
            dc = [self processDictionaryIsNSNull:dc];
            [da replaceObjectAtIndex:i withObject:dc];
        }
        return [da copy];
    }
    else{
        return obj;
    }
}

#pragma mark - CHAIN -
void EOS_API_get_info(success success, failure failure){
    [[EOSApi shared] postWithIp:EOSIP Path:@"/v1/chain/get_info" params:nil body:nil success:success failure:failure];
}

void EOS_API_get_block(id body, success success, failure failure){
    [[EOSApi shared] postWithIp:EOSIP Path:@"/v1/chain/get_block" params:nil body:body success:success failure:failure];
}

void EOS_API_get_block_header(id body, success success, failure failure){
    [[EOSApi shared] postWithIp:EOSIP Path:@"/v1/chain/get_block_header" params:nil body:body success:success failure:failure];
}

void EOS_API_get_account(id body, success success, failure failure){
    [[EOSApi shared] postWithIp:EOSIP Path:@"/v1/chain/get_account" params:nil body:body success:success failure:failure];
}


void EOS_API_get_abi(id body, success success, failure failure){
    [[EOSApi shared] postWithIp:EOSIP Path:@"/v1/chain/get_abi" params:nil body:body success:success failure:failure];
}

void EOS_API_get_code(id body, success success, failure failure){
    [[EOSApi shared] postWithIp:EOSIP Path:@"/v1/chain/get_code" params:nil body:body success:success failure:failure];
}

void EOS_API_get_table_rows(id body, success success, failure failure){
    [[EOSApi shared] postWithIp:EOSIP Path:@"/v1/chain/get_table_rows" params:nil body:body success:success failure:failure];
}

void EOS_API_get_currency_balance(id body, success success, failure failure){
    [[EOSApi shared] postWithIp:EOSIP Path:@"/v1/chain/get_currency_balance" params:nil body:body success:success failure:failure];
}

void EOS_API_abi_json_to_bin(id body, success success, failure failure){
    [[EOSApi shared] postWithIp:EOSIP Path:@"/v1/chain/abi_json_to_bin" params:nil body:body success:success failure:failure];
}

void EOS_API_abi_bin_to_json(id body, success success, failure failure){
    [[EOSApi shared] postWithIp:EOSIP Path:@"/v1/chain/abi_bin_to_json" params:nil body:body success:success failure:failure];
}

void EOS_API_get_required_keys(id body, success success, failure failure){
    [[EOSApi shared] postWithIp:EOSIP Path:@"/v1/chain/get_required_keys" params:nil body:body success:success failure:failure];
}

void EOS_API_get_currency_stats(id body, success success, failure failure){
    [[EOSApi shared] postWithIp:EOSIP Path:@"/v1/chain/get_currency_stats" params:nil body:body success:success failure:failure];
}

void EOS_API_get_producers(id body, success success, failure failure){
    [[EOSApi shared] postWithIp:EOSIP Path:@"/v1/chain/get_producers" params:nil body:body success:success failure:failure];
}

void EOS_API_push_block(id body, success success, failure failure){
    [[EOSApi shared] postWithIp:EOSIP Path:@"/v1/chain/push_block" params:nil body:body success:success failure:failure];
}

void EOS_API_push_transaction(id body, success success, failure failure){
    [[EOSApi shared] postWithIp:EOSIP Path:@"/v1/chain/push_transaction" params:nil body:body success:success failure:failure];
}

void EOS_API_push_transactions(id body, success success, failure failure){
    [[EOSApi shared] postWithIp:EOSIP Path:@"/v1/chain/push_transactions" params:nil body:body success:success failure:failure];
}


#pragma mark - WALLET -

void EOS_API_creat(id body, success success, failure failure){
    [[EOSApi shared] postWithIp:EOSIP Path:@"/v1/wallet/create" params:nil body:body success:success failure:failure];
}

void EOS_API_open(id body, success success, failure failure){
    [[EOSApi shared] postWithIp:EOSIP Path:@"/v1/wallet/open" params:nil body:body success:success failure:failure];
}

void EOS_API_lock(id body, success success, failure failure){
    [[EOSApi shared] postWithIp:EOSIP Path:@"/v1/wallet/lock" params:nil body:body success:success failure:failure];
}

void EOS_API_lock_all(id body, success success, failure failure){
    [[EOSApi shared] postWithIp:EOSIP Path:@"/v1/wallet/lock_all" params:nil body:body success:success failure:failure];
}

void EOS_API_unlock(id body, success success, failure failure){
    [[EOSApi shared] postWithIp:EOSIP Path:@"/v1/wallet/unlock" params:nil body:body success:success failure:failure];
}

void EOS_API_import_key(id body, success success, failure failure){
    [[EOSApi shared] postWithIp:EOSIP Path:@"/v1/wallet/import_key" params:nil body:body success:success failure:failure];
}

void EOS_API_List_wallets(id body, success success, failure failure){
    [[EOSApi shared] postWithIp:EOSIP Path:@"/v1/wallet/List_wallets" params:nil body:body success:success failure:failure];
}

void EOS_API_list_keys(id body, success success, failure failure){
    [[EOSApi shared] postWithIp:EOSIP Path:@"/v1/wallet/list_keys" params:nil body:body success:success failure:failure];
}


void EOS_API_get_public_keys(id body, success success, failure failure){
    [[EOSApi shared] postWithIp:EOSIP Path:@"/v1/wallet/get_public_keys" params:nil body:body success:success failure:failure];
}

void EOS_API_set_timeout(id body, success success, failure failure){
    [[EOSApi shared] postWithIp:EOSIP Path:@"/v1/wallet/set_timeout" params:nil body:body success:success failure:failure];
}

void EOS_API_sign_transaction(id body, success success, failure failure){
    [[EOSApi shared] postWithIp:EOSIP Path:@"/v1/wallet/sign_transaction" params:nil body:body success:success failure:failure];
}

void EOS_API_set_dir(id body, success success, failure failure){
    [[EOSApi shared] postWithIp:EOSIP Path:@"/v1/wallet/set_dir" params:nil body:body success:success failure:failure];
}

void EOS_API_set_eosio_key(id body, success success, failure failure){
    [[EOSApi shared] postWithIp:EOSIP Path:@"/v1/wallet/set_eosio_key" params:nil body:body success:success failure:failure];
}

void EOS_API_sign_digest(id body, success success, failure failure){
    [[EOSApi shared] postWithIp:EOSIP Path:@"/v1/wallet/sign_digest" params:nil body:body success:success failure:failure];
}

void EOS_API_create_key(id body, success success, failure failure){
    [[EOSApi shared] postWithIp:EOSIP Path:@"/v1/wallet/create_key" params:nil body:body success:success failure:failure];
}

#pragma mark - HISTORY -

void   EOS_API_get_actions(id body, success success, failure failure){
    [[EOSApi shared] postWithIp:EOSIP Path:@"/v1/history/get_actions" params:nil body:body success:success failure:failure];
}
void   EOS_API_get_history(NSString * path,id body, success success, failure failure){
    [[EOSApi shared] postWithIp:path Path:@"/v1/history/get_actions" params:nil body:body success:success failure:failure];
}
void EOS_API_get_transaction(id body, success success, failure failure){
    [[EOSApi shared] postWithIp:EOSIP Path:@"/v1/history/get_transaction" params:nil body:body success:success failure:failure];
}

void EOS_API_get_key_accounts(id body, success success, failure failure){
    [[EOSApi shared] postWithIp:EOSIP Path:@"/v1/history/get_key_accounts" params:nil body:body success:success failure:failure];
}

void EOS_API_get_controlled_accounts(id body, success success, failure failure){
    [[EOSApi shared] postWithIp:EOSIP Path:@"/v1/history/get_controlled_accounts" params:nil body:body success:success failure:failure];
}



#pragma mark - NET -
void EOS_API_connect(id body, success success, failure failure){
    [[EOSApi shared] postWithIp:EOSIP Path:@"/v1/net/connect" params:nil body:body success:success failure:failure];
}

void EOS_API_disconnect(id body, success success, failure failure){
    [[EOSApi shared] postWithIp:EOSIP Path:@"/v1/net/disconnect" params:nil body:body success:success failure:failure];
}

void EOS_API_connections(id body, success success, failure failure){
    [[EOSApi shared] postWithIp:EOSIP Path:@"/v1/net/connections" params:nil body:body success:success failure:failure];
}

void EOS_API_status(id body, success success, failure failure){
    [[EOSApi shared] postWithIp:EOSIP Path:@"/v1/net/status" params:nil body:body success:success failure:failure];
}
#pragma mark - PRODUCER -
void EOS_API_pause(id body, success success, failure failure){
    [[EOSApi shared] postWithIp:EOSIP Path:@"/v1/producer/pause" params:nil body:body success:success failure:failure];
}

void EOS_API_resume(id body, success success, failure failure){
    [[EOSApi shared] postWithIp:EOSIP Path:@"/v1/producer/resume" params:nil body:body success:success failure:failure];
}

void EOS_API_paused(id body, success success, failure failure){
    [[EOSApi shared] postWithIp:EOSIP Path:@"/v1/producer/paused" params:nil body:body success:success failure:failure];
}
@end
