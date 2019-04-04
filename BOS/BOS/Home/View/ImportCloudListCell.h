////  ImportCloudListCell.h
//  BOS
//
//  Created by BOS on 2018/12/19.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface ImportCloudListCell : BaseTableViewCell
@property(nonatomic,strong)AccountListModel * model;
@property(nonatomic,strong,readonly)UIButton * selectedButton;
+(instancetype)initWithTableView:(UITableView * )tableView cellID:(NSString *)cellID;
@end

NS_ASSUME_NONNULL_END
