////  RedPacketBosCreateAccountViewController.h
//  BOS
//
//  Created by BOS on 2019/1/4.
//  Copyright © 2019年 BOS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 通过bos创建账户
 */
@interface RedPacketBosCreateAccountViewController : UIViewController

@property (nonatomic, copy) NSString *memo;
@property (nonatomic, copy) NSString *privateKey;

@end

NS_ASSUME_NONNULL_END
