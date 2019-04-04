////  ImportCloudListViewController.h
//  BOS
//
//  Created by BOS on 2018/12/19.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ImportCloudListViewController : BaseViewController
@property(nonatomic,strong)NSMutableArray * dataArray;
@end


@interface ImportCloudListTitleView : UIView
@property(nonatomic,strong)UIButton * selelctButton;
@property(nonatomic,strong)UILabel * hintLabel;
@property(nonatomic,copy)void(^batchImportBlock)(UIButton * button);
@end
NS_ASSUME_NONNULL_END
