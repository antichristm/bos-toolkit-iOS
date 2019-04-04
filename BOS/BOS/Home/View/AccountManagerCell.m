////  AccountManagerCell.m
//  BOS
//
//  Created by BOS on 2018/12/11.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import "AccountManagerCell.h"
@interface AccountManagerCell()
@property(nonatomic,strong)UIImageView * leftImageView;
@property(nonatomic,strong)UIImageView * rightImageView;
@property(nonatomic,strong)UILabel * titleLabel;
@property(nonatomic,strong)UIView * bottomLineView;
@end
@implementation AccountManagerCell
+(instancetype)initWithTableView:(UITableView * )tableView cellID:(NSString *)cellID
{
    AccountManagerCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[AccountManagerCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
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
-(void)loadDefaultsSetting
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
-(void)setModel:(AccountManagerModel *)model
{
    _model = model;
    self.titleLabel.text = _model.title;
    self.leftImageView.image = IMAGE(_model.leftImg);
    self.rightImageView.image = IMAGE(_model.rightImg);
}
#pragma mark >_<! --> 初始化子视图
-(UIImageView *)leftImageView
{
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc]init];
        _leftImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _leftImageView;
}
-(UIImageView *)rightImageView
{
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc]init];
        _rightImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _rightImageView;
}
-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        _titleLabel.textColor = COLOR(@"#333333");
    }
    return _titleLabel;
}
-(UIView *)bottomLineView
{
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc]init];
        _bottomLineView.backgroundColor = [COLOR(@"#999999") colorWithAlphaComponent:0.2];
    }
    return _bottomLineView;
}
-(void)initSubViews
{
    [self.contentView addSubview:self.leftImageView];
    [self.contentView addSubview:self.rightImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.bottomLineView];
    
    
    WeakSelf(weakSelf);
    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(weakSelf).offset(BOS_W(15));
        make.centerY.equalTo(weakSelf);
        make.width.height.mas_equalTo(BOS_W(16));
    }];
    
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.leftImageView);
        make.width.height.mas_equalTo(BOS_W(10));
        make.trailing.equalTo(weakSelf).offset(-BOS_W(12));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.leading.equalTo(weakSelf.leftImageView.mas_trailing).offset(BOS_W(7));
        make.trailing.equalTo(weakSelf.rightImageView.mas_leading).offset(-BOS_W(7));
    }];
    
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf);
        make.leading.equalTo(weakSelf).offset(BOS_W(10));
        make.trailing.equalTo(weakSelf).offset(-BOS_W(10));
        make.height.mas_equalTo(0.5);
    }];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
