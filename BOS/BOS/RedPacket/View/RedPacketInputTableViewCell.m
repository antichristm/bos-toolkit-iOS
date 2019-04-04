////  RedPacketInputTableViewCell.m
//  BOS
//
//  Created by BOS on 2019/1/2.
//  Copyright © 2019年 BOS. All rights reserved.
//

#import "RedPacketInputTableViewCell.h"

@interface RedPacketInputTableViewCell()

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *UnitLabel;
@property (nonatomic, strong) UIView *rightView;
@property (nonatomic, strong) UILabel *rightLabel;

@end

@implementation RedPacketInputTableViewCell

- (void)creatUI {
    self.backgroundColor = COLOR(@"f5f5f5");
    [self addSubview:self.backView];
    [self.backView addSubview:self.titleLabel];
    [self.backView addSubview:self.UnitLabel];
    [self.backView addSubview:self.inputTF];
    [self.backView addSubview:self.rightView];
    WeakSelf(weakSelf);
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).mas_offset(BOS_W(10));
        make.right.equalTo(weakSelf).mas_offset(-BOS_W(10));
        make.top.bottom.equalTo(weakSelf);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.backView).mas_offset(BOS_W(10));
        make.centerY.equalTo(weakSelf.backView);
    }];
    [self.UnitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.backView).mas_offset(-BOS_W(10));
        make.centerY.equalTo(weakSelf.backView);
    }];
    [self.inputTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.UnitLabel.mas_left).mas_offset(-BOS_W(8));
        make.centerY.equalTo(weakSelf.backView);
        make.height.mas_equalTo(BOS_H(20));
        make.width.mas_equalTo(BOS_W(100));
    }];
    [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
          make.centerY.equalTo(weakSelf.backView);
         make.right.equalTo(weakSelf.backView).mas_offset(-BOS_W(10));
         make.height.equalTo(weakSelf);
         make.width.mas_equalTo(BOS_W(120));
    }];
}
- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

-(void)setUnit:(NSString *)unit {
    _unit = unit;
    self.UnitLabel.text = unit;
}
- (void)setPlaceString:(NSString *)placeString{
    _placeString = placeString;
    self.inputTF.placeholder = placeString;
}

-(void)setRightViewTitle:(NSString *)rightViewTitle {
    _rightViewTitle = rightViewTitle;
    self.rightLabel.text = rightViewTitle;
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [BOSTools viewWithFrame:CGRectZero color:COLOR(@"FFFFFF") cornerRadius:6 superView:nil];
    }
    return _backView;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [BOSTools labelWithFrame:CGRectZero font:FONTNAME(@"PingFangSC-Regular", 14) color:COLOR(@"#333333") alpha:1 textAlignment:NSTextAlignmentCenter text:nil superView:nil];
    }
    return _titleLabel;
}
- (UILabel *)UnitLabel{
    if (!_UnitLabel) {
        _UnitLabel = [BOSTools labelWithFrame:CGRectZero font:FONTNAME(@"PingFangSC-Regular", 14) color:COLOR(@"#333333") alpha:1 textAlignment:NSTextAlignmentCenter text:nil superView:nil];
    }
    return _UnitLabel;
}

- (TYLimitedTextField *)inputTF{
    if (!_inputTF) {
        _inputTF = [[TYLimitedTextField alloc] init];
        _inputTF.textColor = COLOR(@"333333");
        _inputTF.font = FONTNAME(@"PingFangSC-Regular", 14);
        _inputTF.limitedType = TYLimitedTextFieldTypeNumber;
        _inputTF.textAlignment = NSTextAlignmentRight;
        _inputTF.maxLength = 10;
    }
    return _inputTF;
}

- (UIView *)rightView {
    if (!_rightView) {
        UIView * backView = [BOSTools viewWithFrame:CGRectZero color:COLOR(@"FFFFFF") cornerRadius:0 superView:nil];
        UIButton * rightBtn = [BOSTools buttonWithFrame:CGRectZero font:nil textColor:nil backColor:nil target:nil action:nil text:nil image:IMAGE(@"account_icon_next_default") cornerRadius:0 superView:backView];
        UILabel * textLabel = [BOSTools labelWithFrame:CGRectZero font:FONT(14) color:COLOR(@"999999") alpha:1 textAlignment:NSTextAlignmentRight text:NSLocalizedString(@"请选择支付账户", nil) superView:backView];
        [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(backView);
            make.centerY.equalTo(backView);
            make.width.height.mas_equalTo(BOS_W(20));
        }];
        [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(backView);
            make.right.equalTo(rightBtn.mas_left);
            make.height.mas_equalTo(BOS_H(18));
        }];
        backView.hidden = YES;
        _rightLabel = textLabel;
        _rightView = backView;
    }
    return _rightView;
}


@end

@implementation RedPacketRandomInputTableViewCell

