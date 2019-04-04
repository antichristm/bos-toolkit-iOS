//
//  EOSTools.m
//  BOS
//
//  Created by 梁唐 on 2018/12/11.
//  Copyright © 2018 lingling. All rights reserved.
//

#import "EOSTools.h"
#ifdef __OBJC__
#include "sha2.h"
#include "uEcc.h"
#include "rmd160.h"
#include "libbase58.h"
#endif
#import "EOSActionModel.h"
@interface EOSTools ()

@end

@implementation EOSTools

+ (instancetype)shared {
    
    static id __object;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        __object = [[EOSTools alloc] init];
    });
    return __object;
}

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (EOSKeyModel *)getEOSKey{
    NSString *mnemonic = [Mnemonic generateMnemonicString:@128 language:@"english"];
    //助记词推出Seed ，存入钥匙串
    NSString *seed = [Mnemonic deterministicSeedStringFromMnemonicString:mnemonic passphrase:@"" language:@"english"];
    NSData *seedData = [seed dataFromHexString];
    BTCKeychain *keychain = [[BTCKeychain alloc] initWithSeed:seedData];
    //拿到私钥 ，在私钥前加上0x80 然后两次哈希，取前4位家在私钥后面
    NSData *private = [keychain keyWithPath:@"m/44'/194'/0'/0/0"].privateKey;
    BTCKey *key = [[BTCKey alloc] initWithPrivateKey:private];
    NSData *compressedPub = key.compressedPublicKey;
    NSData *checksum = [BTCRIPEMD160(compressedPub) subdataWithRange:NSMakeRange(0, 4)];
    NSMutableData *addr = [[NSMutableData alloc] initWithData:compressedPub];
    [addr appendData:checksum];
    NSString *eosAddr = [NSString stringWithFormat:@"EOS%@",addr.base58String];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:key.WIF,@"privateKey",eosAddr,@"publicKey", nil];
    EOSKeyModel *model = [EOSKeyModel mj_objectWithKeyValues:dict];
    return model;
}


- (NSString *)getAddress:(NSString *)wif{
    BTCKey *key = [[BTCKey alloc] initWithWIF:wif];
    NSData *compressedPub = key.compressedPublicKey;
    NSData *checksum = [BTCRIPEMD160(compressedPub) subdataWithRange:NSMakeRange(0, 4)];
    NSMutableData *addr = [[NSMutableData alloc] initWithData:compressedPub];
    [addr appendData:checksum];
    NSString * pub = addr.base58String;
    if (pub && pub.length > 0) {
        return [NSString stringWithFormat:@"EOS%@",addr.base58String];
    }else{
        return nil;
    }
}

- (NSString *)EncryptWith:(NSString *)content password:(NSString *)password{
    NSString *pass512 = password.SHA512String;
    NSData * key = [pass512.dataFromHexString subdataWithRange:NSMakeRange(0, 32)];
    NSData *iv = [pass512.dataFromHexString subdataWithRange:NSMakeRange(32, 16)];
    NSData *data= [content dataUsingEncoding:NSUTF8StringEncoding];
    NSString * base58String = data.base58String;
    NSData * base58Data = [base58String dataUsingEncoding:NSUTF8StringEncoding];
    if (!base58Data || !key || !iv) {
        return nil;
    }
    NSData * EncryptData = aesEncryptData(base58Data, key , iv);
    NSString * result = EncryptData.base58String;
    if (result && result.length > 0) {
        return result;
    }else{
        return nil;
    }
}
- (NSString *)DecryptWith:(NSString *)content password:(NSString *)password{
    NSString *pass512 = password.SHA512String;
    NSData * key = [pass512.dataFromHexString subdataWithRange:NSMakeRange(0, 32)];
    NSData *iv = [pass512.dataFromHexString subdataWithRange:NSMakeRange(32, 16)];
    NSData *data = content.dataFromBase58;
    if (!data || !key || !iv) {
        return nil;
    }
    NSData * DecryptData = aesDecryptData(data, key, iv);
    NSString * base58String = [[NSString alloc] initWithData:DecryptData encoding:NSUTF8StringEncoding];
    NSData * contentData = base58String.dataFromBase58;
    NSString * DecryptStr = [[NSString alloc]initWithData:contentData encoding:NSUTF8StringEncoding];
    if (DecryptStr && DecryptStr.length > 0) {
        return DecryptStr;
    }else{
        return nil;
    }
}
- (NSString *)EncryptKeystoreWith:(NSString *)content password:(NSString *)password{
    NSString *pass512 = password.SHA512String;
    NSData * key = [pass512.dataFromHexString subdataWithRange:NSMakeRange(0, 32)];
    NSData *iv = [pass512.dataFromHexString subdataWithRange:NSMakeRange(32, 16)];
    NSData *data= [content dataUsingEncoding:NSUTF8StringEncoding];
    NSData * EncryptData = aesEncryptData(data, key , iv);
    NSString * result = EncryptData.base58String;
    if (result && result.length > 0) {
        return result;
    }else{
        return nil;
    }
}
- (NSString *)DecryptKeystoreWith:(NSString *)content password:(NSString *)password{
    NSString *pass512 = password.SHA512String;
    NSData * key = [pass512.dataFromHexString subdataWithRange:NSMakeRange(0, 32)];
    NSData *iv = [pass512.dataFromHexString subdataWithRange:NSMakeRange(32, 16)];
    NSData *data= content.dataFromBase58;
    NSData * DecryptData = aesDecryptData(data, key, iv);
    NSString *DecryptStr = [[NSString alloc] initWithData:DecryptData encoding:NSUTF8StringEncoding];
    if (DecryptStr && DecryptStr.length > 0) {
        return DecryptStr;
    }else{
        return nil;
    }
}
/**
 合约操作
 @param actions {
 "code":"eosio.token",
 "action":"transfer",
 "args": {
 "from": "eos",
 "to": "eosio",
 "quantity": "2.0000 EOS",
 "memo": ""
 }
 }
 */
