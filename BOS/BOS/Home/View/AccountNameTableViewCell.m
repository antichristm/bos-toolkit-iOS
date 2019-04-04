////  AccountNameTableViewCell.m
//  BOS
//
//  Created by BOS on 2018/12/13.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import "AccountNameTableViewCell.h"

@interface AccountNameTableViewCell()

@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, strong) UIView *line;

@end

@implementation AccountNameTableViewCell

- (void)creatUI {
    self.selectionStyle = 0;
    [self.contentView addSubview:self.leftLabel];
    [self.contentView addSubview:self.rightLabel];
    [self.contentView addSubview:self.line];
    WeakSelf(weakSelf);
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.left.equalTo(weakSelf).mas_offset(BOS_W(15));
    }];
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.right.equalTo(weakSelf).mas_offset(- BOS_W(15));
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.bottom.equalTo(weakSelf);
        make.height.mas_equalTo(0.5);
        make.width.equalTo(weakSelf).mas_offset(-BOS_W(30));
    }];
}

-(void)setLeftString:(NSString *)leftString{
    _leftString = leftString;
    self.leftLabel.text = leftString;
}

-(void)setRightString:(NSString *)rightString{
    _rightString = rightString;
    self.rightLabel.text = rightString;
}

-(void)setAttLeftString:(NSAttributedString *)attLeftString{
    _attLeftString = attLeftString;
    self.leftLabel.attributedText = attLeftString;
}

-(void)setAttRightString:(NSAttributedString *)attRightString{
    _attRightString = attRightString;
    self.rightLabel.attributedText = attRightString;
}

-(UILabel *)leftLabel{
    if (!_leftLabel) {
        _leftLabel = [BOSTools labelWithFrame:CGRectZero font:FONT(14) color:COLOR(@"666666") alpha:1 textAlignment:NSTextAlignmentLeft text:nil superView:nil];
    }
    return _leftLabel;
}
-(UILabel *)rightLabel{
    if (!_rightLabel) {
        _rightLabel = [BOSTools labelWithFrame:CGRectZero font:FONT(14) color:COLOR(@"666666") alpha:1 textAlignment:NSTextAlignmentLeft text:nil superView:nil];
    }
    return _rightLabel;
}

- (UIView *)line {
    if (!_line) {
        _line = [BOSTools viewWithFrame:CGRectZero color:COLOR(@"999999") cornerRadius:0 superView:nil];
        _line.alpha = 0.2;
    }
    return _line;
}

@end
