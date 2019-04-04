////  EOSActionModel.h
//  BOS
//
//  Created by BOS on 2018/12/11.
//  Copyright © 2018 BOS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EOSActionModel : NSObject

@property(nonatomic, strong) NSString *binargs;
@property(nonatomic, strong) NSDictionary *action;
@property(nonatomic, assign) NSInteger index;

@end

NS_ASSUME_NONNULL_END
