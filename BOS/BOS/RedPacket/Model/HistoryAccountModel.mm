////  HistoryAccountModel.m
//  BOS
//
//  Created by BOS on 2019/1/4.
//  Copyright © 2019年 BOS. All rights reserved.
//

#import "HistoryAccountModel.h"
#import <WCDB/WCDB.h>
#import "HistoryAccountModel+WCTTableCoding.h"

@implementation HistoryAccountModel

WCDB_IMPLEMENTATION(HistoryAccountModel)
WCDB_SYNTHESIZE(HistoryAccountModel, accountName)
WCDB_SYNTHESIZE(HistoryAccountModel, privateKey)
WCDB_SYNTHESIZE(HistoryAccountModel, publicKey)
WCDB_SYNTHESIZE(HistoryAccountModel, accountId)

+(BOOL)BOSDeleteWhereAccountId:(NSString *)accountID database:(WCTDatabase*)database{
    BOOL result = NO;
    result = [database deleteObjectsFromTable:BOSDBHistoryAccountTableName where:HistoryAccountModel.accountId == accountID];
    return result;
}

@end
