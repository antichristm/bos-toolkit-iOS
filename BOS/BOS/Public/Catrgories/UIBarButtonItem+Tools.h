////  UIBarButtonItem+Tools.h
//  BOS
//
//  Created by BOS on 2018/12/12.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIBarButtonItem (Tools)
+(instancetype _Nonnull)BarButtonItemWithImageName:(UIImage * __nullable)image highImageName:(UIImage * __nullable)highImage title:(NSString * __nullable)title target:(id  _Nonnull )target action:(SEL _Nonnull)action  titleinset:(UIEdgeInsets)titleinset imginset:(UIEdgeInsets)imginset;
@end

NS_ASSUME_NONNULL_END
