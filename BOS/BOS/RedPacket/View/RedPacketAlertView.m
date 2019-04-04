////  RedPacketAlertView.m
//  BOS
//
//  Created by BOS on 2019/1/7.
//  Copyright © 2019年 BOS. All rights reserved.
//

#import "RedPacketAlertView.h"

@interface RedPacketAlertView()

@property(nonatomic,strong)UIButton * backBtn;//灰色
@property(nonatomic,strong)UIView * backView;//背景
@property (nonatomic, strong) UIImageView *imageView;
@property(nonatomic,strong)UIButton * sureBtn;//确认
@property (nonatomic, strong) UIButton *closeBtn;//删除按钮
@property (nonatomic, strong) UITextView *inputTextView;

@end

@implementation RedPacketAlertView

+ (RedPacketAlertView *)share {
    static RedPacketAlertView * packet = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      packet = [[RedPacketAlertView alloc] init];
    });
    return packet;
}

-(instancetype)init{
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
        [self createUI];
    }
    return self;
}

- (void)setRedString:(NSString *)redString {
    _redString = redString;
    self.inputTextView.text = redString;
}

- (void)sureClick {
    NSLog(@"点击确定");
    if (self.redPacketBlock) {
        self.redPacketBlock();
    }
    [self HiddenView];
}

- (void)closeClick {
    [self HiddenView];
    
}

-(void)HiddenView{
    WeakSelf(weakSelf);
    self.backBtn.alpha = 0;
    [UIView animateWithDuration:0.35 animations:^{
        [self.backView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf).mas_offset(BOS_W(20));
            make.right.equalTo(weakSelf).mas_offset(- BOS_W(20));
            make.top.equalTo(weakSelf).mas_offset(BOS_W(100) + Height_Top + ScreenHeight);
            make.height.mas_equalTo(BOS_W(422));
        }];
        [weakSelf layoutSubviews];
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
    
}
-(void)ShowView{
    WeakSelf(weakSelf);
    [KeyWindow addSubview:self];
    self.backBtn.alpha = 0.3;
    [UIView animateWithDuration:0.35 animations:^{
        [self.backView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf).mas_offset(BOS_W(20));
            make.right.equalTo(weakSelf).mas_offset(- BOS_W(20));
            make.top.equalTo(weakSelf).mas_offset(BOS_W(100) + Height_Top);
            make.height.mas_equalTo(BOS_W(422));
        }];
        [weakSelf layoutSubviews];
    }];
    
}

- (void)createUI {
    [self addSubview:self.backBtn];
    [self addSubview:self.backView];
    [self addSubview:self.imageView];
    [self addSubview:self.closeBtn];
    [self addSubview:self.inputTextView];
    [self addSubview:self.sureBtn];
    WeakSelf(weakSelf);
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).mas_offset(BOS_W(20));
        make.right.equalTo(weakSelf).mas_offset(- BOS_W(20));
        make.top.equalTo(weakSelf).mas_offset(BOS_W(100) + Height_Top);
        make.height.mas_equalTo(BOS_W(422));
    }];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(weakSelf.backView);
    }];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.backView).mas_offset(BOS_H(7.5));
        make.right.equalTo(weakSelf.backView).mas_offset(-BOS_H(7.5));
        make.width.height.mas_equalTo(BOS_W(30));
    }];
    [self.inputTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.backView).mas_offset(BOS_W(20));
        make.right.equalTo(weakSelf.backView).mas_offset(-BOS_W(20));
        make.top.equalTo(weakSelf.backView).mas_offset(BOS_H(125));
        make.height.mas_equalTo(BOS_H(182));
    }];
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.backView);
        make.top.equalTo(weakSelf.inputTextView.mas_bottom).mas_offset(BOS_H(30));
        make.width.mas_equalTo(BOS_W(238.5));
        make.height.mas_equalTo(BOS_W(42.5));
    }];
    //强制渲染
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [BOSTools imageViewWithFrame:CGRectZero image:IMAGE(@"envelope_img_redbg_default") superView:nil];
    }
    return _imageView;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [BOSTools buttonWithFrame:self.frame font:nil textColor:nil backColor:COLOR(@"121414") target:self action:@selector(HiddenView) text:nil image:nil cornerRadius:0 superView:nil];
        _backBtn.userInteractionEnabled = NO;
        _backBtn.alpha = 0;
    }
    return _backBtn;
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [BOSTools viewWithFrame:CGRectZero color:[UIColor clearColor] cornerRadius:8 superView:nil];
    }
    return _backView;
}

- (UIButton *)sureBtn {
    if (!_sureBtn) {
        _sureBtn = [BOSTools buttonWithFrame:CGRectZero font:FONTNAME(@"HelveticaNeue-Medium", 17) textColor:COLOR(@"#C63D38") backColor:COLOR(@"#FCDBB2") target:self action:@selector(sureClick) text:NSLocalizedString(@"领取红包", nil) image:nil cornerRadius:8 superView:nil];
    }
    return _sureBtn;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [BOSTools buttonWithFrame:CGRectZero font:FONT(16) textColor:COLOR(@"3477FB") backColor:nil target:self action:@selector(closeClick) text:nil image:IMAGE(@"envelope_icon_shutdown_default") cornerRadius:0 superView:nil];
    }
    return _closeBtn;
}

- (UITextView *)inputTextView {
    if (!_inputTextView) {
        _inputTextView = [[UITextView alloc] init];
        _inputTextView.font = FONT(12);
        _inputTextView.textColor = COLOR(@"#7A756E");
        _inputTextView.textContainerInset =  UIEdgeInsetsMake(BOS_H(15), BOS_H(15), BOS_H(15), BOS_H(15));
        _inputTextView.editable = NO;
    }
    return _inputTextView;
}


@end
