////  UINavigationController+Tools.m
//  BOS
//
//  Created by BOS on 2018/12/11.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import "UINavigationController+Tools.h"
#import <objc/runtime.h>
static char * currentStyleKey = "currentStyleKey";

@implementation UINavigationController (Tools)
#pragma mark -- Setter and getter
-(void)setCurrentStyle:(UIStatusBarStyle)currentStyle{
    NSNumber * value = [NSNumber numberWithInteger:currentStyle];
    objc_setAssociatedObject(self, &currentStyleKey, value, OBJC_ASSOCIATION_ASSIGN);
}
-(UIStatusBarStyle)currentStyle{
    NSNumber * value = objc_getAssociatedObject(self, &currentStyleKey);
    return value.integerValue;
}
#pragma mark -- Public method
-(void)changeCurrentStatusBarStyle:(UIStatusBarStyle)style{
    self.currentStyle = style;
    [self setNeedsStatusBarAppearanceUpdate];
}
-(void)changeNavigationBarBackgroundImage:(UIColor *)color{
    CGFloat  r = 0 , g = 0 , b = 0 , a = 0;
    if ([self respondsToSelector:@selector(getRed:green:blue:alpha:)]) {
        [color getRed:&r green:&g blue:&b alpha:&a];
    }else{
        const CGFloat *component = CGColorGetComponents(color.CGColor);
        r = component[0];
        g = component[1];
        b = component[2];
        a = component[3];
    }
    [self.navigationBar setBackgroundImage:[BOSTools CreateImageWithColor:color] forBarMetrics:UIBarMetricsDefault];
    if (a == 0.0) {
        [self.navigationBar setShadowImage:[UIImage new]];
    }else{
        [self.navigationBar setShadowImage:nil];
    }
}
#pragma mark -- Overwrite
-(UIStatusBarStyle)preferredStatusBarStyle{
    return self.currentStyle;
}
@end
