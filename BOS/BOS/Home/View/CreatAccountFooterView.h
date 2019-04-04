////  CreatAccountFooterView.h
//  BOS
//
//  Created by BOS on 2018/12/12.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CreatAccountFooterView : UIView
@property(nonatomic,copy)void(^CreatAccountFooterNextBlock)(UIButton * button);
@end

NS_ASSUME_NONNULL_END
