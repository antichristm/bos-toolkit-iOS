////  RedModel.h
//  BOS
//
//  Created by BOS on 2019/1/5.
//  Copyright © 2019年 BOS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface claim : NSObject
@property (nonatomic, copy) NSString *user;
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *sig_hash;
@property (nonatomic, copy) NSString *is_create;

@end

@interface RedModel : NSObject

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *count;
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *sender;
@property (nonatomic, copy) NSString *pubkey;
@property (nonatomic, copy) NSString *greetings;
@property (nonatomic, copy) NSString *expire;
@property (nonatomic, copy) NSArray<claim *> *claims;


@end

NS_ASSUME_NONNULL_END
