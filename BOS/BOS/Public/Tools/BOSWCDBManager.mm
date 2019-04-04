////  BOSWCDBManager.m
//  BOS
//
//  Created by BOS on 2018/12/13.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import "BOSWCDBManager.h"
#import <WCDB/WCDB.h>
#import "AccountListModel+WCTTableCoding.h"
#import "HistoryAccountModel+WCTTableCoding.h"
#define BOS_DB_NAME  @"BosToolkit.db"
@interface BOSWCDBManager()
{
    WCTDatabase * _database;
}
@property(nonatomic,strong)NSString * dbPath;
@end
@implementation BOSWCDBManager
+(instancetype)sharedManager{
    static BOSWCDBManager * obj;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[BOSWCDBManager alloc]init];
    });
    return obj;
}
#pragma mark  🐷Private method 🐷
-(NSString *)dbPath{
    if (!_dbPath) {
        NSArray *path=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docDir=[path objectAtIndex:0];
        _dbPath = [docDir stringByAppendingPathComponent:BOS_DB_NAME];
    }
    return _dbPath;
}
-(BOOL)creatDatabase{
    _database = [[WCTDatabase alloc]initWithPath:self.dbPath];
    NSString * uuid = [[[UIDevice currentDevice]identifierForVendor]UUIDString];
    NSString * prefix = [uuid.SHA512String substringWithRange:NSMakeRange(0, 16)];
    NSString * suffix = [uuid.SHA512String substringFromIndex:uuid.SHA512String.length - 16];
    NSString * cipherKeyString = [suffix stringByAppendingString:prefix];
    NSData * cipherKey = [cipherKeyString dataUsingEncoding:NSUTF8StringEncoding];
    [_database setCipherKey:cipherKey];
    if ([_database canOpen]) {
        return YES;
    }else{
        return NO;
    }
}
#pragma mark  🐷Public method 🐷
-(void)BOSCloseDatabase{
    [_database close];
}
- (BOOL)BOSCreatTableWithTableName:(NSString *)tableName objClass:(Class)objClass{
    BOOL result = NO;
    if ([_database isOpened] && _database) {
        result = [_database createTableAndIndexesOfName:tableName withClass:objClass];
        return result;
    }else{
        result = [self creatDatabase];
        result = [_database createTableAndIndexesOfName:tableName withClass:objClass];
    }
    return result;
}

-(BOOL)BOSInsertObjectToTable:(NSString *)tableName model:(NSObject<WCTTableCoding>*)model{
    BOOL result = NO;
    if (!model) {
        return NO;
    }
    if (_database == nil) {
        result = [self creatDatabase];
    }
    result = [_database insertObject:model  into:tableName];
    return result;
}

-(BOOL)BOSInsertObjectsToTable:(NSString *)tableName array:(NSArray<NSObject <WCTTableCoding>*> *)array{
    if (!array || array.count == 0) {
        return NO;
    }
    BOOL result = NO;
    if (_database == nil) {
        result = [self creatDatabase];
    }
    result = [_database beginTransaction];
    result = [_database insertObjects:array into:tableName];
    
    if (result) {
        result = [_database commitTransaction];
        NSLog(@"添加成功");
    }else{
        [_database rollbackTransaction];
        NSLog(@"添加失败");
    }
    return result;
}
-(NSArray *)BOSSelectedAllObjectFromTable:(NSString *)tableName objClass:(Class)objClass{
    NSArray * array ;
    if (_database && [_database isOpened]) {
        array = [_database getAllObjectsOfClass:objClass fromTable:tableName];
    }else{
        [self creatDatabase];
        array = [_database getAllObjectsOfClass:objClass fromTable:tableName];
    }
    return array;
}

