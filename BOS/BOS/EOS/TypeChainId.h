//
//  TypeChainId.h
//  Starteos
//
//  Created by 梁唐 on 2018/10/25.
//  Copyright © 2018 liangtang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TypeChainId : NSObject
- (const void *)getBytes ;
- (const NSData *)chainId;
@end

NS_ASSUME_NONNULL_END
