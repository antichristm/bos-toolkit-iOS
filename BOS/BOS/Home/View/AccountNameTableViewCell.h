////  AccountNameTableViewCell.h
//  BOS
//
//  Created by BOS on 2018/12/13.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface AccountNameTableViewCell : BaseTableViewCell

@property (nonatomic, copy) NSString *leftString;
@property (nonatomic, copy) NSString *rightString;
@property (nonatomic, strong) NSAttributedString *attLeftString;
@property (nonatomic, strong) NSAttributedString *attRightString;

@end

NS_ASSUME_NONNULL_END
