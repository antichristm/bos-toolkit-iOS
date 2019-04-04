//
//  BaseViewController.m
//  BOS
//
//  Created by 梁唐 on 2018/12/11.
//  Copyright © 2018 lingling. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
#pragma mark -- Public method
-(void)changeStatusBarStyle:(UIStatusBarStyle)style{
    self.currentStyle = style;
    [self setNeedsStatusBarAppearanceUpdate];
}

#pragma mark -- Overwrite
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return self.currentStyle;
}
-(void)dealloc{
    NSLog(@"%@ 销毁 >_<!\n引用计数 %ld ",[self class],CFGetRetainCount((__bridge CFTypeRef)(self)));
}
@end
