////  HistoryAccountModel.h
//  BOS
//
//  Created by BOS on 2019/1/4.
//  Copyright © 2019年 BOS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HistoryAccountModel : NSObject

@property (nonatomic, copy) NSString *accountName;
@property (nonatomic, copy) NSString *privateKey;
@property (nonatomic, copy) NSString *publicKey;
@property (nonatomic, copy) NSString *accountId;


@end

NS_ASSUME_NONNULL_END
