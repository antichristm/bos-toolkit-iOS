//
//  AlertView.m
//  Starteos
//
//  Created by Donkey on 2018/7/19.
//  Copyright © 2018年 liangtang. All rights reserved.
//

#import "AlertView.h"

@interface AlertView()
@property(nonatomic,strong)UIButton * backBtn;//灰色
@property(nonatomic,strong)UIView * backView;//背景
@property(nonatomic,strong)UILabel * titleLabel;//标题
@property(nonatomic,strong)UILabel * descriptLabel;//描述
@property(nonatomic,strong)UIButton * sureBtn;//确认
@property(nonatomic,strong)UIButton * cancelBtn;//取消
@property(nonatomic,strong)UILabel * sureLabel;//确认
@property(nonatomic,strong)UILabel * cancelLabel;//取消
@property(nonatomic,strong)UIView * line1;

@end

@implementation AlertView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)init{
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
      [self createUI];
    }
    return self;
}
-(void)setCancelColor:(UIColor *)cancelColor {
    _cancelColor = cancelColor;
    self.cancelLabel.textColor = cancelColor;
}
-(void)setSureColor:(UIColor *)sureColor {
    _sureColor = sureColor;
    self.sureLabel.textColor = sureColor;
}
-(void)sureClick{
    if ([self.delegate respondsToSelector:@selector(AlertViewClickIndex:)]) {
        [self.delegate AlertViewClickIndex:1];
    }
    if (self.block) {
        self.block(1);
    }
    [self HiddenView];
}
-(void)cancelClick{
    if ([self.delegate respondsToSelector:@selector(AlertViewClickIndex:)]) {
        [self.delegate AlertViewClickIndex:0];
    }
    if (self.block) {
        self.block(0);
    }
     [self HiddenView];
}

-(void)ShowView{
    WeakSelf(weakSelf);
    [KeyWindow addSubview:self];
    self.backBtn.alpha = 0.3;
    if (_isAnimation) {
        [UIView animateWithDuration:0.35 animations:^{
            [self.backView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(weakSelf).mas_offset(BOS_W(50));
                make.top.equalTo(weakSelf).mas_offset(BOS_H(111) + Height_NavBar);
                make.right.equalTo(weakSelf).mas_offset(-BOS_W(40));
                make.height.mas_equalTo(154).priority(500);
                make.bottom.equalTo(weakSelf.sureBtn.mas_bottom);
            }];
            [weakSelf layoutSubviews];
        }];
    }else{
        [self.backView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf).mas_offset(BOS_W(50));
            make.top.equalTo(weakSelf).mas_offset(BOS_H(111) + Height_NavBar);
            make.right.equalTo(weakSelf).mas_offset(-BOS_W(40));
            make.height.mas_equalTo(154).priority(500);
            make.bottom.equalTo(weakSelf.sureBtn.mas_bottom);
        }];
    }
    
}

-(void)HiddenView{
    WeakSelf(weakSelf);
    self.backBtn.alpha = 0;
    if (_isAnimation) {
        [UIView animateWithDuration:0.35 animations:^{
            [self.backView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(weakSelf).mas_offset(BOS_W(50));
                make.top.equalTo(weakSelf).mas_offset(BOS_H(111)+Height_NavBar + ScreenHeight);
                make.right.equalTo(weakSelf).mas_offset(-BOS_W(50));
                make.height.mas_equalTo(154).priority(500);
                make.bottom.equalTo(weakSelf.sureBtn.mas_bottom);
            }];
            [weakSelf layoutSubviews];
        } completion:^(BOOL finished) {
            [weakSelf removeFromSuperview];
        }];
    }else{
        [self.backView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf).mas_offset(BOS_W(50));
            make.top.equalTo(weakSelf).mas_offset(BOS_H(111)+Height_NavBar + ScreenHeight);
            make.right.equalTo(weakSelf).mas_offset(-BOS_W(50));
            make.height.mas_equalTo(154).priority(500);
            make.bottom.equalTo(weakSelf.sureBtn.mas_bottom);
        }];
        [weakSelf removeFromSuperview];
    }
    
}
-(void)setTitleStr:(NSString *)titleStr{
    _titleStr = titleStr;
    self.titleLabel.text = titleStr;
}
-(void)setDetailStr:(NSString *)detailStr{
    _detailStr = detailStr;
    NSAttributedString * str =[BOSTools attributString:detailStr color:TEXTCOLOR font:FONT(14) Spac:3 textAligment:NSTextAlignmentCenter attribute:nil];
    self.descriptLabel.attributedText = str;
}

