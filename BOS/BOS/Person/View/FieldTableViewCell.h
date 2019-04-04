////  FieldTableViewCell.h
//  BOS
//
//  Created by BOS on 2018/12/11.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface FieldTableViewCell : BaseTableViewCell
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) TYLimitedTextField *field;
/**
 地步的描述文字
 */
@property (nonatomic, strong) UILabel *tipsLabel;
/**
 默认隐藏复制按钮
 */
@property (nonatomic, strong) UIButton *rightButton;

@property (nonatomic, copy) NSString *titleString;
@property (nonatomic, copy) NSString *placeString;
@property (nonatomic, copy) NSString *tipsString;

@end

NS_ASSUME_NONNULL_END
