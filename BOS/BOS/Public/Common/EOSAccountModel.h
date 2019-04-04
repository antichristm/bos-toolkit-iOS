////  EOSAccountModel.h
//  BOS
//
//  Created by BOS on 2018/12/24.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface net_limit :NSObject
@property (nonatomic , assign) NSInteger              used;
@property (nonatomic , assign) NSInteger              available;
@property (nonatomic , assign) NSInteger              max;

@end


@interface cpu_limit :NSObject
@property (nonatomic , assign) NSInteger              used;
@property (nonatomic , assign) NSInteger              available;
@property (nonatomic , assign) NSInteger              max;

@end


@interface keysItem :NSObject
@property (nonatomic , copy) NSString              * key;
@property (nonatomic , assign) NSInteger              weight;

@end


@interface accountsItem :NSObject

@end


@interface waitsItem :NSObject

@end


@interface required_auth :NSObject
@property (nonatomic , assign) NSInteger              threshold;
@property (nonatomic , strong) NSArray <keysItem *>              * keys;
@property (nonatomic , strong) NSArray <accountsItem *>              * accounts;
@property (nonatomic , strong) NSArray <waitsItem *>              * waits;

@end


@interface permissionsItem :NSObject
@property (nonatomic , copy) NSString              * perm_name;
@property (nonatomic , copy) NSString              * parent;
@property (nonatomic , strong) required_auth              * required_auth;

@end


@interface total_resources :NSObject
@property (nonatomic , copy) NSString              * owner;
@property (nonatomic , copy) NSString              * net_weight;
@property (nonatomic , copy) NSString              * cpu_weight;
@property (nonatomic , assign) NSInteger              ram_bytes;

@end


@interface self_delegated_bandwidth :NSObject
@property (nonatomic , copy) NSString              * from;
@property (nonatomic , copy) NSString              * to;
@property (nonatomic , copy) NSString              * net_weight;
@property (nonatomic , copy) NSString              * cpu_weight;

@end


@interface voter_info :NSObject
@property (nonatomic , copy) NSString              * owner;
@property (nonatomic , copy) NSString              * proxy;
@property (nonatomic , assign) NSInteger              staked;
@property (nonatomic , copy) NSString              * last_vote_weight;
@property (nonatomic , copy) NSString              * proxied_vote_weight;
@property (nonatomic , assign) NSInteger              is_proxy;

@end

@interface EOSAccountModel : BaseModel
@property (nonatomic , copy) NSString              * account_name;
@property (nonatomic , assign) NSInteger              head_block_num;
@property (nonatomic , copy) NSString              * head_block_time;
@property (nonatomic , assign) BOOL              privileged;
@property (nonatomic , copy) NSString              * last_code_update;
@property (nonatomic , copy) NSString              * created;
@property (nonatomic , copy) NSString              * core_liquid_balance;
@property (nonatomic , assign) NSInteger              ram_quota;
@property (nonatomic , assign) NSInteger              net_weight;
@property (nonatomic , assign) NSInteger              cpu_weight;
@property (nonatomic , strong) net_limit              * net_limit;
@property (nonatomic , strong) cpu_limit              * cpu_limit;
@property (nonatomic , assign) NSInteger              ram_usage;
@property (nonatomic , strong) NSArray <permissionsItem *>              * permissions;
@property (nonatomic , strong) total_resources              * total_resources;
@property (nonatomic , strong) self_delegated_bandwidth              * self_delegated_bandwidth;
@property (nonatomic , strong) voter_info              * voter_info;

/**
 获取公钥对应的权限数组

 @param publicKey 公钥
 @return 权限数组
 */
-(NSArray *)verificationKeyWithPublic:(NSString *)publicKey;

/**
 获取公钥对应的权限名数组

 @param key 公钥
 @return 权限名数组
 */
-(NSArray <NSString *>*)getPermissionNamesWithPublicKey:(NSString *)key;

/**
 获取公钥对应的权限名

 @param key 公钥
 @return 权限名
 */
-(NSString *)getFirstPermissionPublicKey:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
