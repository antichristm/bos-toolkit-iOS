////  AccountListModel.h
//  BOS
//
//  Created by BOS on 2018/12/13.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import "BaseModel.h"
#define BOS_OWNER_KEY @"owner"
#define BOS_ACTIVE_KEY @"active"
NS_ASSUME_NONNULL_BEGIN

@interface AccountListModel : BaseModel
@property(nonatomic,strong)NSString * chainId;
@property(nonatomic,strong)NSString * contract;
@property(nonatomic,strong)NSString * symbol;
@property(nonatomic,assign)NSInteger  accountId;
@property(nonatomic,strong)NSString * accountName;
@property(nonatomic,strong)NSString * keys;
@property(nonatomic,strong)NSString * balance;
@property(nonatomic,strong)NSNumber * decimals;
@property(nonatomic,strong)NSNumber * creatTimestamp;
@property(nonatomic,assign)BOOL isBackup;
@property(nonatomic,strong)NSString * remark;
@property(nonatomic,strong)NSString * cloudBackups;
@property(nonatomic,strong)NSString * locExsit;
@property(nonatomic,assign)CGFloat locExsitWidth;
@property(nonatomic,assign)CGFloat cloudBackupsWidth;


/**
 检验是否包含对应的key与permission

 @param publicKey 公钥
 @param permission 权限
 @return 结果
 */
-(BOOL)verificationKeyWithPublic:(NSString *)publicKey permission:(NSString *)permission;

/**
 检验是否包含owner key

 @return 结果
 */
-(BOOL)verificationOwnerKey;

/**
 检验是否包含某的权限

 @param keyType 权限
 @return 结果
 */
-(BOOL)verificationKeyWithType:(NSString * )keyType;
@end

NS_ASSUME_NONNULL_END
