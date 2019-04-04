////  PermissionChangeViewController.h
//  BOS
//
//  Created by BOS on 2018/12/13.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PermissionChangeViewController : BaseViewController
@property (nonatomic, strong) AccountListModel *currentModel;
@property (nonatomic, copy) NSString *permissionTitle;
@property (nonatomic, copy) NSString *permissionName;
@property (nonatomic, copy) NSString *permissionKey;
@property (nonatomic, strong) required_auth *permissionAuth;

@end

NS_ASSUME_NONNULL_END
