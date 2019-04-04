////  PassWorldView.m
//  BOS
//
//  Created by BOS on 2018/12/14.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import "PassWorldView.h"

@interface PassWorldView()<TYLimitedTextFieldDelegate>

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UIButton *sureButton;
@property(nonatomic,copy)NSString * passWordHint;
/**
 输入框
 */
@property (nonatomic, strong) TYLimitedTextField * field;

/**
 密保提示
 */
@property (nonatomic, strong) UIButton *forgetButton;//忘记密码


@end

@implementation PassWorldView

- (instancetype)init{
    if (self = [super init]) {
        self.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight);
        [self createUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

-(void)sureClick{
    [self endEditing:YES];
    if ( self.field.text.length < 1) {
        [XWHUDManager showTipHUD:NSLocalizedString(@"密码错误", nil)];
        return;
    }else{
        [self hiddenView];
        if ([self.delegate respondsToSelector:@selector(PassWorldViewWithPassworld:)] && self.field.text.length > 0) {
            [self.delegate PassWorldViewWithPassworld:self.field.text];
        }
        if (self.passwordBlock && self.field.text.length > 0) {
            self.passwordBlock(self.field.text);
        }
        self.field.text = @"";
    }
   
}

-(void)forgetClick{
    if (self.passWordHint) {
        [XWHUDManager showTipHUD:self.passWordHint];
    }
}

- (void)showView {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [KeyWindow addSubview:self];
        [self creatShowAnimation];
    });
}

- (void)creatShowAnimation{
    WeakSelf(weakSelf);
    
//    [UIView animateWithDuration:0.35 animations:^{
//        weakSelf.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
//    } completion:^(BOOL finished) {
//         weakSelf.backgroundColor =  [UIColor colorWithWhite:0.2 alpha:0.5];
//    }];
    [weakSelf.field becomeFirstResponder];
}

- (void)hiddenClick{
    self.field.text = nil;
    [self endEditing:YES];
    [self hiddenView];
}

- (void)hiddenView {
    WeakSelf(weakSelf);
    NSLog(@"结束---");
      self.backgroundColor =  [UIColor clearColor];
    [UIView animateWithDuration:0.35 animations:^{
        weakSelf.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight);
    } completion:^(BOOL finished) {
        [weakSelf endEditing:YES];
        [weakSelf removeFromSuperview];
    }];
}

- (void)keyboardShow:(NSNotification *)notification {
    //滑动效果（动画）
    WeakSelf(weakSelf);
    NSValue * rectValue = notification.userInfo[@"UIKeyboardBoundsUserInfoKey"];
    CGRect rect = rectValue.CGRectValue;
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard"  context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动，以使下面腾出地方用于软键盘的显示
    
    self.frame = CGRectMake(0.0f, - rect.size.height, self.frame.size.width, self.frame.size.height);
    
    [UIView commitAnimations];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         weakSelf.backgroundColor =  [UIColor colorWithWhite:0.2 alpha:0.5];
    });
}
- (void)keyboardHidden:(NSNotification *)notification {
    //滑动效果
    NSTimeInterval animationDuration = 0.20f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //恢复屏幕
    self.frame = CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height);
    
    [UIView commitAnimations];
}

- (BOOL)limitedTextFieldShouldReturn:(UITextField *)textField{
    [self endEditing:YES];
    return YES;
}
//- (void)limitedTextFieldDidEndEditing:(UITextField *)textField{
//    [self hiddenView];
//}


