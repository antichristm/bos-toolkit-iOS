////  PersonTableViewCell.m
//  BOS
//
//  Created by BOS on 2018/12/11.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import "PersonTableViewCell.h"


@interface PersonTableViewCell()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UIImageView *rightImageView;

@end

@implementation PersonTableViewCell

- (void)creatUI {
    
    [self.contentView addSubview:self.iconView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.line];
    [self.contentView addSubview:self.rightImageView];
    WeakSelf(weakSelf);
        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf);
            make.left.equalTo(weakSelf).mas_offset(BOS_W(15));
            make.width.height.mas_equalTo(BOS_W(15));
        }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.iconView);
        make.left.equalTo(weakSelf.iconView.mas_right).mas_offset(BOS_W(7));
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.bottom.equalTo(weakSelf);
        make.height.mas_equalTo(0.5);
        make.width.equalTo(weakSelf).mas_offset(-BOS_W(30));
    }];
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.iconView);
        make.right.equalTo(weakSelf).mas_offset(- BOS_W(15));
        make.width.height.mas_equalTo(BOS_W(10));
    }];
}
- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [BOSTools imageViewWithFrame:CGRectZero image:nil superView:nil];
        _iconView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _iconView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [BOSTools labelWithFrame:CGRectZero font:FONT(14) color:COLOR(@"333333") alpha:1 textAlignment:NSTextAlignmentLeft text:nil superView:nil];
    }
    return _titleLabel;
}
- (UIView *)line {
    if (!_line) {
        _line = [BOSTools viewWithFrame:CGRectZero color:COLOR(@"999999") cornerRadius:0 superView:nil];
        _line.alpha = 0.2;
    }
    return _line;
}

- (UIImageView *)rightImageView {
    if (!_rightImageView) {
        _rightImageView = [BOSTools imageViewWithFrame:CGRectZero image:IMAGE(@"bos_icon_jingru_default") superView:nil];
        _rightImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _rightImageView;
}

- (void)setTitleString:(NSString *)titleString {
    _titleString = titleString;
    self.titleLabel.text = titleString;
}

- (void)setImageString:(NSString *)imageString {
    _imageString = imageString;
    self.iconView.image = IMAGE(imageString);
    
}

@end


@implementation TitleTableViewCell

- (void)creatUI {
    
    [self.contentView addSubview:self.iconView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.line];
    [self.contentView addSubview:self.rightImageView];
    WeakSelf(weakSelf);
//    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(weakSelf);
//        make.left.equalTo(weakSelf).mas_offset(BOS_W(15));
//        make.width.height.mas_equalTo(BOS_W(15));
//    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.left.equalTo(weakSelf).mas_offset(BOS_W(15));
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.bottom.equalTo(weakSelf);
        make.height.mas_equalTo(0.5);
        make.width.equalTo(weakSelf).mas_offset(-BOS_W(30));
    }];
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.right.equalTo(weakSelf).mas_offset(- BOS_W(15));
        make.width.height.mas_equalTo(BOS_W(10));
    }];
}

@end
