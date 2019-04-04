//
//  NSData+Hash.h
//  BOS
//
//  Created by 梁唐 on 2018/12/11.
//  Copyright © 2018 lingling. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface NSData (Hash)
-(NSString *) sha256;

- (NSString *)hexadecimalString;

@end