- (void)createUI {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHidden:) name:UIKeyboardWillHideNotification object:nil];
//    self.backgroundColor = [COLOR(@"000000") colorWithAlphaComponent:0.3];
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.backView];
    [self.backView addSubview:self.titleLabel];
    [self.backView addSubview:self.field];
    [self.backView addSubview:self.closeBtn];
    [self.backView addSubview:self.forgetButton];
    [self.backView addSubview:self.sureButton];
    WeakSelf(weakSelf);
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.width.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf);
        make.height.mas_equalTo(BOS_H(237) + Height_Bottom);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.backView);
        make.top.equalTo(weakSelf.backView).mas_offset(BOS_W(15));
        make.height.mas_equalTo(BOS_H(22.5));
        
    }];
    [self.field mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.backView).mas_offset(BOS_W(7));
        make.right.equalTo(weakSelf.backView).mas_offset( - BOS_W(7));
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).mas_offset(BOS_H(15));
        make.height.mas_equalTo(BOS_H(52));
        
        
    }];
    [self.forgetButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakSelf.backView).mas_offset(BOS_W(15));
        make.right.equalTo(weakSelf.backView).mas_offset(- BOS_W(15));
        make.top.equalTo(weakSelf.field.mas_bottom);
        make.height.mas_equalTo(BOS_H(35));
        make.width.mas_equalTo(80);
    }];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.backView).mas_offset(-BOS_W(7.5));
        make.centerY.equalTo(weakSelf.titleLabel);
        make.width.height.mas_offset(BOS_W(30));
    }];
    
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.backView).mas_offset(BOS_W(15));
        make.right.equalTo(weakSelf.backView).mas_offset(- BOS_W(15));
        make.top.equalTo(weakSelf.forgetButton.mas_bottom).mas_offset(BOS_W(40));
        make.height.mas_equalTo(BOS_W(43));
    }];
    
    UIView * line = [BOSTools viewWithFrame:CGRectZero color:COLOR(@"999999") cornerRadius:0 superView:self.backView];
    line.alpha = 0.2;
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.backView);
        make.top.equalTo(weakSelf.field);
        make.height.mas_equalTo(0.5);
    }];
    line = [BOSTools viewWithFrame:CGRectZero color:COLOR(@"999999") cornerRadius:0 superView:self.backView];
    line.alpha = 0.2;
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.backView).mas_offset(BOS_W(15));
        make.right.equalTo(weakSelf.backView).mas_offset(- BOS_W(15));
        make.bottom.equalTo(weakSelf.field);
        make.height.mas_equalTo(0.5);
    }];
    
}

- (UIView *)backView{
    if (!_backView) {
        _backView = [BOSTools viewWithFrame:CGRectZero color:COLOR(@"FFFFFF") cornerRadius:0 superView:nil];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, ScreenWidth, BOS_H(237) + Height_Bottom) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(15, 15)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame =CGRectMake(0, 0, ScreenWidth, BOS_H(140));
        maskLayer.path = maskPath.CGPath;
        _backView.layer.mask = maskLayer;
    }
    return _backView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [BOSTools labelWithFrame:CGRectZero font:FONT(16) color:TEXTCOLOR alpha:1 textAlignment:NSTextAlignmentCenter text:NSLocalizedString(@"账户密码验证", nil) superView:nil];
    }
    return _titleLabel;
}

- (TYLimitedTextField *)field{
    if (!_field) {
        _field = [[TYLimitedTextField alloc] initWithFrame:CGRectZero];
        _field.placeholder = NSLocalizedString(@"请输入密码", nil);
        _field.textAlignment = NSTextAlignmentLeft;
        _field.font = FONT(14);
        _field.placeholderColor = COLOR(@"8D96AC");
        _field.realDelegate = self;
        _field.limitedType = TYLimitedTextFieldTypePassword;
        _field.secureTextEntry = YES;
        _field.returnKeyType = UIReturnKeyContinue;
        
    }
    return _field;
}
- (UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [BOSTools buttonWithFrame:CGRectZero font:nil textColor:nil backColor:nil target:self action:@selector(hiddenClick) text:nil image:IMAGE(@"icon_close_default") cornerRadius:0 superView:nil];
    }
    return _closeBtn;
}
-(UIButton *)forgetButton{
    if (!_forgetButton) {
        _forgetButton = [BOSTools buttonWithFrame:CGRectZero font:FONT(11) textColor:COLOR(@"#277EFD") backColor:nil target:self action:@selector(forgetClick) text:NSLocalizedString(@"密码提示", nil) image:nil cornerRadius:0 superView:nil];
        _forgetButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        if (self.passWordHint && self.passWordHint.length > 0) {
            _forgetButton.hidden = NO;
        }else{
            _forgetButton.hidden = YES;
        }
    }
    return _forgetButton;
}
-(UIButton *)sureButton{
    if (!_sureButton) {
        _sureButton = [BOSTools buttonWithFrame:CGRectZero font:FONT(18) textColor:COLOR(@"FFFFFF") backColor:SUBJECTCOLOR target:self action:@selector(sureClick) text:NSLocalizedString(@"确认密码", nil) image:nil cornerRadius:0 superView:nil];
        _sureButton.layer.cornerRadius = 3;
        _sureButton.clipsToBounds = YES;
    }
    return _sureButton;
}
-(NSString *)passWordHint{
    if (!_passWordHint) {
        _passWordHint = UserDefaultObjectForKey(BOSPassHint);
    }
    return _passWordHint;
}
-(void)setIsShowForget:(BOOL)isShowForget{
    _isShowForget = isShowForget;
    self.forgetButton.hidden = !_isShowForget;
}

-(void)setTitle:(NSString *)title{
    _title = title;
    self.titleLabel.text = title;
}

@end
