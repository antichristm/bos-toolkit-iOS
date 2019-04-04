////  SecretQuestionTableViewCell.h
//  BOS
//
//  Created by BOS on 2018/12/17.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import "FieldTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface SecretQuestionTableViewCell : FieldTableViewCell
@property (nonatomic, strong) UIButton *rightBtn;

@property (nonatomic, assign) NSInteger cellIndex;

/**
 问题数组
 */
@property (nonatomic, strong) NSArray *questionArr;

@end

NS_ASSUME_NONNULL_END
