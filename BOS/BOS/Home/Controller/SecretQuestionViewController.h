////  SecretQuestionViewController.h
//  BOS
//
//  Created by BOS on 2018/12/17.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 密保问题
 */
@interface SecretQuestionViewController : UIViewController
@property(nonatomic,strong)CreatAccountModel * creatAccountModel;
@property(nonatomic,assign)BOSAddAccount addType;
@end

NS_ASSUME_NONNULL_END
