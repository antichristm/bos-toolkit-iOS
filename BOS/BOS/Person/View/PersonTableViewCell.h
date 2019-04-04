////  PersonTableViewCell.h
//  BOS
//
//  Created by BOS on 2018/12/11.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PersonTableViewCell : BaseTableViewCell

@property (nonatomic, copy) NSString *titleString;
@property (nonatomic, copy) NSString *imageString;
@property (nonatomic, strong) UIView *line;

@end

@interface TitleTableViewCell : PersonTableViewCell

@end



NS_ASSUME_NONNULL_END
