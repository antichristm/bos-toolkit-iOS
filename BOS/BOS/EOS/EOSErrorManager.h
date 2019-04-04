////  EOSErrorManager.h
//  BOS
//
//  Created by BOS on 2018/12/12.
//  Copyright © 2018 BOS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EOSErrorManager : NSObject

+ (NSError *)errorWithErrorCode:(NSInteger)errorCode;

@end

NS_ASSUME_NONNULL_END
