////  RedPacketInputTableViewCell.h
//  BOS
//
//  Created by BOS on 2019/1/2.
//  Copyright © 2019年 BOS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 发送红包界面
 */
@interface RedPacketInputTableViewCell : BaseTableViewCell
@property (nonatomic, strong) TYLimitedTextField *inputTF;


@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *unit;
@property (nonatomic, copy) NSString *placeString;
@property (nonatomic, copy) NSString *rightViewTitle;

@end

@interface RedPacketRandomInputTableViewCell : RedPacketInputTableViewCell
@property (nonatomic, strong) UILabel *leftlabel;
@end

@interface RedPacketAccountChooseTableViewCell : RedPacketInputTableViewCell

@end

@interface RedPacketWishTableViewCell : BaseTableViewCell<TYLimitedTextViewDelegate>
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) TYLimitedTextView *textView;
@property (nonatomic, strong) UILabel *palceLabel;

@end


@interface RedPacketAlertTableViewCell : BaseTableViewCell
@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) void(^block)(void);
@end

NS_ASSUME_NONNULL_END
