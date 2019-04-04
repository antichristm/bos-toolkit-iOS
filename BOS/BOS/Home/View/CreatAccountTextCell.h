////  CreatAccountTextCell.h
//  BOS
//
//  Created by BOS on 2018/12/12.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CreatAccountTextCell : BaseTableViewCell
@property(nonatomic,copy)void(^CreatAccountTextBlock)(CreatAccountTextCell * cell,NSString * text);

@end

NS_ASSUME_NONNULL_END
