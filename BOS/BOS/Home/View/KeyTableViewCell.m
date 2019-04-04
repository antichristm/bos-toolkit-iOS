////  KeyTableViewCell.m
//  BOS
//
//  Created by BOS on 2018/12/13.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import "KeyTableViewCell.h"


@interface SingleKeyTableViewCell()<TYLimitedTextViewDelegate>
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *placeLabel;

@end
@implementation SingleKeyTableViewCell

- (void)limitedTextViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length < 1) {
        self.placeLabel.hidden = NO;
    } else {
        self.placeLabel.hidden = YES;
    }
}

- (void)limitedTextViewDidBeginEditing:(UITextView *)textView{
    self.placeLabel.hidden = YES;
}

- (void)creatUI {
    self.selectionStyle = 0;
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.rightButton];
    [self.contentView addSubview:self.textview];
    [self.contentView addSubview:self.placeLabel];
    self.textview.editable = NO;
    WeakSelf(weakSelf);
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).mas_offset(BOS_W(15));
        make.top.equalTo(weakSelf).mas_offset(BOS_H(22));
        make.height.mas_equalTo(BOS_H(17));
        make.right.lessThanOrEqualTo(weakSelf).mas_offset(-BOS_W(100));
    }];
    NSString * string = self.rightButton.titleLabel.text;
    CGSize size = [BOSTools boundsWithString:[BOSTools attributString:string color:nil font:FONT(12) Spac:0 textAligment:NSTextAlignmentLeft attribute:nil] superSize:CGSizeMake(ScreenWidth, BOS_H(20))];
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf).mas_offset(-BOS_W(15));
        make.centerY.equalTo(weakSelf.titleLabel);
        make.height.mas_equalTo(BOS_H(25));
        make.width.mas_equalTo(size.width + BOS_W(30));
    }];
    [self.textview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.titleLabel);
        make.right.equalTo(weakSelf).mas_offset(-BOS_W(15));
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).mas_offset(BOS_H(15));
        make.height.mas_equalTo(BOS_W(75));
    }];
    [self.placeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.textview).mas_offset(BOS_H(15));
        make.top.equalTo(weakSelf.textview).mas_offset(BOS_H(15));
    }];
}
-(void)setTitleString:(NSString *)titleString{
    _titleString = titleString;
    self.titleLabel.text = titleString;
}
-(void)setDetailString:(NSString *)detailString{
    _detailString = detailString;
    self.textview.text = detailString;
    if (detailString.length < 1) {
        self.placeLabel.hidden = NO;
    } else {
        self.placeLabel.hidden = YES;
    }
}
-(void)setPlaceString:(NSString *)placeString{
    _placeString = placeString;
//    self.textview.toolbarPlaceholder = placeString;
    self.placeLabel.text = placeString;
}
-(void)setRightBtnString:(NSString *)rightBtnString{
    _rightBtnString = rightBtnString;
    [self.rightButton setTitle:rightBtnString forState:UIControlStateNormal];
    WeakSelf(weakSelf);
    CGSize size = [self.rightButton.titleLabel sizeThatFits:CGSizeMake(150, 40)];
    [self.rightButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf).mas_offset(-BOS_W(15));
        make.centerY.equalTo(weakSelf.titleLabel);
        make.height.mas_equalTo(BOS_H(25));
        make.width.mas_equalTo(size.width + BOS_W(30));
    }];
}

-(void)rightButtonClick:(UIButton *)click{
    if (self.block) {
        self.block(self.titleString?:@"", self.detailString?:@"");
    }
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [BOSTools labelWithFrame:CGRectZero font:FONT(14) color:COLOR(@"666666") alpha:1 textAlignment:NSTextAlignmentLeft text:nil superView:nil];
    }
    return _titleLabel;
}
- (UILabel *)placeLabel {
    if (!_placeLabel) {
        _placeLabel = [BOSTools labelWithFrame:CGRectZero font:FONT(12) color:COLOR(@"999999") alpha:1 textAlignment:NSTextAlignmentLeft text:nil superView:nil];
    }
    return _placeLabel;
}
- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [BOSTools buttonWithFrame:CGRectZero font:FONT(12) textColor:COLOR(@"FFFFFF") backColor:SUBJECTCOLOR target:self action:@selector(rightButtonClick:) text:NSLocalizedString(@"修改", nil) image:nil cornerRadius:6 superView:nil];
    }
    return _rightButton;
}
-(TYLimitedTextView *)textview{
    if (!_textview) {
        _textview = [[TYLimitedTextView alloc] initWithFrame:CGRectZero];
        _textview.backgroundColor = COLOR(@"#EFF2F6");
        _textview.font = FONT(12);
        _textview.textColor = TEXTCOLOR;
        _textview.layer.cornerRadius = 6;
        _textview.clipsToBounds = YES;
        _textview.realDelegate = self;
        _textview.keyboardType = UIKeyboardTypeASCIICapable;
        _textview.textContainerInset = UIEdgeInsetsMake(BOS_W(10), BOS_W(10), BOS_W(10), BOS_W(10));
        
    }
    return _textview;
}

