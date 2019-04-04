////  CreatAccountModel.h
//  BOS
//
//  Created by BOS on 2018/12/12.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CreatAccountModel : BaseModel
@property(nonatomic,copy)NSString * psd1;
@property(nonatomic,copy)NSString * psd2;
@property(nonatomic,copy)NSString * remark;
@end

NS_ASSUME_NONNULL_END
