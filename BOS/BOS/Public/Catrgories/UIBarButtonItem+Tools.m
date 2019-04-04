////  UIBarButtonItem+Tools.m
//  BOS
//
//  Created by BOS on 2018/12/12.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import "UIBarButtonItem+Tools.h"

@implementation UIBarButtonItem (Tools)
+(instancetype _Nonnull)BarButtonItemWithImageName:(UIImage * __nullable)image highImageName:(UIImage * __nullable)highImage title:(NSString * __nullable)title target:(id  _Nonnull )target action:(SEL _Nonnull)action  titleinset:(UIEdgeInsets)titleinset imginset:(UIEdgeInsets)imginset{
    
    UIButton *button = [[UIButton alloc] init];
    button.frame = CGRectMake(0, 0, 44, 44);
    [button setTitleEdgeInsets:titleinset];
    [button setImageEdgeInsets:imginset];
    button.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    
    if (image) {
        [button setImage:image forState:UIControlStateNormal];
    }
    if (highImage) {
        [button setImage:highImage forState:UIControlStateHighlighted];
    }
    if (title) {
        [button setTitle:title forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    }
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[self alloc] initWithCustomView:button];
}
@end