@end

@interface KeyTableViewCell()
@property (nonatomic, strong) UILabel *titleLabelOne;
@property (nonatomic, strong) UILabel *titleLabelTwo;

@property (nonatomic, strong) UIButton *rightButtonOne;
@property (nonatomic, strong) UIButton *rightButtonTwo;

@end

@implementation KeyTableViewCell


- (void)rightButtonClick:(UIButton *)button {
    if (self.block) {
        if (button == self.rightButtonOne) {
            self.block(0);
        }else{
            self.block(1);
        }
    }
}

- (void)creatUI {
    self.selectionStyle = 0;
    [self.contentView addSubview:self.titleLabelOne];
    [self.contentView addSubview:self.titleLabelTwo];
    [self.contentView addSubview:self.rightButtonOne];
    [self.contentView addSubview:self.rightButtonTwo];
    [self.contentView addSubview:self.textviewOne];
    [self.contentView addSubview:self.textviewTwo];
    
    WeakSelf(weakSelf);
    [self.titleLabelOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).mas_offset(BOS_W(15));
        make.top.equalTo(weakSelf).mas_offset(BOS_H(22));
        make.height.mas_equalTo(BOS_H(17));
        make.right.lessThanOrEqualTo(weakSelf).mas_offset(-BOS_W(100));
    }];
    NSString * string = self.rightButtonOne.titleLabel.text;
    CGSize size = [BOSTools boundsWithString:[BOSTools attributString:string color:nil font:FONT(12) Spac:0 textAligment:0 attribute:nil] superSize:CGSizeMake(ScreenWidth, BOS_H(20))];
    [self.rightButtonOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf).mas_offset(-BOS_W(15));
        make.centerY.equalTo(weakSelf.titleLabelOne);
        make.height.mas_equalTo(BOS_H(25));
        make.width.mas_equalTo(size.width + BOS_W(30));
    }];
    [self.textviewOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.titleLabelOne);
        make.right.equalTo(weakSelf).mas_offset(-BOS_W(15));
        make.top.equalTo(weakSelf.titleLabelOne.mas_bottom).mas_offset(BOS_H(15));
        make.height.mas_equalTo(BOS_W(75));
    }];
    
    [self.titleLabelTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).mas_offset(BOS_W(15));
        make.top.equalTo(weakSelf.textviewOne.mas_bottom).mas_offset(BOS_H(22));
        make.height.mas_equalTo(BOS_H(17));
        make.right.lessThanOrEqualTo(weakSelf).mas_offset(-BOS_W(100));
    }];
    
    string = self.rightButtonTwo.titleLabel.text;
    size = [BOSTools boundsWithString:[BOSTools attributString:string color:nil font:FONT(12) Spac:0 textAligment:0 attribute:nil] superSize:CGSizeMake(ScreenWidth, BOS_H(20))];
    [self.rightButtonTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf).mas_offset(-BOS_W(15));
        make.centerY.equalTo(weakSelf.titleLabelTwo);
        make.height.mas_equalTo(BOS_H(25));
        make.width.mas_equalTo(size.width + BOS_W(30));
    }];
    [self.textviewTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.titleLabelTwo);
        make.right.equalTo(weakSelf).mas_offset(-BOS_W(15));
        make.top.equalTo(weakSelf.titleLabelTwo.mas_bottom).mas_offset(BOS_H(15));
        make.height.mas_equalTo(BOS_W(75));
    }];
}

- (void)setTitleOne:(NSString *)titleOne{
    _titleOne = titleOne;
    self.titleLabelOne.text = titleOne;
}

