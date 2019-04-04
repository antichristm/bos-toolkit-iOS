////  BaseTabBarController.m
//  BOS
//
//  Created by BOS on 2018/12/11.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import "BaseTabBarController.h"

@interface BaseTabBarController ()
@property (nonatomic, strong) NSMutableArray *tabBarItems;
@end

@implementation BaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UITabBar appearance] setBarTintColor:COLOR(@"#FFFFFF")];
    self.tabBar.translucent = NO;
    
    [self addChildViewControllers];
}

- (NSMutableArray *)tabBarItems
{
    if (!_tabBarItems) {
        _tabBarItems = [NSMutableArray array];
    }
    return _tabBarItems;
}
-(void)addChildViewControllers
{

    [self addChildViewController:[AccountListViewController new] withTitle:NSLocalizedString(@"账户", nil) normalImage:[UIImage originalImageNamed:@"me_icon_zhanghu_default"] pressedImage:[UIImage originalImageNamed:@"me_icon_zhanghu_xuanzhong"]];
    [self addChildViewController:[PersonViewController new] withTitle:NSLocalizedString(@"个人", nil) normalImage:[UIImage originalImageNamed:@"me_icon_geren_default"] pressedImage:[UIImage originalImageNamed:@"me_icon_geren_xuanzhong"]];
}

-(void)addChildViewController:(UIViewController *)childController withTitle:(NSString *)title  normalImage:(UIImage *)normalImage
                 pressedImage:(UIImage *)pressedImage
{
    
    childController.tabBarItem.image = normalImage;
    childController.tabBarItem.selectedImage = pressedImage;
    childController.title = title;
    [childController.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObject:COLOR(@"#277EFD") forKey:NSForegroundColorAttributeName] forState:UIControlStateSelected];
    [childController.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObject:COLOR(@"#A2AAB6") forKey:NSForegroundColorAttributeName] forState:UIControlStateNormal];
    
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:childController];
    
    [self addChildViewController:nav];
}
-(void)dealloc{
    NSLog(@"%@ 销毁 >_<! ",self.class);
}
@end
