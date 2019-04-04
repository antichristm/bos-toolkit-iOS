////  UIImage+Tools.h
//  BOS
//
//  Created by BOS on 2018/12/11.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Tools)
//类方法
/**
 *  根据图片名参数创建一个UIImage对象，并返回不渲染的原图
 *
 *  @param imageName 图片路径名
 *
 *  @return 没有经过渲染的原图
 */
+ (instancetype)originalImageNamed:(NSString *)imageName;

/**
 *  根据图片名参数创建一个UIImage对象，并将原图的高宽缩小1/2
 *
 *  @param imageName 图片路径名
 *
 *  @return 高宽为原图1/2的图片
 */
+ (instancetype)stretchableImageNamed:(NSString *)imageName;
@end

NS_ASSUME_NONNULL_END
