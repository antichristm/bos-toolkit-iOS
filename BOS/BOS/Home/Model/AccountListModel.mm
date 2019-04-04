////  AccountListModel.m
//  BOS
//
//  Created by BOS on 2018/12/13.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import "AccountListModel.h"
#import <WCDB/WCDB.h>
#import "AccountListModel+WCTTableCoding.h"
@implementation AccountListModel

WCDB_IMPLEMENTATION(AccountListModel)

WCDB_SYNTHESIZE(AccountListModel, chainId)
WCDB_SYNTHESIZE(AccountListModel, contract)
WCDB_SYNTHESIZE(AccountListModel, symbol)
WCDB_SYNTHESIZE(AccountListModel, accountId)
WCDB_SYNTHESIZE(AccountListModel, accountName)
WCDB_SYNTHESIZE(AccountListModel, keys)
WCDB_SYNTHESIZE(AccountListModel, balance)
WCDB_SYNTHESIZE(AccountListModel, decimals)
WCDB_SYNTHESIZE(AccountListModel, creatTimestamp)
WCDB_SYNTHESIZE(AccountListModel, cloudBackups)
WCDB_SYNTHESIZE(AccountListModel, remark)
WCDB_SYNTHESIZE(AccountListModel, isBackup)

WCDB_PRIMARY(AccountListModel, accountName)
WCDB_INDEX(AccountListModel, "_index", accountName)

