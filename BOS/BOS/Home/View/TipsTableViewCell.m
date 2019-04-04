////  TipsTableViewCell.m
//  BOS
//
//  Created by BOS on 2018/12/19.
//  Copyright © 2018 BOS. All rights reserved.
//

#import "TipsTableViewCell.h"

@interface TipsTableViewCell ()
@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UILabel *titleLab;

@property (nonatomic, strong) UILabel *tipsLab;

@end

@implementation TipsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self addSubview:self.bgView];
        
        [self.bgView addSubview:self.titleLab];

        [self.bgView addSubview:self.tipsLab];
        
        WeakSelf(weakSelf);
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.equalTo(weakSelf);
            make.bottom.equalTo(weakSelf.tipsLab.mas_bottom).offset(BOS_H(15));
        }];
        
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.bgView);
            make.leading.equalTo(weakSelf.bgView).offset(15);
            make.trailing.equalTo(weakSelf.bgView).offset(-15);
            make.height.mas_equalTo(BOS_H(20));
        }];

        [self.tipsLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.titleLab.mas_bottom).offset(BOS_H(5));
            make.leading.trailing.equalTo(weakSelf.titleLab);
            make.bottom.equalTo(weakSelf).offset(-BOS_H(15));
        }];
    }
    return self;
}

#pragma mark lazyloading

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = COLOR(@"FFFFFF");
    }
    return _bgView;
}

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = FONTNAME(@"HelveticaNeue", 14);
        _titleLab.textColor = COLOR(@"E65062");
    }
    return _titleLab;
}

- (UILabel *)tipsLab{
    if (!_tipsLab) {
        _tipsLab = [[UILabel alloc]  init];
        _tipsLab.font = FONTNAME(@"HelveticaNeue", 14);
        _tipsLab.numberOfLines = 0;
    }
    return _tipsLab;
}

#pragma mark dataSource

- (void)setCellWithModel:(CreatWalletModel *)model{
    
    self.titleLab.text = model.titleStr;
    self.tipsLab.text = model.tips;
    self.tipsLab.textColor = COLOR(model.tipsColor);
}
@end
