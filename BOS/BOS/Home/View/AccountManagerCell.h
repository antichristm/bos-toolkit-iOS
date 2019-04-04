////  AccountManagerCell.h
//  BOS
//
//  Created by BOS on 2018/12/11.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AccountManagerCell : UITableViewCell
@property(nonatomic,strong)AccountManagerModel * model;
+(instancetype)initWithTableView:(UITableView * )tableView cellID:(NSString *)cellID;
@end

NS_ASSUME_NONNULL_END
