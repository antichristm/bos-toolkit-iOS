////  RedPacketCreateAccountViewController.h
//  BOS
//
//  Created by BOS on 2018/12/17.
//  Copyright © 2018 BOS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RedPacketCreateAccountViewController : BaseViewController

/**
 红包串
 */
@property (nonatomic, copy) NSString *redString;
@property (nonatomic, assign) BOOL isFrist;
@end

NS_ASSUME_NONNULL_END