- (void)eosActions:(NSArray *)actions actor:(NSString *)actor permission:(NSString *)permission privateKey:(NSString *)privateKey success:(void (^)(id responseObject))success failure:(void (^)(id failure, id message))failure{
//     __block NSDictionary *get_info = [NSDictionary dictionary];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    CFAbsoluteTime start1 = CFAbsoluteTimeGetCurrent();
    EOS_API_get_info(^(id  _Nonnull infoObject) {
        [params setObject:[NSString stringWithFormat:@"%@",infoObject[@"head_block_num"]] forKey:@"ref_block_num"];
        EOS_API_get_block(@{@"block_num_or_id":infoObject[@"head_block_num"]}, ^(id  _Nonnull blockObject) {
            [params setObject:blockObject[@"timestamp"] forKey:@"expiration"];
            [params setObject:[NSString stringWithFormat:@"%@",blockObject[@"ref_block_prefix"]] forKey:@"ref_block_prefix"];
            NSMutableArray *binargsArr = [NSMutableArray array];
            //创建信号量
            dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
            //创建全局并行队列
            dispatch_queue_t queue = dispatch_queue_create("ActionsQueue", DISPATCH_QUEUE_SERIAL);
            dispatch_group_t group = dispatch_group_create();
            
            for (int i = 0; i < actions.count; i++) {
                dispatch_group_async(group, queue, ^{
//                    [NSThread sleepForTimeInterval:0.05];
                    NSDictionary *dict = actions[i];
                    EOSActionModel *model = [[EOSActionModel alloc] init];
                    model.index = i;
                    model.action = dict;
                    EOS_API_abi_json_to_bin(dict, ^(id  _Nonnull binargsObj) {
                        model.binargs = binargsObj[@"binargs"];
                        [binargsArr addObject:model];
                        dispatch_semaphore_signal(semaphore);
                    }, ^(id  _Nonnull failure, id  _Nonnull message) {
                        dispatch_semaphore_signal(semaphore);
                    });
                });
            }
            
            dispatch_group_notify(group, queue, ^{
                for (int i = 0 ; i < actions.count; i++) {
                    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 排序key, 某个对象的属性名称，是否升序, YES-升序, NO-降序
                    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES];
                    // 排序结果
                    NSArray *finalarr = [binargsArr sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
                    
                    NSMutableArray *actionsArr = [NSMutableArray array];
                    for (int j = 0; j < finalarr.count; j++) {
                        EOSActionModel *model = finalarr[j];
                        NSDictionary *actionDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                                    model.action[@"code"],@"account",
                                                    model.action[@"action"],@"name",
                                                    [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:actor,@"actor",permission,@"permission", nil], nil],@"authorization",
                                                    model.binargs,@"data", nil];
                        [actionsArr addObject:actionDict];
                    }
                    
                    [params setObject:actionsArr forKey:@"actions"];
                    NSString *chainId = infoObject[@"chain_id"];
                    NSData *pack = [EOSByteWriter getBytesForSignatureActions:chainId.dataFromHexString andParams:params andCapacity:255];
                    NSLog(@"%@", pack);
                    uint8_t *packBytes = (uint8_t *)pack.bytes;
                    uint8_t packedSha256[SHA256_DIGEST_LENGTH];
                    sha256_Raw(packBytes, pack.length, packedSha256);
                    uint8_t signature[uECC_BYTES * 2] = { 0 };
                    BTCKey *key = [[BTCKey alloc] initWithWIF:privateKey];
                    if (!key) {
                        if (failure) {
                            failure(nil,[EOSErrorManager errorWithErrorCode:0]);
                        }
                    }
                    int recId = uECC_sign_forbc([key.privateKey bytes], packedSha256, signature);
                    if (recId == -1) {
                        // could not find recid, data probably already signed by the key before?
                        if (failure) {
                            failure(nil,[EOSErrorManager errorWithErrorCode:0]);
                        }
                    } else {
                        unsigned char bin[65+4] = { 0 };
                        unsigned char *rmdhash = NULL;
                        int binlen = 65+4;
                        int headerBytes = (unsigned char)recId + 27 + 4;
                        bin[0] = (unsigned char)headerBytes;
                        memcpy(bin + 1, signature, uECC_BYTES * 2);
                        unsigned char temp[67] = { 0 };
                        memcpy(temp, bin, 65);
                        memcpy(temp + 65, "K1", 2);
                        
                        rmdhash = RMD(temp, 67);
                        memcpy(bin + 1 +  uECC_BYTES * 2, rmdhash, 4);
                        
                        char sigbin[100] = { 0 };
                        size_t sigbinlen = 100;
                        b58enc(sigbin, &sigbinlen, bin, binlen);
                        NSString *sig = @"SIG_K1_";
                        NSString *signatures = [NSString stringWithFormat:@"%@%s",sig, sigbin];
                        NSDictionary *pushDict = @{
                                                   @"signatures":@[
                                                           signatures
                                                           ],
                                                   @"compression":@"none",
                                                   @"packed_context_free_data":@"00",
                                                   @"packed_trx":[pack subdataWithRange:NSMakeRange(chainId.dataFromHexString.length, pack.length - chainId.dataFromHexString.length - 32)].hex
                                                   };
                        NSLog(@"pushDict : %@", pushDict);
                        EOS_API_push_transaction(pushDict, ^(id response) {
                            NSLog(@"%@", response);
                            CFAbsoluteTime end1 = CFAbsoluteTimeGetCurrent();
                            NSLog(@"耗时——————————————————————————————————————————————————————————————%f", end1 - start1);
                            if (success) {
                                success(response);
                            }
                        }, ^(id error1, id message) {
                            if (failure) {
                                failure(error1,message);
                            }
                        });
                    }
                });
            });
            
        }, ^(id  _Nonnull Blockfailure, id  _Nonnull message) {
            if (failure) {
                failure(Blockfailure,message);
            }
        });
    }, ^(id  _Nonnull Infofailure, id  _Nonnull message) {
        if (failure) {
            failure(Infofailure,message);
        }
    });
}