-(BOOL)BOSDeleteAllObjectsWithTable:(NSString *)tableName{
    BOOL result = NO;
    if (_database && [_database isOpened]) {
        result = [_database deleteAllObjectsFromTable:tableName];
    }else{
        result = [self creatDatabase];
        result = [_database deleteAllObjectsFromTable:tableName];
    }
    return result;
}
-(BOOL)BOSResetLocAccountsEncrypWith:(NSString *__nonnull)oldPass newPass:(NSString *__nonnull)newPass{
    if (!oldPass || !newPass || oldPass.length == 0 || newPass.length == 0) {
        return NO;
    }
    if ([oldPass isEqualToString:newPass]) {
        return YES;
    }
    @try {
        NSArray * locAccounts = [[BOSWCDBManager sharedManager]BOSSelectedAllObjectFromTable:BOSDBAccountTableName objClass:AccountListModel.class];
        //遍历账户
        for (AccountListModel * account in locAccounts) {
            NSDictionary * keys = account.keys.mj_JSONObject;
            NSMutableDictionary * newKeys = [NSMutableDictionary dictionaryWithCapacity:keys.count];
            //遍历账户所有key
            for (NSString * key in keys.allKeys) {
                NSMutableDictionary * info = [keys[key] mutableCopy];
                NSString * enPri = info[@"private"];
                //旧密码解密
                NSString * dePri = [[EOSTools shared]DecryptWith:enPri password:oldPass];
                if (!dePri) {
                    return NO;
                }
                //新密码加密
                NSString * newEnPri = [[EOSTools shared]EncryptWith:dePri password:newPass];
                info[@"private"] = newEnPri;
                [newKeys setObject:info forKey:key];
            }
            //重新赋值
            account.keys = newKeys.mj_JSONString;
        }
        //更新数据库
        return [[BOSWCDBManager sharedManager]BOSUpdateAccounts:locAccounts];
    } @catch (NSException *exception) {
        NSLog(@"error--->%@",exception);
        return NO;
    } @finally {}
}
#pragma mark  🐷 AccountListModel 账户操作 🐷
-(BOOL)BOSUpdateAccountWithModel:(AccountListModel *)model{
    BOOL result = NO;
    if (_database && [_database isOpened]) {
        result = [AccountListModel BOSUpdateWithModel:model database:_database];
    }else{
        [self creatDatabase];
        result = [AccountListModel BOSUpdateWithModel:model database:_database];
    }
    return result;
}
-(BOOL)BOSUpdateBalanceWithModel:(AccountListModel *)model{
    BOOL result = NO;
    if (_database && [_database isOpened]) {
        result = [AccountListModel BOSUpdateBalanceWithModel:model database:_database];
    }else{
        [self creatDatabase];
        result = [AccountListModel BOSUpdateBalanceWithModel:model database:_database];
    }
    return result;
}
-(BOOL)BOSUpdateIsBackupWithModel:(AccountListModel *)model{
    BOOL result = NO;
    if (_database && [_database isOpened]) {
        result = [AccountListModel BOSUpdateIsBackupWithModel:model database:_database];
    }else{
        [self creatDatabase];
        result = [AccountListModel BOSUpdateIsBackupWithModel:model database:_database];
    }
    return result;
}
-(BOOL)BOSUpdateCloudBackupsWithValue:(NSString *)cloudBackups{
    BOOL result = NO;
    if (_database && [_database isOpened]) {
        result = [AccountListModel BOSUpdateCloudBackupsWithValue:cloudBackups database:_database];
    }else{
        [self creatDatabase];
        result = [AccountListModel BOSUpdateCloudBackupsWithValue:cloudBackups database:_database];
    }
    return result;
}
-(BOOL)BOSUpdateAccounts:(NSArray <AccountListModel *>*)accounts{
    BOOL result = NO;
    if (_database && [_database isOpened]) {
        result = [AccountListModel BOSUpdateAccounts:accounts database:_database];
    }else{
        [self creatDatabase];
        result = [AccountListModel BOSUpdateAccounts:accounts database:_database];
    }
    return result;
}
-(BOOL)BOSDeleteAccountWhereAccountName:(NSString *)accountName{
    BOOL result = NO;
    if (_database && [_database isOpened]) {
        result = [AccountListModel BOSDeleteWhereAccountName:accountName  database:_database];
    }else{
        [self creatDatabase];
        result = [AccountListModel BOSDeleteWhereAccountName:accountName  database:_database];
    }
    return result;
}

