////  PassWorldView.h
//  BOS
//
//  Created by BOS on 2018/12/14.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 密码输入框
 */

@protocol PassWorldViewDelegate <NSObject>

-(void)PassWorldViewWithPassworld:(NSString *)passworld;

@end

@interface PassWorldView : UIView

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *password;
@property(nonatomic,assign)BOOL isShowForget;
@property(nonatomic,copy)void(^passwordBlock)(NSString * password);
@property (nonatomic, weak) id delegate;


- (void)showView;

- (void)hiddenView;

@end

NS_ASSUME_NONNULL_END