+(instancetype)initModelWithObject:(id)object{
    AccountListModel * model = [AccountListModel mj_objectWithKeyValues:object];
    return model;
}
-(NSString *)balance{
    return _balance?:@"--";
}
-(NSString *)accountName{
    return _accountName?:@"--";
}
-(void)setLocExsit:(NSString *)locExsit{
    _locExsit = locExsit;
    self.locExsitWidth = [_locExsit boundingRectWithSize:CGSizeMake(ScreenWidth, 200) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont fontWithName:@"PingFangSC-Regular" size:9]} context:nil].size.width + 8;
}
-(void)setCloudBackups:(NSString *)cloudBackups{
    _cloudBackups = cloudBackups;
    self.cloudBackupsWidth = [_cloudBackups boundingRectWithSize:CGSizeMake(ScreenWidth, 200) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont fontWithName:@"PingFangSC-Regular" size:9]} context:nil].size.width + 8;
}
-(BOOL)verificationKeyWithPublic:(NSString *)publicKey permission:(NSString *)permission{
    NSDictionary * originKeys = self.keys.mj_JSONObject;
    NSString * key = [NSString stringWithFormat:@"%@_%@",publicKey,permission];
    return [originKeys.allKeys containsObject:key];
}
-(BOOL)verificationOwnerKey{
    return [self verificationKeyWithType:BOS_OWNER_KEY];
}
-(BOOL)verificationKeyWithType:(NSString * )keyType{
    @try {
        NSDictionary * originKeys = self.keys.mj_JSONObject;
        NSArray * permissions = [originKeys.allValues valueForKey:@"permission"];
        return [permissions containsObject:keyType];
    } @catch (NSException *exception) {
        NSLog(@"error---%@",exception);
        return NO;
    } @finally {}
}
#pragma mark  🐷 数据库操作 🐷
+(BOOL)BOSUpdateWithModel:(AccountListModel *)model database:(WCTDatabase*)database{
    BOOL result = NO;
    
    result = [database updateRowsInTable:BOSDBAccountTableName onProperties:{AccountListModel.keys,AccountListModel.cloudBackups,AccountListModel.isBackup,AccountListModel.chainId} withObject:model where:AccountListModel.accountName == model.accountName];
    return result;
}
+(BOOL)BOSUpdateBalanceWithModel:(AccountListModel *)model database:(WCTDatabase*)database{
    BOOL result = NO;
    result = [database updateRowsInTable:BOSDBAccountTableName onProperties:AccountListModel.balance withObject:model where:AccountListModel.accountName == model.accountName];
    return result;
}
+(BOOL)BOSUpdateIsBackupWithModel:(AccountListModel *)model database:(WCTDatabase*)database{
    BOOL result = NO;
    result = [database updateRowsInTable:BOSDBAccountTableName onProperties:AccountListModel.isBackup withObject:model where:AccountListModel.accountName == model.accountName];
    return result;
}
+(BOOL)BOSUpdateCloudBackupsWithValue:(NSString *)cloudBackups database:(WCTDatabase*)database{
    BOOL result = NO;
    result = [database updateAllRowsInTable:BOSDBAccountTableName onProperty:AccountListModel.cloudBackups withValue:cloudBackups];
    return result;
}
+(BOOL)BOSUpdateAccounts:(NSArray *)array database:(WCTDatabase*)database{
    if (!array || array.count == 0) {
        return NO;
    }
    BOOL result = [database beginTransaction];
    result = [database insertOrReplaceObjects:array into:BOSDBAccountTableName];
    
    if (result) {
        result = [database commitTransaction];
        NSLog(@"添加成功");
    }else{
        [database rollbackTransaction];
        NSLog(@"添加失败");
    }
    return result;
}
+(BOOL)BOSDeleteWhereAccountId:(NSInteger)accountId database:(WCTDatabase*)database{
    BOOL result = NO;
    result = [database deleteObjectsFromTable:BOSDBAccountTableName where:AccountListModel.accountId == accountId];
    return result;
}
+(BOOL)BOSDeleteWhereAccountName:(NSString *)accountName database:(WCTDatabase*)database{
    BOOL result = NO;
    result = [database deleteObjectsFromTable:BOSDBAccountTableName where:AccountListModel.accountName == accountName];
    return result;
}
+(BOOL)BOSDeleteWhereChainId:(NSString *)chainId database:(WCTDatabase*)database{
    BOOL result = NO;
    result = [database deleteObjectsFromTable:BOSDBAccountTableName where:AccountListModel.chainId == chainId];
    return result;
}
+(BOOL)BOSDeleteWhereContract:(NSString *)contract database:(WCTDatabase*)database{
    BOOL result = NO;
    result = [database deleteObjectsFromTable:BOSDBAccountTableName where:AccountListModel.contract == contract];
    return result;
}
+(BOOL)BOSDeleteWhereSymbol:(NSString *)symbol database:(WCTDatabase*)database{
    BOOL result = NO;
    result = [database deleteObjectsFromTable:BOSDBAccountTableName where:AccountListModel.symbol == symbol];
    return result;
}
+(NSArray * )BOSSelectAccountWhereAccountName:(NSString *)accountName database:(WCTDatabase * )database{
    NSArray * result = [database getObjectsOfClass:AccountListModel.class fromTable:BOSDBAccountTableName where:AccountListModel.accountName == accountName];
    return result;
}
+(NSArray * )BOSSelectAccountWhereChainId:(NSString *)chainId database:(WCTDatabase * )database{
    NSArray * result = [database getObjectsOfClass:AccountListModel.class fromTable:BOSDBAccountTableName where:AccountListModel.chainId == chainId];
    return result;
}
+(NSArray * )BOSSelectAccountWhereContract:(NSString *)contract database:(WCTDatabase * )database{
    NSArray * result = [database getObjectsOfClass:AccountListModel.class fromTable:BOSDBAccountTableName where:AccountListModel.contract == contract];
    return result;
}
+(NSArray * )BOSSelectAccountWhereCreatTimestampAsc:(BOOL)asc database:(WCTDatabase * )database{
    NSArray * result = [database getObjectsOfClass:AccountListModel.class fromTable:BOSDBAccountTableName orderBy:AccountListModel.creatTimestamp.order((asc == YES) ? WCTOrderedAscending : WCTOrderedDescending )];
    return result;
}
+(NSArray * )BOSSelectAccountWhereIsBackup:(BOOL)isBackup database:(WCTDatabase * )database{
    NSArray * result = [database getObjectsOfClass:AccountListModel.class fromTable:BOSDBAccountTableName where:AccountListModel.isBackup == isBackup];
    return result;
}
@end
