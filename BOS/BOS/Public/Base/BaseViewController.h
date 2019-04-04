//
//  BaseViewController.h
//  BOS
//
//  Created by 梁唐 on 2018/12/11.
//  Copyright © 2018 lingling. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : UIViewController
@property(nonatomic,assign)UIStatusBarStyle currentStyle;
-(void)changeStatusBarStyle:(UIStatusBarStyle)style;
@end

NS_ASSUME_NONNULL_END
