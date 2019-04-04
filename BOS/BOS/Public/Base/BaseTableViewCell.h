////  BaseTableViewCell.h
//  BOS
//
//  Created by BOS on 2018/12/11.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseTableViewCell : UITableViewCell

+ (instancetype)initWithTableView:(UITableView * )tableView ID:(NSString *)ID;

//子类重写UI创建
- (void)creatUI;

//子类重写模型赋值
- (void)configModel:(id)model;

@end

NS_ASSUME_NONNULL_END
