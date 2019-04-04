////  UIImage+Tools.m
//  BOS
//
//  Created by BOS on 2018/12/11.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import "UIImage+Tools.h"

@implementation UIImage (Tools)
+ (instancetype)originalImageNamed:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

+ (instancetype)stretchableImageNamed:(NSString *)imageName {
    
    UIImage *image = [UIImage imageNamed:imageName];
    
    return [image stretchableImageWithLeftCapWidth:image.size.width * 0.5
                                      topCapHeight:image.size.height * 0.5];
}
@end
