////  EOSKeyModel.h
//  BOS
//
//  Created by BOS on 2018/12/11.
//  Copyright © 2018 BOS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EOSKeyModel : NSObject

@property (nonatomic, strong) NSString *privateKey;

@property (nonatomic, strong) NSString *publicKey;

@end

NS_ASSUME_NONNULL_END
