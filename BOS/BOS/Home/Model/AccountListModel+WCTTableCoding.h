////  AccountListModel+WCTTableCoding.h
//  BOS
//
//  Created by BOS on 2018/12/13.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import "AccountListModel.h"
#import <WCDB/WCDB.h>
NS_ASSUME_NONNULL_BEGIN

@interface AccountListModel (WCTTableCoding)<WCTTableCoding>

WCDB_PROPERTY(chainId)
WCDB_PROPERTY(contract)
WCDB_PROPERTY(symbol)
WCDB_PROPERTY(accountName)
WCDB_PROPERTY(keys)
WCDB_PROPERTY(balance)
WCDB_PROPERTY(decimals)
WCDB_PROPERTY(creatTimestamp)
WCDB_PROPERTY(remark)
WCDB_PROPERTY(cloudBackups)
WCDB_PROPERTY(keyStore)
WCDB_PROPERTY(isBackup)

+(BOOL)BOSUpdateWithModel:(AccountListModel *)model database:(WCTDatabase*)database;
+(BOOL)BOSUpdateBalanceWithModel:(AccountListModel *)model database:(WCTDatabase*)database;
+(BOOL)BOSUpdateIsBackupWithModel:(AccountListModel *)model database:(WCTDatabase*)database;
+(BOOL)BOSUpdateCloudBackupsWithValue:(NSString *)cloudBackups database:(WCTDatabase*)database;
+(BOOL)BOSUpdateAccounts:(NSArray *)array database:(WCTDatabase*)database;
+(BOOL)BOSDeleteWhereAccountId:(NSInteger)accountId database:(WCTDatabase*)database;
+(BOOL)BOSDeleteWhereAccountName:(NSString *)accountName database:(WCTDatabase*)database;
+(BOOL)BOSDeleteWhereChainId:(NSString *)chainId database:(WCTDatabase*)database;
+(BOOL)BOSDeleteWhereContract:(NSString *)contract database:(WCTDatabase*)database;
+(BOOL)BOSDeleteWhereSymbol:(NSString *)symbol database:(WCTDatabase*)database;
+(NSArray * )BOSSelectAccountWhereAccountName:(NSString *)accountName database:(WCTDatabase * )database;
+(NSArray * )BOSSelectAccountWhereChainId:(NSString *)chainId database:(WCTDatabase * )database;
+(NSArray * )BOSSelectAccountWhereContract:(NSString *)contract database:(WCTDatabase * )database;
+(NSArray * )BOSSelectAccountWhereCreatTimestampAsc:(BOOL)asc database:(WCTDatabase * )database;
+(NSArray * )BOSSelectAccountWhereIsBackup:(BOOL)isBackup database:(WCTDatabase * )database;
@end

NS_ASSUME_NONNULL_END