-(void)setSureTitle:(NSString *)sureTitle{
    _sureTitle = sureTitle;
    self.sureLabel.text = sureTitle;
    
}
-(void)setCancelTitle:(NSString *)cancelTitle{
    _cancelTitle = cancelTitle;
    self.cancelLabel.text = cancelTitle;
}
-(void)clickBackHidden:(BOOL)isHidden{
    self.backBtn.userInteractionEnabled = isHidden;
}
-(void)justHaveSure{
    WeakSelf(weakSelf);
    [self.sureBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.descriptLabel.mas_bottom).mas_offset(BOS_H(20));
        make.left.equalTo(weakSelf.backView);
        make.height.mas_equalTo(BOS_H(42));
        make.width.equalTo(weakSelf.backView);
    }];
    self.line1.hidden = YES;
    self.cancelBtn.hidden = YES;
    self.cancelLabel.hidden = YES;
}
#pragma mark - 创建试图
-(UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [BOSTools buttonWithFrame:self.frame font:nil textColor:nil backColor:COLOR(@"121414") target:self action:@selector(HiddenView) text:nil image:nil cornerRadius:0 superView:nil];
        _backBtn.userInteractionEnabled = NO;
        _backBtn.alpha = 0;
    }
    return _backBtn;
}

-(UIView *)backView{
    if (!_backView) {
        _backView = [BOSTools viewWithFrame:CGRectZero color:COLOR(@"FFFFFF") cornerRadius:8 superView:nil];
    }
    return _backView;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [BOSTools labelWithFrame:CGRectZero font:FONT(18) color:TEXTCOLOR alpha:1 textAlignment:NSTextAlignmentCenter text:NSLocalizedString(@"提示", nil) superView:nil];
    }
    return _titleLabel;
}
-(UILabel *)descriptLabel{
    if (!_descriptLabel) {
        _descriptLabel =  [BOSTools labelWithFrame:CGRectZero font:FONT(14) color:TEXTCOLOR alpha:1 textAlignment:NSTextAlignmentLeft text:@"" superView:self.backView];
    }
    return _descriptLabel;
}
-(UIButton *)sureBtn{
    if (!_sureBtn) {
        _sureBtn = [BOSTools buttonWithFrame:CGRectZero font:FONT(16) textColor:COLOR(@"3477FB") backColor:nil target:self action:@selector(sureClick) text:nil image:nil cornerRadius:0 superView:nil];
    }
    return _sureBtn;
}

-(UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [BOSTools buttonWithFrame:CGRectZero font:FONT(16) textColor:COLOR(@"999999") backColor:nil target:self action:@selector(cancelClick) text:nil image:nil cornerRadius:0 superView:nil];
    }
    return _cancelBtn;
}

-(UILabel *)sureLabel{
    if (!_sureLabel) {
        _sureLabel = [BOSTools labelWithFrame:CGRectZero font:FONT(16) color:COLOR(@"3477FB") alpha:1 textAlignment:NSTextAlignmentCenter text:@"确定" superView:nil];
    }
    return _sureLabel;
}

-(UILabel *)cancelLabel{
    if (!_cancelLabel) {
        _cancelLabel = [BOSTools labelWithFrame:CGRectZero font:FONT(16) color:COLOR(@"999999") alpha:1 textAlignment:NSTextAlignmentCenter text:@"取消" superView:nil];
    }
    return _cancelLabel;
}

