////  RedPacketAlertView.h
//  BOS
//
//  Created by BOS on 2019/1/7.
//  Copyright © 2019年 BOS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 领取红包的弹框界面
 */
@interface RedPacketAlertView : UIView


@property (nonatomic, copy) NSString *redString;//红包串
@property (nonatomic, strong) void(^redPacketBlock)(void);

+(RedPacketAlertView *)share;
-(void)ShowView;
-(void)HiddenView;
@end

NS_ASSUME_NONNULL_END
