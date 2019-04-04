//
//  AESCipher.h
//  AESCipher
//
//  Created by Welkin Xie on 8/13/16.
//  Copyright © 2016 WelkinXie. All rights reserved.
//
//  https://github.com/WelkinXie/AESCipher-iOS
//

#import <Foundation/Foundation.h>

//NSString * aesEncryptString(NSString *content, NSString *key , NSData *iv);
//NSString * aesDecryptString(NSString *content, NSString *key);

NSData * aesEncryptData(NSData *contentData, NSData *keyData , NSData *iv);
NSData * aesDecryptData(NSData *contentData, NSData *keyData , NSData * iv);


