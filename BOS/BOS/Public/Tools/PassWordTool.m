////  PassWordTool.m
//  BOS
//
//  Created by BOS on 2018/12/17.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import "PassWordTool.h"
@implementation PassWordTool
static NSString * const KEY_IN_KEYCHAIN = @"bos.keychainkey";
static NSString * const KEY_PASSWORD = @"bos.passwordkey";
static NSString * const KEY_QUESTION = @"bos.question";
static NSString * const KEY_VERIFY = @"bos.verify";
+(BOOL)savePassWord:(NSString *)password{
    NSString * uuid = [[[UIDevice currentDevice]identifierForVendor]UUIDString];
    NSString * enPassword = [[EOSTools shared]EncryptWith:password password:uuid];
    return  [SAMKeychain setPassword:enPassword forService:KEY_IN_KEYCHAIN account:KEY_PASSWORD];
}
+(NSString *)readPassWord{
    NSString * content = [SAMKeychain passwordForService:KEY_IN_KEYCHAIN account:KEY_PASSWORD];
    NSString * uuid = [[[UIDevice currentDevice]identifierForVendor]UUIDString];
    NSString * deContent = [[EOSTools shared]DecryptWith:content password:uuid];
    return deContent;
}
+(BOOL)deletePassWord{
    return  [SAMKeychain deletePasswordForService:KEY_IN_KEYCHAIN account:KEY_PASSWORD];
}
+(BOOL)saveSecuritQuestion:(NSString *)question{
    NSString * uuid = [[[UIDevice currentDevice]identifierForVendor]UUIDString];
    NSString * enPassword = [[EOSTools shared]EncryptWith:question password:uuid];
    return  [SAMKeychain setPassword:enPassword forService:KEY_IN_KEYCHAIN account:KEY_QUESTION];
}

+(NSString *)readSecuritQuestion{
    NSString * content = [SAMKeychain passwordForService:KEY_IN_KEYCHAIN account:KEY_QUESTION];
    NSString * uuid = [[[UIDevice currentDevice]identifierForVendor]UUIDString];
    NSString * deContent = [[EOSTools shared]DecryptWith:content password:uuid];
    return deContent;
}
+(BOOL)deleteSecuritQuestion{
    return  [SAMKeychain deletePasswordForService:KEY_IN_KEYCHAIN account:KEY_QUESTION];
}

+(BOOL)saveSecuritVerify:(NSString *)verify{
    NSString * uuid = [[[UIDevice currentDevice]identifierForVendor]UUIDString];
    NSString * enPassword = [[EOSTools shared]EncryptWith:verify password:uuid];
    return  [SAMKeychain setPassword:enPassword forService:KEY_IN_KEYCHAIN account:KEY_VERIFY];
}
+(NSString *)readSecuritVerify{
    NSString * content = [SAMKeychain passwordForService:KEY_IN_KEYCHAIN account:KEY_VERIFY];
    NSString * uuid = [[[UIDevice currentDevice]identifierForVendor]UUIDString];
    NSString * deContent = [[EOSTools shared]DecryptWith:content password:uuid];
    return deContent;
}
+(BOOL)deleteSecuritVerify{
    return  [SAMKeychain deletePasswordForService:KEY_IN_KEYCHAIN account:KEY_VERIFY];
}
+(BOOL)verifyPassword:(NSString *)password{
    NSString * result = [[EOSTools shared]DecryptWith:[PassWordTool readSecuritVerify] password:password];
    if (result && result.length > 0 && [result isEqualToString:BOSPassSubstitute]) {
        return YES;
    }else{
        return NO;
    }
}
+(BOOL)isExist{
    NSString * password = [PassWordTool readPassWord];
    NSString * question = [PassWordTool readSecuritQuestion];
    NSString * verify = [PassWordTool readSecuritVerify];
    if (password && question && verify && password.length > 0 && question.length > 0 && verify.length > 0) {
        return YES;
    }else{
        return NO;
    }
}
@end
