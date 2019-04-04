////  RedPacketShareViewController.h
//  BOS
//
//  Created by BOS on 2019/1/3.
//  Copyright © 2019年 BOS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 展示红包串
 */
@interface RedPacketShareViewController : UIViewController
@property (nonatomic, copy) NSString *message;
@property (nonatomic, strong) AccountListModel *selectModel;
@end

NS_ASSUME_NONNULL_END
