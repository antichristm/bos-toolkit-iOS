////  FirstItemView.m
//  BOS
//
//  Created by BOS on 2018/12/13.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import "FirstItemView.h"
@interface FirstItemView()

@end
@implementation FirstItemView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    [self loadDefaultsSetting];
    [self initSubViews];
    
    return self;
    
}
-(void)tapAction:(UITapGestureRecognizer *)tap{
    if (self.firstItemTapBlock) {
        self.firstItemTapBlock(self);
    }
}
#pragma mark --> 🐷 Lazy loading 🐷
-(UIImageView *)leftImageView{
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc]init];
        _leftImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _leftImageView;
}
-(UIImageView *)rightImageView{
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc]init];
        _rightImageView.contentMode = UIViewContentModeScaleAspectFit;
        _rightImageView.image = IMAGE(@"bos_icon_fanhui_default");
    }
    return _rightImageView;
}
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = TEXTCOLOR;
        _titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
    }
    return _titleLabel;
}
#pragma mark >_<! --> 加载默认设置
-(void)loadDefaultsSetting{
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tap];
    self.backgroundColor = COLOR(@"FFFFFF");
}
#pragma mark >_<! --> 初始化子视图
-(void)initSubViews{
    [self addSubview:self.titleLabel];
    [self addSubview:self.leftImageView];
    [self addSubview:self.rightImageView];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
    WeakSelf(weakSelf);
    
    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.leading.equalTo(weakSelf).offset(BOS_W(27.5));
        make.width.height.mas_equalTo(BOS_W(25));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.leading.equalTo(weakSelf.leftImageView.mas_trailing).offset(7.5);
        make.trailing.equalTo(weakSelf.rightImageView.mas_leading).offset(-BOS_W(7.5));
    }];
    
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.trailing.equalTo(weakSelf).offset(-BOS_W(27.5));
        make.width.height.mas_equalTo(15);
    }];
}

@end
