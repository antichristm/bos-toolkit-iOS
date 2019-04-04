////  RedPacketAccountHistoryTableViewCell.h
//  BOS
//
//  Created by BOS on 2019/1/4.
//  Copyright © 2019年 BOS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 创建历史的cell
 */

@protocol RedPacketAccountHistoryDelegate <NSObject>

- (void)RedPacketAccountHistoryDelete:(NSInteger)index;

- (void)RedPacketAccountHistoryCheck:(NSInteger)index;

@end
@interface RedPacketAccountHistoryTableViewCell : BaseTableViewCell
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *chekButton;
@property (nonatomic, strong) UIButton *deleteButton;


@property (nonatomic, copy) NSString *titleString;
@property (nonatomic, copy) NSString *timeString;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) id<RedPacketAccountHistoryDelegate> delegate;

@end

@interface RedPacketHBHistoryTableViewCell : RedPacketAccountHistoryTableViewCell


@end



NS_ASSUME_NONNULL_END
