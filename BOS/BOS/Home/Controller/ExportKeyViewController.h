////  exportKeyViewController.h
//  BOS
//
//  Created by BOS on 2018/12/14.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ExportKeyViewController : BaseViewController
@property (nonatomic, copy) NSString *keyStr;
@property (nonatomic, assign) BOOL isPrivate;

@end

NS_ASSUME_NONNULL_END
