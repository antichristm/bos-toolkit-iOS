////  AccountManagerModel.m
//  BOS
//
//  Created by BOS on 2018/12/11.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import "AccountManagerModel.h"

@implementation AccountManagerModel
+(instancetype)initModelWithObject:(id)object{
    AccountManagerModel * model = [AccountManagerModel mj_objectWithKeyValues:object];
    return model;
}
-(void)setTitle:(NSString *)title{
    _title = NSLocalizedString(title, nil);
}
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"ID" : @"id"
             };   
}
@end
