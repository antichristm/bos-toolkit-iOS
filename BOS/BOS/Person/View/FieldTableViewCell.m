////  FieldTableViewCell.m
//  BOS
//
//  Created by BOS on 2018/12/11.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import "FieldTableViewCell.h"


@implementation FieldTableViewCell

- (void)copyDetail {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.field.text;
    [XWHUDManager showTipHUD:NSLocalizedString(@"复制成功", nil)];
}

- (void)creatUI{
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.field];
    [self.contentView addSubview:self.rightButton];
    [self.contentView addSubview:self.tipsLabel];
    WeakSelf(weakSelf);
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).mas_offset(BOS_W(15));
        make.top.equalTo(weakSelf).mas_offset(BOS_H(15));
        make.height.mas_equalTo(BOS_W(20));
        make.right.equalTo(weakSelf).mas_offset(-BOS_W(15));
        
    }];
    [self.field mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.titleLabel);
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).mas_offset(BOS_H(10));
        make.height.mas_equalTo(BOS_H(45));
    }];
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.equalTo(weakSelf.titleLabel);
        make.right.equalTo(weakSelf).mas_offset(-BOS_W(15));
        make.width.mas_equalTo(BOS_W(100));
    }];
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.titleLabel);
        make.top.equalTo(weakSelf.field.mas_bottom).mas_offset(BOS_H(5));
        make.right.lessThanOrEqualTo(weakSelf.titleLabel);
    }];
    
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [BOSTools labelWithFrame:CGRectZero font:FONT(14) color:COLOR(@"333333") alpha:1 textAlignment:NSTextAlignmentLeft text:nil superView:nil];
    }
    return _titleLabel;
}
-(TYLimitedTextField *)field{
    if (!_field) {
        _field = [[TYLimitedTextField alloc] init];
        _field.backgroundColor = COLOR(@"#EFF2F6");
        _field.layer.cornerRadius = BOS_W(6);
        _field.textColor = COLOR(@"333333");
        _field.font = FONT(14);
        _field.clipsToBounds = YES;
    }
    return _field;
}

- (void)setTitleString:(NSString *)titleString{
    _titleString = titleString;
    self.titleLabel.text = titleString;
}

-(void)setPlaceString:(NSString *)placeString{
    _placeString = placeString;
    self.field.placeholder = placeString;
}

-(void)setTipsString:(NSString *)tipsString{
    _tipsString = tipsString;
    self.tipsLabel.text = tipsString;
}

-(UIButton *)rightButton{
    if (!_rightButton) {
        _rightButton = [BOSTools buttonWithFrame:CGRectZero font:FONT(12) textColor:COLOR(@"#A2AAB6") backColor:nil target:self action:@selector(copyDetail) text:NSLocalizedString(@" 复制", nil) image:IMAGE(@"bos_icon_fuzhi_default") cornerRadius:0 superView:nil];
        _rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _rightButton.hidden = YES;
    }
    return _rightButton;
}

- (UILabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel = [BOSTools labelWithFrame:CGRectZero font:FONT(12) color:COLOR(@"#E65062") alpha:1 textAlignment:NSTextAlignmentLeft text:nil superView:nil];
    }
    return _tipsLabel;
}



@end
