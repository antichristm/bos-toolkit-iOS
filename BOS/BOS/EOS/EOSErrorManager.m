////  EOSErrorManager.m
//  BOS
//
//  Created by BOS on 2018/12/12.
//  Copyright © 2018 BOS. All rights reserved.
//

#import "EOSErrorManager.h"

@implementation EOSErrorManager

+ (NSError *)errorWithErrorCode:(NSInteger)errorCode {
    NSString *errorMessage;
    
    switch (errorCode) {
        case 3010001:
            errorMessage = @"账户名格式1-12位（a-z，1-5，“.” ) 且”.”不能在首尾";
            break;
        case 3010004:
            errorMessage = @"无效的权限";
            break;
        case 3010008:
            errorMessage = @"无效的区块";
            break;
        case 3010010:
            errorMessage = @"请检查参数是否正确";
            break;
        case 3010011:
            errorMessage = @"检查资产格式是否正确";
            break;
        case 3030000:
            errorMessage = @"区块异常";
            break;
        case 3030008:
            errorMessage = @"请检查签名";
            break;
        case 3040000:
            errorMessage = @"交易异常";
            break;
        case 3040005:
            errorMessage = @"交易过期，过期时间可以设置长一点";
            break;
        case 3040006:
            errorMessage = @"过期时间设置太长";
            break;
        case 3040007:
            errorMessage = @"引用块无效或不匹配";
            break;
        case 3050000:
            errorMessage = @"检查Action是否正确";
            break;
            
        case 3050001:
            errorMessage = @"账户名已存在";
            break;
        case 3050002:
            errorMessage = @"请检查参数";
            break;
        case 3050003:
            errorMessage = @"账户不存在，资产金额不正确等";
            break;
        case 3080001:
            errorMessage = @"RAM不足,请购买一些RAM";
            break;
        case 3080002:
            errorMessage = @"NET不足,请抵押一些NET";
            break;
        case 3080004:
            errorMessage = @"CPU不足,请抵押一些CPU";
            break;
        case 3080006:
            errorMessage = @"交易时间太长";
            break;
        case 3081001:
            errorMessage = @"交易所需的CPU超过了限定值";
            break;
        case 3090003:
            errorMessage = @"请检查权限，签名等是否正确";
            break;
        case 3090004:
            errorMessage = @"缺少所需权限";
            break;
        default:
            errorMessage = @"请检查网络、节点、账号资源、权限和余额后重新尝试";
            break;
    }
    return [NSError errorWithDomain:NSURLErrorDomain
                               code:errorCode
                           userInfo:@{ NSLocalizedDescriptionKey: NSLocalizedString(errorMessage, nil)}];
}

@end
