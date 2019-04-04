////  AccountListCell.h
//  BOS
//
//  Created by BOS on 2018/12/11.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class AccountListModel;
@interface AccountListCell : BaseTableViewCell
@property(nonatomic,strong)AccountListModel * model;
+(instancetype)initWithTableView:(UITableView * )tableView cellID:(NSString *)cellID;
//子类重写
-(void)initSubViews;
@end


@interface ThirdTableviewCell : AccountListCell
/**
 显示选中状态
 */
@property (nonatomic, strong) UIButton *selectStatusButton;
@property (nonatomic, assign) BOOL isSelect;

@end

NS_ASSUME_NONNULL_END
