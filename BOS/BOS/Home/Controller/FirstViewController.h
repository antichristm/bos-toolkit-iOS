////  FirstViewController.h
//  BOS
//
//  Created by BOS on 2018/12/13.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FirstViewController : BaseViewController

@end

@interface FirstTitleView : UIView
@property(nonatomic,strong)UIImageView * titleImageView;
@property(nonatomic,strong)UILabel  * titleLabel;
@property(nonatomic,strong)YYLabel  * descLabel;
@end

NS_ASSUME_NONNULL_END