-(BOOL)BOSDeleteAccountWhereChainId:(NSString *)chainId{
    BOOL result = NO;
    if (_database && [_database isOpened]) {
        result = [AccountListModel BOSDeleteWhereChainId:chainId database:_database];
    }else{
        [self creatDatabase];
        result = [AccountListModel BOSDeleteWhereChainId:chainId database:_database];
    }
    return result;
}
-(BOOL)BOSDeleteAccountWhereContract:(NSString *)contract {
    BOOL result = NO;
    if (_database && [_database isOpened]) {
        result = [AccountListModel BOSDeleteWhereContract:contract database:_database];
    }else{
        [self creatDatabase];
        result = [AccountListModel BOSDeleteWhereContract:contract database:_database];
    }
    return result;
}
-(BOOL)BOSDeleteAccountWhereSymbol:(NSString *)symbol{
    BOOL result = NO;
    if (_database && [_database isOpened]) {
        result = [AccountListModel BOSDeleteWhereSymbol:symbol database:_database];
    }else{
        [self creatDatabase];
        result = [AccountListModel BOSDeleteWhereSymbol:symbol database:_database];
    }
    return result;
}
-(NSArray * )BOSSelectAccountWhereAccountName:(NSString *)accountName{
    NSArray * array;
    if (_database && [_database isOpened]) {
        array = [AccountListModel BOSSelectAccountWhereAccountName:accountName database:_database];
    }else{
        [self creatDatabase];
        array = [AccountListModel BOSSelectAccountWhereAccountName:accountName database:_database];
    }
    return array;
}
-(NSArray * )BOSSelectAccountWhereChainId:(NSString *)chainId{
    NSArray * array;
    if (_database && [_database isOpened]) {
        array = [AccountListModel BOSSelectAccountWhereChainId:chainId database:_database];
    }else{
        [self creatDatabase];
        array = [AccountListModel BOSSelectAccountWhereChainId:chainId database:_database];
    }
    return array;
}
-(NSArray * )BOSSelectAccountWhereContract:(NSString *)contract{
    NSArray * array;
    if (_database && [_database isOpened]) {
        array = [AccountListModel BOSSelectAccountWhereContract:contract database:_database];
    }else{
        [self creatDatabase];
        array = [AccountListModel BOSSelectAccountWhereContract:contract database:_database];
    }
    return array;
}
-(NSArray * )BOSSelectAccountWhereCreatTimestampAsc:(BOOL)asc{
    NSArray * array;
    if (_database && [_database isOpened]) {
        array = [AccountListModel BOSSelectAccountWhereCreatTimestampAsc:asc database:_database];
    }else{
        [self creatDatabase];
        array = [AccountListModel BOSSelectAccountWhereCreatTimestampAsc:asc database:_database];
    }
    return array;
}
-(NSArray * )BOSSelectAccountWhereIsBackup:(BOOL)isBackup{
    NSArray * array;
    if (_database && [_database isOpened]) {
        array = [AccountListModel BOSSelectAccountWhereIsBackup:isBackup database:_database];
    }else{
        [self creatDatabase];
        array = [AccountListModel BOSSelectAccountWhereIsBackup:isBackup database:_database];
    }
    return array;
}
#pragma mark  🐷 HistoryAccountModel 红包历史 🐷
-(BOOL)BOSDeleteHistoryModelWhereAccountId:(NSString *)accountId{
    BOOL result = NO;
    if (_database && [_database isOpened]) {
        result = [HistoryAccountModel BOSDeleteWhereAccountId:accountId database:_database];
    }else{
        [self creatDatabase];
        result = [HistoryAccountModel BOSDeleteWhereAccountId:accountId database:_database];
    }
    return result;
}
@end
