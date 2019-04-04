////  AccountManagerHeadView.m
//  BOS
//
//  Created by BOS on 2018/12/11.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import "AccountManagerHeadView.h"
@interface AccountManagerHeadView()
@property(nonatomic,strong)UIImageView * bgImageView;

@end
@implementation AccountManagerHeadView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    [self loadDefaultsSetting];
    [self initSubViews];
    
    return self;
    
}
#pragma mark  -- 加载默认设置
-(void)loadDefaultsSetting
{
    
}
#pragma mark  -- 初始化子视图
-(UIImageView *)bgImageView
{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc]init];
        _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _bgImageView;
}
-(UILabel *)walletLabel
{
    if (!_walletLabel) {
        _walletLabel = [[UILabel alloc]init];
        _walletLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:22];
        _walletLabel.textColor = COLOR(@"#FFFFFF");
        _walletLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _walletLabel;
}
-(UILabel *)balanceLabel
{
    if (!_balanceLabel) {
        _balanceLabel = [[UILabel alloc]init];
        _balanceLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
        _balanceLabel.textColor = COLOR(@"#FFFFFF");
        _balanceLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _balanceLabel;
}
-(void)initSubViews{
    [self addSubview:self.bgImageView];
    [self addSubview:self.walletLabel];
    [self addSubview:self.balanceLabel];
    
    self.bgImageView.image = IMAGE(@"zhanghao_img_bg_default");
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    WeakSelf(weakSelf);
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.top.equalTo(weakSelf);
    }];
    
    [self.walletLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf.balanceLabel.mas_top).offset(-BOS_H(8));
    }];
    
    [self.balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf).offset(-BOS_H(25));
    }];
}

@end
