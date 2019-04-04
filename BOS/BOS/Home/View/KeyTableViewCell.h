////  KeyTableViewCell.h
//  BOS
//
//  Created by BOS on 2018/12/13.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^KeyBlock)(NSInteger index);
typedef void(^SingleKeyBlock)(NSString * title ,NSString * detail);
/**
 公私钥生成及展示界面
 */

/**
权限设置界面单个权限cell 输入框不可输入
 */
@interface SingleKeyTableViewCell : BaseTableViewCell
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) TYLimitedTextView *textview;

@property (nonatomic, copy) NSString *titleString;
@property (nonatomic, copy) NSString *detailString;
@property (nonatomic, copy) NSString *placeString;
@property (nonatomic, copy) NSString *rightBtnString;
@property (nonatomic, strong) SingleKeyBlock block;


@end

/**
 原权限修改界面权限展示界面
 */
@interface KeyTableViewCell : BaseTableViewCell

@property (nonatomic, strong) TYLimitedTextView *textviewOne;
@property (nonatomic, strong) TYLimitedTextView *textviewTwo;

@property (nonatomic, copy) NSString *titleOne;
@property (nonatomic, copy) NSString *titleTwo;
@property (nonatomic, copy) NSString *textOne;
@property (nonatomic, copy) NSString *textTwo;
@property (nonatomic, copy) KeyBlock block;
@end


/**
 重新生成公私钥界面
 */
@interface CreateKeyTableViewCell : KeyTableViewCell

@end




NS_ASSUME_NONNULL_END
