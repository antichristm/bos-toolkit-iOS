////  exportAlertViewController.h
//  BOS
//
//  Created by BOS on 2018/12/14.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 导出私钥提示框
 */
@interface ExportAlertViewController : BaseViewController
@property(nonatomic,copy)NSString * key;
@property (nonatomic, assign) BOOL isprivate;

@end

NS_ASSUME_NONNULL_END
