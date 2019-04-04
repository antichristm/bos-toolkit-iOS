////  RedPacketOpenViewController.h
//  BOS
//
//  Created by BOS on 2018/12/29.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RedPacketOpenViewController : UIViewController
@property (nonatomic, copy) NSString *redString;
@property (nonatomic, strong) AccountListModel *reciverModel;
@property (nonatomic, strong) NSDictionary *dict;

@end

NS_ASSUME_NONNULL_END
