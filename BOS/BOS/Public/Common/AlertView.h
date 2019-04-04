//
//  AlertView.h
//  Starteos
//
//  Created by Donkey on 2018/7/19.
//  Copyright © 2018年 liangtang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^AlertBlock)(NSInteger index);

@protocol AlertViewDelegate <NSObject>
-(void)AlertViewClickIndex:(NSInteger)index;
@end

//弹框文字、确认和取消按钮
@interface AlertView : UIView
@property(nonatomic,strong)NSString * titleStr;
@property(nonatomic,strong)NSString * detailStr;
@property(nonatomic,strong)NSString * sureTitle;
@property(nonatomic,strong)NSString * cancelTitle;
@property(nonatomic,strong)UIColor * cancelColor;//左边颜色
@property(nonatomic,strong)UIColor * sureColor;//右边颜色
@property(nonatomic,weak)id<AlertViewDelegate> delegate;
@property(nonatomic,assign)BOOL isAnimation;
@property(nonatomic,copy)AlertBlock block;

- (void)createUI;

-(void)justHaveSure;
-(void)ShowView;
-(void)HiddenView;

@end


@interface BackUpAlertView : AlertView
@property (nonatomic, strong) UITextView * textView;
@property (nonatomic, strong) UIButton *closeButton;

@end
