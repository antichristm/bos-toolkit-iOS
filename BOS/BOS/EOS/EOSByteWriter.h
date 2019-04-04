//
//  EOSByteWriter.h
//  Starteos
//
//  Created by 梁唐 on 2018/10/10.
//  Copyright © 2018 liangtang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TypeChainId.h"
#import "NSObject+Extension.h"

@interface EOSByteWriter : NSObject

- (instancetype)initWithCapacity:(int) capacity ;

- (void)ensureCapacity:(int)capacity ;

- (void)put:(Byte)b ;

- (void)putShortLE:(short)value ;

- (void)putIntLE:(int)value ;

- (void)putLongLE:(long)value ;

- (void)putBytes:(NSData *)value ;

- (NSData *)toBytes ;

- (int)length ;

- (void)putString:(NSString *)value ;

- (void)putCollection:(NSArray *)collection ;

- (void)putVariableUInt:(long)val ;

+ (NSData *)getBytesForSignatureActions:(NSData *)chainId andParams:(NSDictionary *)paramsDic andCapacity:(int)capacity;
@end
