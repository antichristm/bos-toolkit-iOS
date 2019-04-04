////  BaseNavigationController.m
//  BOS
//
//  Created by BOS on 2018/12/11.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationBar setBackgroundImage:[BOSTools CreateImageWithColor:SUBJECTCOLOR] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:NAVIBARCOLOR,NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Medium" size:16]}];
    self.interactivePopGestureRecognizer.enabled = YES;
    
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        UINavigationItem *item= [viewController navigationItem];
        item.leftBarButtonItem = [UIBarButtonItem BarButtonItemWithImageName:IMAGE(@"icon_back") highImageName:nil title:@"" target:self action:@selector(backAction:) titleinset:UIEdgeInsetsZero imginset:UIEdgeInsetsMake(0, -BOS_W(30), 0, 0)];
        
    }
    [super pushViewController:viewController animated:animated];
}
-(void)backAction:(UIButton *)btn{
    [self popViewControllerAnimated:YES];
}
@end