- (NSString *)signedTransaction:(NSMutableData *)pack privateKey:(NSString *)pri_key{
    uint8_t *packBytes = (uint8_t *)pack.bytes;
    uint8_t packedSha256[SHA256_DIGEST_LENGTH];
    sha256_Raw(packBytes, pack.length, packedSha256);
    uint8_t signature[uECC_BYTES * 2] = { 0 };
    BTCKey *key = [[BTCKey alloc] initWithWIF:pri_key];
    if (!key) {
        return nil;
    }
    int recId = uECC_sign_forbc([key.privateKey bytes], packedSha256, signature);
    if (recId == -1) {
        // could not find recid, data probably already signed by the key before?
        return nil;
    } else {
        unsigned char bin[65+4] = { 0 };
        unsigned char *rmdhash = NULL;
        int binlen = 65+4;
        int headerBytes = (unsigned char)recId + 27 + 4;
        bin[0] = (unsigned char)headerBytes;
        memcpy(bin + 1, signature, uECC_BYTES * 2);
        unsigned char temp[67] = { 0 };
        memcpy(temp, bin, 65);
        memcpy(temp + 65, "K1", 2);
        
        rmdhash = RMD(temp, 67);
        memcpy(bin + 1 +  uECC_BYTES * 2, rmdhash, 4);
        
        char sigbin[100] = { 0 };
        size_t sigbinlen = 100;
        b58enc(sigbin, &sigbinlen, bin, binlen);
        NSString *sig = @"SIG_K1_";
        return [NSString stringWithFormat:@"%@%s",sig, sigbin];
    }
}

@end
