////  LanguageSetTableViewCell.m
//  BOS
//
//  Created by BOS on 2018/12/12.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import "LanguageSetTableViewCell.h"

@implementation LanguageSetTableViewCell

- (void)creatUI {
    [self.contentView addSubview:self.rightButton];
    [self.contentView addSubview:self.line];
     WeakSelf(weakSelf);
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.right.equalTo(weakSelf).mas_offset(- BOS_W(15));
        make.width.height.mas_equalTo(BOS_W(18));
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.bottom.equalTo(weakSelf);
        make.height.mas_equalTo(0.5);
        make.width.equalTo(weakSelf).mas_offset(-BOS_W(30));
    }];
}

- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [BOSTools buttonWithFrame:CGRectZero font:nil textColor:nil backColor:nil target:nil action:nil text:nil image:IMAGE(@"yuyan_icon_duide_default") cornerRadius:0 superView:nil];
        _rightButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _rightButton;
}

- (UIView *)line {
    if (!_line) {
        _line = [BOSTools viewWithFrame:CGRectZero color:COLOR(@"999999") cornerRadius:0 superView:nil];
        _line.alpha = 0.2;
    }
    return _line;
}

@end