- (void) creatUI {
    self.backgroundColor = COLOR(@"f5f5f5");
    [self addSubview:self.backView];
    [self.backView addSubview:self.titleLabel];
    [self.backView addSubview:self.UnitLabel];
    [self.backView addSubview:self.inputTF];
    [self.backView addSubview:self.rightView];
    [self.backView addSubview:self.leftlabel];
    WeakSelf(weakSelf);
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).mas_offset(BOS_W(10));
        make.right.equalTo(weakSelf).mas_offset(-BOS_W(10));
        make.top.bottom.equalTo(weakSelf);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.leftlabel.mas_right).mas_offset(BOS_W(5));
        make.centerY.equalTo(weakSelf.backView);
    }];
    [self.UnitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.backView).mas_offset(-BOS_W(10));
        make.centerY.equalTo(weakSelf.backView);
    }];
    [self.inputTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.UnitLabel.mas_left).mas_offset(-BOS_W(8));
        make.centerY.equalTo(weakSelf.backView);
        make.height.mas_equalTo(BOS_H(20));
        make.width.mas_equalTo(BOS_W(100));
    }];
    [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.backView);
        make.right.equalTo(weakSelf.backView).mas_offset(-BOS_W(10));
        make.height.equalTo(weakSelf);
        make.width.mas_equalTo(BOS_W(120));
    }];
  
    [self.leftlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.backView).mas_offset(BOS_W(10));
        make.centerY.equalTo(weakSelf.backView);
        make.width.height.mas_equalTo(BOS_W(15));
    }];
    
}

- (UILabel *)leftlabel {
    if (!_leftlabel) {
        _leftlabel =  [BOSTools labelWithFrame:CGRectZero font:FONT(10) color:COLOR(@"FFFFFF") alpha:1 textAlignment:NSTextAlignmentCenter text:NSLocalizedString(@"拼", nil) superView:nil];
        _leftlabel.backgroundColor = COLOR(@"#CE2344");
    }
    return _leftlabel;
}

@end


@implementation RedPacketAccountChooseTableViewCell

-(void)creatUI {
    [super creatUI];
    self.rightView.hidden = NO;
}

@end


@implementation RedPacketWishTableViewCell

- (void)creatUI {
    self.backgroundColor = COLOR(@"f5f5f5f");
    [self addSubview:self.backView];
    [self addSubview:self.textView];
    [self addSubview:self.palceLabel];
    WeakSelf(weakSelf);
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).mas_offset(BOS_W(10));
        make.right.equalTo(weakSelf).mas_offset(-BOS_W(10));
        make.top.bottom.equalTo(weakSelf);
    }];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(weakSelf.backView).mas_offset(BOS_W(15));
        make.right.bottom.equalTo(weakSelf.backView).mas_offset(-BOS_W(15));
    }];
    [self.palceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(weakSelf.textView);
    }];
    
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [BOSTools viewWithFrame:CGRectZero color:COLOR(@"FFFFFF") cornerRadius:6 superView:nil];
    }
    return _backView;
}
- (TYLimitedTextView *)textView{
    if (!_textView) {
        _textView = [[TYLimitedTextView alloc] init];
        _textView.font = FONTNAME(@"PingFangSC-Regular", 13);
        _textView.textColor = COLOR(@"333333");
        _textView.realDelegate = self;
    }
    return _textView;
}
-(UILabel *)palceLabel{
    if (!_palceLabel) {
        _palceLabel = [BOSTools labelWithFrame:CGRectZero font:FONT(14) color:COLOR(@"999999") alpha:1 textAlignment:NSTextAlignmentLeft text:NSLocalizedString(@"恭喜发财，大吉大利", nil) superView:nil];
    }
    return _palceLabel;
}

- (void)limitedTextViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length < 1) {
        self.palceLabel.hidden = NO;
    } else {
        self.palceLabel.hidden = YES;
    }
}

- (void)limitedTextViewDidBeginEditing:(UITextView *)textView{
    self.palceLabel.hidden = YES;
}

@end

@implementation RedPacketAlertTableViewCell

- (void)creatUI {
    self.backgroundColor = COLOR(@"f5f5f5");
    [self addSubview:self.leftLabel];
    [self addSubview:self.rightButton];
    WeakSelf(weakSelf);
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).mas_offset(BOS_W(10));
        make.top.equalTo(weakSelf);
        make.width.lessThanOrEqualTo(weakSelf).mas_offset(-BOS_W(50));
    }];
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf).mas_offset(-BOS_W(5));
        make.centerY.equalTo(weakSelf.leftLabel);
        make.width.height.mas_equalTo(BOS_W(30));
    }];
    
}

- (void)rightButtonClick {
    if (self.block) {
        self.block();
    }
}

- (UILabel *)leftLabel{
    if (!_leftLabel) {
        _leftLabel = [BOSTools labelWithFrame:CGRectZero font:FONTNAME(@"HelveticaNeue", 12) color:COLOR(@"#DA2727") alpha:1 textAlignment:NSTextAlignmentLeft text:NSLocalizedString(@"*红包金额以实际转账为准", nil) superView:nil];
    }
    return _leftLabel;
}
- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [BOSTools buttonWithFrame:CGRectZero font:nil textColor:nil backColor:nil target:self action:@selector(rightButtonClick) text:nil image:IMAGE(@"envelope_icon_doubt_default") cornerRadius:0 superView:nil];
    }
    return _rightButton;
}

@end
