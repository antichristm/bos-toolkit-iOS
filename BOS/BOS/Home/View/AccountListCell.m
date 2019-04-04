////  AccountListCell.m
//  BOS
//
//  Created by BOS on 2018/12/11.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import "AccountListCell.h"
@interface AccountListCell()
@property(nonatomic,strong)UILabel * accountLabel;
@property(nonatomic,strong)UILabel * balanceLabel;
@property(nonatomic,strong)UIImageView * backGroundImageView;
@property(nonatomic,strong)UIImageView * cloudImageView;
@end
@implementation AccountListCell

+(instancetype)initWithTableView:(UITableView * )tableView cellID:(NSString *)cellID
{
    AccountListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[AccountListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
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
-(void)creatUI{
    [self loadDefaultsSetting];
    [self initSubViews];
}
-(void)setFrame:(CGRect)frame{
    frame.origin.y += BOS_H(10);
    frame.size.height -= BOS_H(10);
    frame.size.width -= BOS_W(30);
    frame.origin.x += BOS_W(15);
    [super setFrame:frame];
}
-(void)loadDefaultsSetting{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.layer.cornerRadius = BOS_W(12);
    self.contentView.layer.cornerRadius = BOS_W(12);
    self.contentView.layer.masksToBounds = YES;
}
#pragma mark  🐷 Setter and getter 🐷

-(void)setModel:(AccountListModel *)model{
    _model = model;
    self.accountLabel.text = model.accountName;
    self.balanceLabel.text = [NSString stringWithFormat:@"%@",_model.balance];
    self.cloudImageView.image = IMAGE(_model.cloudBackups ? @"bos_icon_yun_default" : @"");
}
#pragma mark -- Lazy loading
-(UILabel *)accountLabel{
    if (!_accountLabel) {
        _accountLabel = [[UILabel alloc]init];
        _accountLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:22];
        _accountLabel.textColor = COLOR(@"#FFFFFF");
    }
    return _accountLabel;
}
-(UILabel *)balanceLabel{
    if (!_balanceLabel) {
        _balanceLabel = [[UILabel alloc]init];
        _balanceLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
        _balanceLabel.textColor = COLOR(@"#FFFFFF");
    }
    return _balanceLabel;
}
-(UIImageView *)backGroundImageView{
    if (!_backGroundImageView) {
        _backGroundImageView = [[UIImageView alloc]init];
        _backGroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _backGroundImageView;
}
-(UIImageView *)cloudImageView{
    if (!_cloudImageView) {
        _cloudImageView = [[UIImageView alloc]init];
        _cloudImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _cloudImageView;
}
-(void)initSubViews{
    [self.contentView addSubview:self.backGroundImageView];
    [self.contentView addSubview:self.accountLabel];
    [self.contentView addSubview:self.balanceLabel];
    [self.contentView addSubview:self.cloudImageView];
    
    self.backGroundImageView.image = IMAGE(@"qianbaosy_img_bg_default");
    self.cloudImageView.image = IMAGE(@"qianbaosy_icon_yun_default");
    WeakSelf(weakSelf);
    
    [self.backGroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.top.equalTo(weakSelf);
    }];
    
    [self.accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(weakSelf).offset(BOS_W(15));
        make.top.equalTo(weakSelf).offset(BOS_H(15));
    }];
    
    [self.balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(weakSelf.accountLabel);
        make.bottom.equalTo(weakSelf).offset(-BOS_H(15));
    }];
    
    [self.cloudImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.accountLabel).offset(1.5);
        make.leading.equalTo(weakSelf.accountLabel.mas_trailing).offset(BOS_W(9));
        make.height.width.mas_equalTo(BOS_W(15));
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



@interface ThirdTableviewCell()



@end

@implementation ThirdTableviewCell
- (void)initSubViews {
    [super initSubViews];
    [self addSubview:self.selectStatusButton];
    WeakSelf(weakSelf);
    [self.selectStatusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.right.equalTo(weakSelf).mas_offset(-BOS_W(15));
        make.width.height.mas_equalTo(BOS_W(15));
    }];
    
}
- (UIButton *)selectStatusButton {
    if (!_selectStatusButton) {
        _selectStatusButton = [BOSTools buttonWithFrame:CGRectZero font:nil textColor:nil backColor:nil target:nil action:nil text:nil image:IMAGE(@"home_icon_nochoice_default") cornerRadius:0 superView:nil];
        [_selectStatusButton setImage:IMAGE(@"home_icon_right_default") forState:UIControlStateSelected];
        _selectStatusButton.userInteractionEnabled = NO;
    }
    return _selectStatusButton;
}
-(void)setIsSelect:(BOOL)isSelect {
    _isSelect = isSelect;
    self.selectStatusButton.selected = isSelect;
}


@end
