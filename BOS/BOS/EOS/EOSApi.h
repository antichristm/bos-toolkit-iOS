//
//  EOSApi.h
//  BOS
//
//  Created by 梁唐 on 2018/12/11.
//  Copyright © 2018 lingling. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


typedef void(^success)(id responseObject);
typedef void(^fail)(NSError *error);
typedef void(^failure)(id failure, id message);
@interface EOSApi : NSObject
+ (instancetype)shared;
#pragma mark - CHAIN -
/**
 获取区块链信息
 
 @param success 成功回调{
 head_block_id = 007488fb896a6e9266d59bad0a1a86e9a20707418baaff4344256d4a3622df51,
 last_irreversible_block_num = 7636918,
 server_version = 980721a6,
 head_block_producer = eoslaomaocom,
 virtual_block_net_limit = 1048576000,
 head_block_time = 2018-07-25T03:48:25.000,
 block_cpu_limit = 199900,
 block_net_limit = 1048576,
 last_irreversible_block_id = 007487b60b3663b0347e3519cbe97cc3c95882d1d02783cd1ef6098987d1651f,
 virtual_block_cpu_limit = 17649158,
 chain_id = aca376f206b8fc25a6ed44dbdc66547c36c6c33e3a119ffbeaef943642f0e906,
 head_block_num = 7637243
 }
 @param failure 失败回调
 */
void EOS_API_get_info(success success, failure failure);

void EOS_API_get_block(id body, success success, failure failure);

void EOS_API_get_block_header(id body, success success, failure failure);

/**
 获取账户信息
 
 @param body {@"account_name":@"yourName"}
 @param success 成功回调
 @param failure 失败回调
 */
void EOS_API_get_account(id body, success success, failure failure);

void EOS_API_get_abi(id body, success success, failure failure);

void EOS_API_get_code(id body, success success, failure failure);

/**
 查表
 
 @param body @{
 @"json":@true,
 @"code":@"eosio",
 @"limit":@"1",
 @"scope":@"eosio",
 @"table":@"rammarket"//表名
 }
 @param success 成功回调
 @param failure 失败回调
 */
void EOS_API_get_table_rows(id body, success success, failure failure);

/**
 查询余额
 
 @param body {
 "code":"eosio.token",//合约名
 "account":"starteosnews",//账户名
 "symbol":"EOS"//
 }
 @param success 成功回调
 @param failure 失败回调
 */
void EOS_API_get_currency_balance(id body, success success, failure failure);

void EOS_API_abi_json_to_bin(id body, success success, failure failure);

void EOS_API_abi_bin_to_json(id body, success success, failure failure);

void EOS_API_get_required_keys(id body, success success, failure failure);

/**
 获取当前货币状态
 
 @param body {
 symbol = AC,
 code = aircoin.eos
 }
 @param success {
 AC = {
 supply = 1000000000.0000 AC,
 max_supply = 1000000000.0000 AC,
 issuer = aircoin.eos
 }
 }
 @param failure 失败
 */
void EOS_API_get_currency_stats(id body, success success, failure failure);

/**
 获取产品？状态？
 
 @param body {
 limit = 9999,
 json = true
 }
 @param success 太多了
 @param failure <#failure description#>
 */
void EOS_API_get_producers(id body, success success, failure failure);

void EOS_API_push_block(id body, success success, failure failure);

/**
 交易
 
 @param body {
 packed_trx = e640585bf92280da307c0000000001003055603a8aae33000000572d3ccdcd01c0a68398aa7c4dc600000000a8ed323221c0a68398aa7c4dc6608e3998aa7c4dc6102700000000000004414300000000000000,
 signatures = [
 SIG_K1_K1ojSdXf63KTBTjTrr85WmuKPJgWmGrX5fdtJEmU9wYDMxHcNycDJ17aKL2KqpBTWbEZTMhkBNcDgEhkebDF232D5Tc1J5
 ],
 compression = none,
 packed_context_free_data = 00
 }
 @param success 好长的
 @param failure 不管了
 */
void EOS_API_push_transaction(id body, success success, failure failure);

/**
 多个交易
 
 @param body <#body description#>
 @param success <#success description#>
 @param failure <#failure description#>
 */
void EOS_API_push_transactions(id body, success success, failure failure);


#pragma mark - WALLET -

void EOS_API_creat(id body, success success, failure failure);

void EOS_API_open(id body, success success, failure failure);

void EOS_API_lock(id body, success success, failure failure);

void EOS_API_lock_all(id body, success success, failure failure);

void EOS_API_unlock(id body, success success, failure failure);

void EOS_API_import_key(id body, success success, failure failure);

void EOS_API_List_wallets(id body, success success, failure failure);

void EOS_API_list_keys(id body, success success, failure failure);

void EOS_API_get_public_keys(id body, success success, failure failure);

void EOS_API_set_timeout(id body, success success, failure failure);

void EOS_API_sign_transaction(id body, success success, failure failure);

void EOS_API_set_dir(id body, success success, failure failure);

void EOS_API_set_eosio_key(id body, success success, failure failure);

void EOS_API_sign_digest(id body, success success, failure failure);

void EOS_API_create_key(id body, success success, failure failure);


#pragma mark - HISTORY -

void EOS_API_get_actions(id body, success success, failure failure);

void EOS_API_get_history(NSString * path,id body, success success, failure failure);

void EOS_API_get_transaction(id body, success success, failure failure);

void EOS_API_get_key_accounts(id body, success success, failure failure);

void EOS_API_get_controlled_accounts(id body, success success, failure failure);



#pragma mark - NET -
void EOS_API_connect(id body, success success, failure failure);

void EOS_API_disconnect(id body, success success, failure failure);

void EOS_API_connections(id body, success success, failure failure);

void EOS_API_status(id body, success success, failure failure);

#pragma mark - PRODUCER -
void EOS_API_pause(id body, success success, failure failure);

void EOS_API_resume(id body, success success, failure failure);

void EOS_API_paused(id body, success success, failure failure);

@end

NS_ASSUME_NONNULL_END
