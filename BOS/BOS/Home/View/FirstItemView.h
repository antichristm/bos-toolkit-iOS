////  FirstItemView.h
//  BOS
//
//  Created by BOS on 2018/12/13.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FirstItemView : UIView
@property(nonatomic,strong)UIImageView * leftImageView;
@property(nonatomic,strong)UIImageView * rightImageView;
@property(nonatomic,strong)UILabel * titleLabel;
@property(nonatomic,copy)void(^firstItemTapBlock)(FirstItemView * view);
@end

NS_ASSUME_NONNULL_END
