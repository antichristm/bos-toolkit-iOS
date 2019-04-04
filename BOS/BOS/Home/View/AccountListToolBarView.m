////  AccountListToolBarView.m
//  BOS
//
//  Created by BOS on 2018/12/12.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import "AccountListToolBarView.h"
@interface AccountListToolBarView()
@property(nonatomic,strong)UILabel * titleLabel;
@property(nonatomic,strong)UIButton * addButton;
@end
@implementation AccountListToolBarView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    [self loadDefaultsSetting];
    [self initSubViews];
    
    return self;
    
}
-(void)addAction:(UIButton *)button{
    NSLog(@"添加");
    if (self.accountListToolBarAddBlock) {
        self.accountListToolBarAddBlock(button);
    }
}
#pragma mark -- 加载默认设置
-(void)loadDefaultsSetting{
}
#pragma mark -- Lazy loading
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:16];
        _titleLabel.textColor = COLOR(@"#333333");
    }
    return _titleLabel;
}
-(UIButton *)addButton{
    if (!_addButton) {
        _addButton = [[UIButton alloc]init];
        [_addButton addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
        [_addButton setTitleColor:TEXTCOLOR forState:UIControlStateNormal];
    }
    return _addButton;
}
#pragma mark -- 初始化子视图

-(void)initSubViews{
    [self addSubview:self.titleLabel];
    [self addSubview:self.addButton];
    
    self.titleLabel.text = @"Bos Toolkit";
    [self.addButton setTitle:@"➕" forState:UIControlStateNormal];
    WeakSelf(weakSelf);
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf).offset(-BOS_H(14));
        make.leading.equalTo(weakSelf).offset(BOS_W(15));
    }];
    
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.titleLabel);
        make.trailing.equalTo(weakSelf).offset(-BOS_W(15));
        make.height.mas_equalTo(BOS_H(30));
        make.width.mas_equalTo(BOS_W(35));
    }];
}
-(void)layoutSubviews{
    [super layoutSubviews];
}

@end
