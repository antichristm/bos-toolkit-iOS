////  HistoryAccountModel+WCTTableCoding.h
//  BOS
//
//  Created by BOS on 2019/1/4.
//  Copyright © 2019年 BOS. All rights reserved.
//

#import "HistoryAccountModel.h"
#import <WCDB/WCDB.h>
NS_ASSUME_NONNULL_BEGIN

@interface HistoryAccountModel (WCTTableCoding)<WCTTableCoding>
WCDB_PROPERTY(accountName)
WCDB_PROPERTY(privateKey)
WCDB_PROPERTY(publicKey)
WCDB_PROPERTY(accountId)

+(BOOL)BOSDeleteWhereAccountId:(NSString *)accountId database:(WCTDatabase*)database;

@end

NS_ASSUME_NONNULL_END
