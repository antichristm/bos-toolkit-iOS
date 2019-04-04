////  AccountManagerModel.h
//  BOS
//
//  Created by BOS on 2018/12/11.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AccountManagerModel : BaseModel
@property(nonatomic,copy)NSString * title;
@property(nonatomic,copy)NSString * leftImg;
@property(nonatomic,copy)NSString * rightImg;
@property(nonatomic,strong)NSNumber * ID;
@end

NS_ASSUME_NONNULL_END
