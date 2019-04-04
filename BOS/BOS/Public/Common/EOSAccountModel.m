////  EOSAccountModel.m
//  BOS
//
//  Created by BOS on 2018/12/24.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import "EOSAccountModel.h"
#define Owner @"owner"
#define Active @"active"
@implementation EOSAccountModel
+(instancetype)initModelWithObject:(id)object{
    EOSAccountModel * model = [EOSAccountModel mj_objectWithKeyValues:object];
    
    return model;
}
+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"permissions":@"permissionsItem",
             };
}
-(NSArray <NSDictionary *>*)verificationKeyWithPublic:(NSString *)publicKey{
    
    @try {
        NSMutableArray * temp = [NSMutableArray array];
        for (permissionsItem * item in self.permissions) {
            for (keysItem * keyitem in item.required_auth.keys) {
                if ([publicKey isEqualToString:keyitem.key]) {
                    NSDictionary * keyInfo = @{
                                               @"perm_name" : item.perm_name,
                                               @"threshold" : [NSNumber numberWithInteger:item.required_auth.threshold],
                                               @"weight" : [NSNumber numberWithInteger:keyitem.weight],
                                               @"key" : keyitem.key
                                               };
                    [temp addObject:keyInfo];
                }
            }
        }
        return temp;
    } @catch (NSException *exception) {
        NSLog(@"验证权限报错--->%@",exception);
    } @finally {}
}
-(NSArray <NSString *>*)getPermissionNamesWithPublicKey:(NSString *)key{
    @try {
        NSArray *  permissions = [self verificationKeyWithPublic:key];
        NSArray * perm_names = [permissions valueForKey:@"perm_name"];
        return perm_names;
    } @catch (NSException *exception) {
        NSLog(@"error -- %@",exception);
    } @finally {}
}
-(NSString *)getFirstPermissionPublicKey:(NSString *)key{
    NSArray * names = [self getPermissionNamesWithPublicKey:key];
    NSString * name ;
    if ([names containsObject:Owner]) {
        name = Owner;
    }else if([names containsObject:Active]){
        name = Active;
    }else{
        name = names.firstObject?:@"";
    }
    return name;
}
@end


@implementation net_limit
@end


@implementation cpu_limit
@end


@implementation keysItem
@end


@implementation accountsItem
@end


@implementation waitsItem
@end


@implementation required_auth
+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"keys":@"keysItem",
             @"accounts":@"accountsItem",
             @"waits":@"waitsItem"
             };
}
@end


@implementation permissionsItem
@end


@implementation total_resources
@end


@implementation self_delegated_bandwidth
@end


@implementation voter_info
@end