-(void)createUI{
    self.isAnimation = YES;
    WeakSelf(weakSelf);
    [self addSubview:self.backBtn];
    [self addSubview:self.backView];
    [self.backView addSubview:self.titleLabel];
    [self.backView addSubview:self.descriptLabel];
    [self.backView addSubview:self.sureBtn];
    [self.backView addSubview:self.cancelBtn];
    [self.backView addSubview:self.sureLabel];
    [self.backView addSubview:self.cancelLabel];
  
    
    UIView * line = [BOSTools viewWithFrame:CGRectZero color:COLOR(@"999999") cornerRadius:0 superView:self.backView];
    line.alpha = 0.1;
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).mas_offset(BOS_W(50));
        make.top.equalTo(weakSelf).mas_offset(BOS_H(111) + Height_NavBar + ScreenHeight);
        make.right.equalTo(weakSelf).mas_offset(-BOS_W(50));
        make.height.mas_equalTo(154).priority(500);
        make.bottom.equalTo(weakSelf.sureBtn.mas_bottom);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.backView).mas_offset(BOS_W(34));
        make.right.equalTo(weakSelf.backView).mas_offset(-BOS_W(34));
        make.top.equalTo(weakSelf.backView).mas_offset(BOS_H(25));
//        make.height.mas_equalTo(BOS_H(25));
        make.height.mas_greaterThanOrEqualTo(BOS_W(25));
    }];
    [self.descriptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).mas_offset(BOS_H(20));
        make.centerX.equalTo(weakSelf.backView);
        make.width.lessThanOrEqualTo(@(BOS_W(231)));
    }];
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.descriptLabel.mas_bottom).mas_offset(BOS_H(20));
        make.right.equalTo(weakSelf.backView);
        make.height.mas_equalTo(BOS_H(42));
        make.width.mas_equalTo(BOS_W(136));
    }];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.descriptLabel.mas_bottom).mas_offset(BOS_H(20));
        make.left.equalTo(weakSelf.backView);
        make.height.mas_equalTo(BOS_H(42));
        make.width.mas_equalTo(BOS_W(136));
    }];
    [self.sureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.and.bottom.equalTo(weakSelf.sureBtn);
    }];
    [self.cancelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.and.bottom.equalTo(weakSelf.cancelBtn);
    }];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(weakSelf.backView);
        make.top.equalTo(weakSelf.sureBtn);
        make.height.mas_equalTo(1);
    }];
    self.line1 = [BOSTools viewWithFrame:CGRectZero color:COLOR(@"999999") cornerRadius:0 superView:self.backView];
    self.line1.alpha = 0.1;
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.backView);
        make.width.mas_equalTo(1);
        make.top.equalTo(line);
        make.bottom.equalTo(weakSelf.backView.mas_bottom);
    }];
    //强制渲染
    [self setNeedsLayout];
    [self layoutIfNeeded];
}
@end


@implementation BackUpAlertView
- (void)createUI {
    [super createUI];
    [self.backView addSubview:self.textView];
    [self.backView addSubview:self.closeButton];
    WeakSelf(weakSelf);
    [self.descriptLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).mas_offset(BOS_H(15));
        make.centerX.equalTo(weakSelf.backView);
        make.width.mas_equalTo(BOS_W(231));
        make.height.mas_equalTo(BOS_W(100));
    }];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(weakSelf.descriptLabel);
    }];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.titleLabel);
        make.right.equalTo(weakSelf.backView).mas_offset(-BOS_W(15));
        make.width.height.mas_equalTo(BOS_W(30));
    }];
    [self justHaveSure];
}
- (void)setDetailStr:(NSString *)detailStr{
    self.textView.text = detailStr;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.textColor = TEXTCOLOR;
        _textView.textAlignment = NSTextAlignmentCenter;
        _textView.font = FONT(14);
        _textView.editable = NO;
    }
    return _textView;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [BOSTools buttonWithFrame:CGRectZero font:nil textColor:nil backColor:nil target:self action:@selector(HiddenView) text:nil image:IMAGE(@"icon_close_default") cornerRadius:0 superView:nil];
    }
    return _closeButton;
}


@end
