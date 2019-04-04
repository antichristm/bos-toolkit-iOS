////  AccountManagerViewController.h
//  BOS
//
//  Created by BOS on 2018/12/11.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AccountManagerViewController : BaseViewController
@property(nonatomic,strong)AccountListModel * currentModel;
@end

@interface AccountManagerNaviView : UIView
@property(nonatomic,strong)UIButton * backButton;
@property(nonatomic,strong)UILabel  * titleLabel;
@property(nonatomic,copy)void(^accountManagerBackBlock)(UIButton * button);
+(instancetype)initAccountManagerNaviView;
@end
NS_ASSUME_NONNULL_END
