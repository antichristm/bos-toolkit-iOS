////  BOSWCDBManager.h
//  BOS
//
//  Created by BOS on 2018/12/13.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AccountListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BOSWCDBManager : NSObject
+(instancetype)sharedManager;

/**
 关闭数据库
 */
-(void)BOSCloseDatabase;

/**
 创建数据表

 @param tableName 表名
 @param objClass 对应model class
 @return 成功失败
 */
- (BOOL)BOSCreatTableWithTableName:(NSString *)tableName objClass:(Class)objClass;

/**
 插入数据至指定表

 @param tableName  表名
 @param model 对应model
 @return 成功失败
 */
-(BOOL)BOSInsertObjectToTable:(NSString *)tableName model:(NSObject *)model;

/**
 插入数据集合至指定表

 @param tableName 表名
 @param array 数据集合
 @return 成功失败
 */
-(BOOL)BOSInsertObjectsToTable:(NSString *)tableName array:(NSArray *)array;

/**
 查询数据

 @param tableName 表名
 @param objClass  对应model class
 @return 成功失败
 */
-(NSArray *)BOSSelectedAllObjectFromTable:(NSString *)tableName objClass:(Class)objClass;

/**
 删除所有数据

 @param tableName 表名
 @return 成功失败
 */
-(BOOL)BOSDeleteAllObjectsWithTable:(NSString *)tableName;


/**
 新密码重新加密

 @param oldPass 旧密码
 @param newPass 新密码
 @return 结果
 */
-(BOOL)BOSResetLocAccountsEncrypWith:(NSString * __nonnull)oldPass newPass:(NSString *__nonnull)newPass;



/****************************************************AccountListModel 账户操作****************************************************/
-(BOOL)BOSUpdateAccountWithModel:(AccountListModel *)model ;


/**
 更新余额

 @param model 账户模型
 @return 结果
 */
-(BOOL)BOSUpdateBalanceWithModel:(AccountListModel *)model;

/**
 更新是否备份字段

 @param model 要更新的账户模型
 @return 结果
 */
-(BOOL)BOSUpdateIsBackupWithModel:(AccountListModel *)model;
/**
 更新全表备份字段

 @param cloudBackups 备份
 @return 结果
 */
-(BOOL)BOSUpdateCloudBackupsWithValue:(NSString *)cloudBackups;

/**
 更新账户数组

 @param accounts 账户模型数组
 @return 结果
 */
-(BOOL)BOSUpdateAccounts:(NSArray <AccountListModel *>*)accounts;

/**
 账户名删除

 @param accountName 账户名
 @return 结果
 */
-(BOOL)BOSDeleteAccountWhereAccountName:(NSString *)accountName;

/**
 通过链id删除

 @param chainId 链id
 @return 结果
 */
-(BOOL)BOSDeleteAccountWhereChainId:(NSString *)chainId;

/**
 通过合约地址删除

 @param contract 合约地址
 @return 结果
 */
-(BOOL)BOSDeleteAccountWhereContract:(NSString *)contract ;

/**
 通过货币单位c删除

 @param symbol 单位
 @return 结果
 */
-(BOOL)BOSDeleteAccountWhereSymbol:(NSString *)symbol;

/**
 通过账户名查询

 @param accountName 账户名
 @return 结果
 */
-(NSArray * )BOSSelectAccountWhereAccountName:(NSString *)accountName;


/**
 链id查询

 @param chainId 链id
 @return 结果
 */
-(NSArray * )BOSSelectAccountWhereChainId:(NSString *)chainId;

/**
 合约地址查询

 @param contract 合约地址
 @return 结果
 */
-(NSArray * )BOSSelectAccountWhereContract:(NSString *)contract;


/**
 查询是否备份账户

 @param isBackup 是否备份  (YES 备份，NO 未备份)
 @return 结果
 */
-(NSArray * )BOSSelectAccountWhereIsBackup:(BOOL)isBackup;

/**
 时间戳排序查询所有账户

 @param asc 是否升序 (YES 升序 , NO 降序)
 @return 结果
 */
-(NSArray * )BOSSelectAccountWhereCreatTimestampAsc:(BOOL)asc;


/****************************************************HistoryAccountModel 红包历史****************************************************/
-(BOOL)BOSDeleteHistoryModelWhereAccountId:(NSString *)accountId;

@end

NS_ASSUME_NONNULL_END
