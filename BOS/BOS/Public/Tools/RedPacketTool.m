////  RedPacketTool.m
//  BOS
//
//  Created by BOS on 2018/12/24.
//  Copyright © 2018年 BOS. All rights reserved.
//


#import "RedPacketTool.h"

@implementation RedPacketTool



+ (void)CreateRedPacketWithRedType:(RedPacketType)type ID:(NSString *)ID count:(int)count publicKey:(NSString *)pubKey greetings:(NSString *)greetings selfAccountName:(NSString *)selfName selfPrivateKey:(NSString *)privateKey currentPermission:(NSString *)permission amount:(NSString *)amount success:(void (^)(id responseObject))success failure:(void (^)(id failure, id message))failure{
    BOOL parame = type && ID && count && pubKey && selfName && privateKey && amount ;
    NSAssert(parame, @"参数不正确");
    NSString * memo = [NSString stringWithFormat:@"hb^%d^%@^%d^%@^%@^%@",(int)type,ID,count,pubKey,selfName,greetings];
    NSDecimalNumber * number = [BOSTools doubleToDecimal:amount.doubleValue length:4 mode:NSRoundDown];
    NSString * quantity = [NSString stringWithFormat:@"%.4f BOS",number.doubleValue];
    NSDictionary * dict =@{@"from":selfName,@"to":KRedContractName,@"quantity":quantity,@"memo":memo};
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"eosio.token",@"code",
                            @"transfer",@"action",
                            dict,@"args",nil];
    [[EOSTools shared] eosActions:@[params] actor:selfName permission:permission?:@"active" privateKey:privateKey success:success failure:failure];
}

+ (void)GetRedPacketWithRedID:(NSString *)redID redPacketPrivateKey:(NSString *)redPrivatekey receiver:(NSString *)receiver success:(void (^)(id responseObject))success failure:(void (^)(id failure, id message))failure{
    BOOL parame = redID && redPrivatekey && receiver;
    NSAssert(parame, @"参数不正确");
    NSMutableData * data = [NSMutableData dataWithData:[redID dataUsingEncoding:NSUTF8StringEncoding]];
    NSString * signStr =  [[EOSTools shared] signedTransaction:data privateKey:redPrivatekey];
    NSDictionary * dict = @{
                            @"receiver" :receiver,
                            @"id":redID,
                            @"sig":signStr
                            };
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            KRedContractName,@"code",
                            @"get",@"action",
                            dict,@"args",nil];
    [[EOSTools shared] eosActions:@[params] actor:KGetRedPacketName permission:KGetRedPacketPermisson privateKey:KGetRedPacketPrivateKey success:success failure:failure];
}

+ (void)CreatAccountWithRedID:(NSString *)ID redPacketPriKey:(NSString *)redPrivatekey newAccountName:(NSString *)newAccountName accoountOwnerPublicKey:(NSString *)ownerKey accountActivePublicKey:(NSString *)activeKey success:(void (^)(id responseObject))success failure:(void (^)(id failure, id message))failure{
    BOOL parame = ID && redPrivatekey && newAccountName && ownerKey && activeKey;
    NSAssert(parame, @"参数不正确");
    NSMutableData * data = [NSMutableData dataWithData:[ID dataUsingEncoding:NSUTF8StringEncoding]];
    NSString * signStr =  [[EOSTools shared] signedTransaction:data privateKey:redPrivatekey];
    
    NSDictionary * dict = @{
                            @"account" :newAccountName,
                            @"owner_key" : ownerKey,
                            @"active_key": activeKey,
                            @"id":ID,@"sig":signStr
                            };
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            KRedContractName,@"code",
                            @"create",@"action",
                            dict,@"args",nil];
    [[EOSTools shared] eosActions:@[params] actor:KGetRedPacketName permission:KGetRedPacketPermisson privateKey:KGetRedPacketPrivateKey success:success failure:failure];
    
}

+ (void)createAccountFromTransferWithNewAccountName:(NSString *)newAccountName ownerPublicKey:(NSString *)ownerPublickey activePublicKey:(NSString *)activePublicKey selfAccountName:(NSString *)selfName selfPrivateKey:(NSString *)privateKey currentPermission:(NSString *)permission amount:(NSString *)amount success:(void (^)(id responseObject))success failure:(void (^)(id failure, id message))failure{
    BOOL parame = newAccountName && ownerPublickey && activePublicKey && selfName && privateKey && permission && amount;
    NSAssert(parame, @"参数不正确");
    NSString * memo =[NSString stringWithFormat:@"act^%@^%@^%@",newAccountName,ownerPublickey,activePublicKey];
    NSDecimalNumber * number = [BOSTools doubleToDecimal:amount.doubleValue length:4 mode:NSRoundDown];
    NSString * quantity = [NSString stringWithFormat:@"%.4f BOS",number.doubleValue];
    NSDictionary * dict =@{@"from":selfName,@"to":KRedContractName,@"quantity":quantity,@"memo":memo};
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"eosio.token",@"code",
                            @"transfer",@"action",
                            dict,@"args",nil];
    [[EOSTools shared] eosActions:@[params] actor:selfName permission:permission privateKey:privateKey success:success failure:failure];
}

@end
