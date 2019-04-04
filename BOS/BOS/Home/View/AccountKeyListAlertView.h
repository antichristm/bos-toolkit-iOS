////  AccountKeyListAlertView.h
//  BOS
//
//  Created by BOS on 2018/12/27.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN


/**
 账户公钥列表 是一个弹窗
 */
@interface AccountKeyListAlertView : UIView
/**
 弹框标题
 */
@property (nonatomic, copy) NSString *titleString;
/**
 确定按钮的文字
 */
@property (nonatomic, copy) NSString *sureString;
/**
 确定按钮的颜色
 */
@property (nonatomic, strong) UIColor *sureColor;
/**
 列表数组
 */
@property (nonatomic, strong) NSArray *dataArr;
/**
 是否是多选
 */
@property (nonatomic, assign) BOOL isMutable;
/**
 selectArray 选中的下标组合
 */
@property(nonatomic,copy)void(^Block)(NSArray * selectArray);

- (void)showView;

- (void)hiddenView;

@end

@interface accountKeyListAlertCell : BaseTableViewCell
@property(nonatomic,strong)NSNumber * permissionWidth;
@property(nonatomic,copy)NSString * title;
@property(nonatomic,copy)NSString * permission;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UIView *line;

@end



NS_ASSUME_NONNULL_END
