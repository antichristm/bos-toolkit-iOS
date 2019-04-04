////  UINavigationController+Tools.h
//  BOS
//
//  Created by BOS on 2018/12/11.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (Tools)
@property(nonatomic,assign)UIStatusBarStyle currentStyle;
-(void)changeCurrentStatusBarStyle:(UIStatusBarStyle)style;
-(void)changeNavigationBarBackgroundImage:(UIColor *)color;
@end

NS_ASSUME_NONNULL_END
