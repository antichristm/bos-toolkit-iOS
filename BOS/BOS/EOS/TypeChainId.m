//
//  TypeChainId.m
//  Starteos
//
//  Created by 梁唐 on 2018/10/25.
//  Copyright © 2018 liangtang. All rights reserved.
//

#import "TypeChainId.h"

@interface TypeChainId ()
{
    const NSData *mId;
}
@end

@implementation TypeChainId

- (instancetype)init {
    if (self = [super init]) {
        const Byte byte[32] = {0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00};
        mId = [NSData dataWithBytes:byte length:32];
    }
    return self;
}

- (const void *)getBytes {
    
    return [mId bytes];
}
- (const NSData *)chainId{
    
    return mId;
}

@end
