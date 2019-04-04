////  ImportCloudListCell.m
//  BOS
//
//  Created by BOS on 2018/12/19.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import "ImportCloudListCell.h"
@interface ImportCloudListCell()
@property(nonatomic,strong)UILabel * accountLabel;
@property(nonatomic,strong)UILabel * existLabel;
@property(nonatomic,strong)UILabel * cloudLabel;
@property(nonatomic,strong)UIImageView * backGroundImageView;
@property(nonatomic,strong,readwrite)UIButton * selectedButton;
@end

@implementation ImportCloudListCell
+(instancetype)initWithTableView:(UITableView * )tableView cellID:(NSString *)cellID
{
    ImportCloudListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[ImportCloudListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self loadDefaultsSetting];
        [self initSubViews];
    }
    return self;
}
-(void)setFrame:(CGRect)frame{
    frame.origin.y += BOS_H(8);
    frame.size.height -= BOS_H(8);
    frame.size.width -= BOS_W(25);
    frame.origin.x += BOS_W(12.5);
    [super setFrame:frame];
}
-(void)selelctAction:(UIButton *)button{
    
}
-(void)setModel:(AccountListModel *)model{
    _model = model;
    
    self.accountLabel.text = _model.accountName;
    self.existLabel.text = _model.locExsit;
    self.cloudLabel.text = _model.cloudBackups;
    
    self.existLabel.hidden = !(_model.locExsitWidth > 8);
    self.cloudLabel.hidden = !(_model.cloudBackupsWidth > 8);
}
#pragma mark >_<! --> 加载默认设置
-(void)loadDefaultsSetting{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.layer.cornerRadius = BOS_W(8);
    self.contentView.layer.cornerRadius = BOS_W(8);
    self.contentView.layer.masksToBounds = YES;
}
-(UILabel *)accountLabel{
    if (!_accountLabel) {
        _accountLabel = [[UILabel alloc]init];
        _accountLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:22];
        _accountLabel.textColor = COLOR(@"#FFFFFF");
    }
    return _accountLabel;
}
-(UILabel *)existLabel{
    if (!_existLabel) {
        _existLabel = [[UILabel alloc]init];
        _existLabel.font =[UIFont fontWithName:@"PingFangSC-Regular" size:9];
        _existLabel.textColor = [COLOR(@"#FFFFFF") colorWithAlphaComponent:0.7];
        _existLabel.layer.borderWidth = 0.4;
        _existLabel.layer.borderColor = COLOR(@"#FFFFFF").CGColor;
        _existLabel.layer.cornerRadius = 3;
        _existLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _existLabel;
}
-(UILabel *)cloudLabel{
    if (!_cloudLabel) {
        _cloudLabel = [[UILabel alloc]init];
        _cloudLabel.font =[UIFont fontWithName:@"PingFangSC-Regular" size:9];
        _cloudLabel.textColor = [COLOR(@"#FFFFFF") colorWithAlphaComponent:0.7];
        _cloudLabel.layer.borderWidth = 0.4;
        _cloudLabel.layer.borderColor = COLOR(@"#FFFFFF").CGColor;
        _cloudLabel.layer.cornerRadius = 3;
        _cloudLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _cloudLabel;
}
-(UIButton *)selectedButton{
    if (!_selectedButton) {
        _selectedButton = [[UIButton alloc]init];
        [_selectedButton setImage:IMAGE(@"account_icon_select_default") forState:UIControlStateNormal];
        [_selectedButton setImage:IMAGE(@"account_icon_pitchon_default") forState:UIControlStateSelected];
        _selectedButton.userInteractionEnabled = NO;
    }
    return _selectedButton;
}
-(UIImageView *)backGroundImageView{
    if (!_backGroundImageView) {
        _backGroundImageView = [[UIImageView alloc]init];
        _backGroundImageView.contentMode = UIViewContentModeScaleToFill;
        _backGroundImageView.clipsToBounds = NO;
    }
    return _backGroundImageView;
}
#pragma mark >_<! --> 初始化子视图
-(void)initSubViews{
    
    [self.contentView addSubview:self.backGroundImageView];
    [self.contentView addSubview:self.existLabel];
    [self.contentView addSubview:self.cloudLabel];
    [self.contentView addSubview:self.accountLabel];
    [self.contentView addSubview:self.selectedButton];
    
    self.backGroundImageView.image = IMAGE(@"qianbaosy_img_bg_default");
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
    WeakSelf(weakSelf);
    
    [self.backGroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.top.equalTo(weakSelf);
    }];
    
    [self.accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.leading.equalTo(weakSelf).offset(BOS_W(15));
    }];
    
    [self.existLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(weakSelf.accountLabel.mas_trailing).offset(BOS_W(6));
        make.centerY.equalTo(weakSelf.accountLabel);
        make.height.mas_offset(BOS_H(15));
        make.width.mas_equalTo(weakSelf.model.locExsitWidth);
    }];
    
    [self.cloudLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.equalTo(weakSelf.existLabel);
        make.leading.equalTo(weakSelf.existLabel.mas_trailing).offset(BOS_W(6));
        make.width.mas_equalTo(weakSelf.model.cloudBackupsWidth);
    }];
    
    [self.selectedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.trailing.equalTo(weakSelf).offset(-BOS_W(15));
        make.width.height.mas_equalTo(BOS_W(30));
    }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

@end
