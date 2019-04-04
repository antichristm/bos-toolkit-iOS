////  RedPacketUseViewController.h
//  BOS
//
//  Created by BOS on 2019/1/3.
//  Copyright © 2019年 BOS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 使用红包的界面
 */
@interface RedPacketUseViewController : UIViewController
@property (nonatomic, copy) NSString *redPacketString;
/**
 需要传递给红包创建账号的界面
 */
@property (nonatomic, assign) BOOL isFrist;

@end

NS_ASSUME_NONNULL_END