- (void)setTitleTwo:(NSString *)titleTwo{
    _titleTwo = titleTwo;
    self.titleLabelTwo.text = titleTwo;
}

- (void)setTextOne:(NSString *)textOne{
    _textOne = textOne;
    self.textviewOne.text = textOne;
}

- (void)setTextTwo:(NSString *)textTwo {
    _textTwo = textTwo;
    self.textviewTwo.text = textTwo;
}

- (UILabel *)titleLabelOne {
    if (!_titleLabelOne) {
        _titleLabelOne = [BOSTools labelWithFrame:CGRectZero font:FONT(14) color:COLOR(@"666666") alpha:1 textAlignment:NSTextAlignmentLeft text:nil superView:nil];
    }
    return _titleLabelOne;
}

- (UILabel *)titleLabelTwo {
    if (!_titleLabelTwo) {
        _titleLabelTwo = [BOSTools labelWithFrame:CGRectZero font:FONT(14) color:COLOR(@"666666") alpha:1 textAlignment:NSTextAlignmentLeft text:nil superView:nil];
    }
    return _titleLabelTwo;
}

- (UIButton *)rightButtonOne {
    if (!_rightButtonOne) {
        _rightButtonOne = [BOSTools buttonWithFrame:CGRectZero font:FONT(12) textColor:COLOR(@"FFFFFF") backColor:SUBJECTCOLOR target:self action:@selector(rightButtonClick:) text:NSLocalizedString(@"修改", nil) image:nil cornerRadius:6 superView:nil];
    }
    return _rightButtonOne;
}

- (UIButton *)rightButtonTwo {
    if (!_rightButtonTwo) {
        _rightButtonTwo = [BOSTools buttonWithFrame:CGRectZero font:FONT(12) textColor:COLOR(@"FFFFFF") backColor:SUBJECTCOLOR target:self action:@selector(rightButtonClick:) text:NSLocalizedString(@"修改", nil) image:nil cornerRadius:6 superView:nil];
    }
    return _rightButtonTwo;
}

-(TYLimitedTextView *)textviewOne{
    if (!_textviewOne) {
        _textviewOne = [[TYLimitedTextView alloc] initWithFrame:CGRectZero];
        _textviewOne.backgroundColor = COLOR(@"#EFF2F6");
        _textviewOne.font = FONT(12);
        _textviewOne.textColor = TEXTCOLOR;
        _textviewOne.layer.cornerRadius = 6;
        _textviewOne.clipsToBounds = YES;
        _textviewOne.keyboardType = UIKeyboardTypeASCIICapable;
        _textviewOne.textContainerInset = UIEdgeInsetsMake(BOS_W(10), BOS_W(10), BOS_W(10), BOS_W(10));
    }
    return _textviewOne;
}

-(TYLimitedTextView *)textviewTwo{
    if (!_textviewTwo) {
        _textviewTwo = [[TYLimitedTextView alloc] initWithFrame:CGRectZero];
        _textviewTwo.backgroundColor = COLOR(@"#EFF2F6");
        _textviewTwo.font = FONT(12);
        _textviewTwo.textColor = TEXTCOLOR;
        _textviewTwo.layer.cornerRadius = 6;
        _textviewTwo.clipsToBounds = YES;
        _textviewTwo.keyboardType = UIKeyboardTypeASCIICapable;
        _textviewTwo.textContainerInset = UIEdgeInsetsMake(BOS_W(10), BOS_W(10), BOS_W(10), BOS_W(10));
    }
    return _textviewTwo;
}

@end


@implementation CreateKeyTableViewCell

-(void)creatUI{
    self.rightButtonOne = [BOSTools buttonWithFrame:CGRectZero font:FONT(12) textColor:COLOR(@"#277EFD") backColor:nil target:self action:@selector(creatKey) text:NSLocalizedString(@" 生成新公钥", nil) image:IMAGE(@"bos_icon_shengcheng_default") cornerRadius:0 superView:nil];
    [super creatUI];
    self.rightButtonTwo.hidden = YES;
    self.textviewOne.editable = NO;
    self.textviewTwo.editable = NO;
    [self creatKey];
    
}

-(void)creatKey {
    EOSKeyModel * keys = [[EOSTools shared] getEOSKey];
    self.textOne = keys.publicKey;
    self.textTwo = keys.privateKey;
}

@end


