////  CreatWalletTableViewCell.m
//  BOS
//
//  Created by BOS on 2018/12/18.
//  Copyright © 2018 BOS. All rights reserved.
//

#import "CreatWalletTableViewCell.h"

@interface CreatWalletTableViewCell ()<YYTextViewDelegate>
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) YYTextView *content;
@property (nonatomic, strong) UILabel *tipsLab;
@end

@implementation CreatWalletTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.titleLab];
        [self.contentView addSubview:self.rightBtn];
        [self.contentView addSubview:self.content];
        [self.contentView addSubview:self.tipsLab];
        WeakSelf(weakSelf);
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.contentView).offset(BOS_H(15));
            make.leading.equalTo(weakSelf.contentView).offset(15);
            make.height.mas_equalTo(BOS_H(20));
            make.width.mas_equalTo(BOS_W(200));
        }];
        
        [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(weakSelf.contentView).offset(-15);
            make.centerY.equalTo(weakSelf.titleLab);
            make.height.equalTo(weakSelf.titleLab);
        }];
        [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.titleLab.mas_bottom).offset(BOS_H(10));
            make.leading.equalTo(weakSelf.contentView).offset(15);
            make.trailing.equalTo(weakSelf.contentView).offset(-15);
        }];
        
        [self.tipsLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.content.mas_bottom).offset(BOS_H(5));
            make.leading.trailing.equalTo(weakSelf.content);
            make.height.mas_equalTo(BOS_H(15));
            make.bottom.equalTo(weakSelf.contentView).offset(-BOS_H(5));
        }];
    }
    return self;
}


#pragma mark lazyloading

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = FONTNAME(@"HelveticaNeue", 14);
        _titleLab.textColor = COLOR(@"333333 ");
    }
    return _titleLab;
}

- (YYTextView *)content{
    if (!_content) {
        _content = [[YYTextView alloc] init];
        _content.textColor = COLOR(@"333333");
        _content.placeholderFont = FONTNAME(@"HelveticaNeue", 14);
        _content.placeholderTextColor = COLOR(@"BEBEBE");
        _content.backgroundColor = COLOR(@"EFF2F6");
        _content.layer.cornerRadius = 4;
        _content.delegate = self;
        _content.returnKeyType = UIReturnKeyDone;
    }
    return _content;
}

- (UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.titleLabel.font = FONTNAME(@"HelveticaNeue", 12);
        [_rightBtn setTitleColor:COLOR(@"A2AAB6") forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

- (UILabel *)tipsLab{
    if (!_tipsLab) {
        _tipsLab = [[UILabel alloc]  init];
        _tipsLab.font = FONTNAME(@"HelveticaNeue", 12);
    }
    return _tipsLab;
}

#pragma mark dataSource

- (void)setCellWithModel:(CreatWalletModel *)model{
    self.model = model;
    self.titleLab.text = model.titleStr;
    if ([BOSTools isBlankString:model.btnTitle]) {
        self.rightBtn.hidden = YES;
    }else{
        self.rightBtn.hidden = NO;
        self.rightBtn.tag = model.btnTag;
        [self.rightBtn setTitle:model.btnTitle forState:UIControlStateNormal];
        [self.rightBtn setImage:IMAGE(model.btnImage) forState:UIControlStateNormal];
        [self.rightBtn setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
    }
    self.content.placeholderText = model.placeholder;
    self.content.text = model.contentStr;
    if (model.cellHeight.doubleValue == 115) {
        self.content.font = FONTNAME(@"HelveticaNeue", 20);
        self.content.textVerticalAlignment = YYTextVerticalAlignmentCenter;
        self.content.scrollEnabled = NO;
    }else{
        self.content.font = FONTNAME(@"HelveticaNeue", 14);
        self.content.textVerticalAlignment = YYTextVerticalAlignmentTop;
    }

    
    if ([BOSTools isBlankString:model.tips]) {
        self.tipsLab.hidden = YES;
    }else{
        self.tipsLab.text = model.tips;
        self.tipsLab.textColor = COLOR(model.tipsColor);
        self.tipsLab.hidden = NO;
    }
}


- (IBAction)rightBtnAction:(id)sender{
    if ([_delegate respondsToSelector:@selector(clickRightBtn:)]) {
        [_delegate clickRightBtn:self.rightBtn];
    }
}

#pragma mark - textView 的代理
- (void)textViewDidChange:(YYTextView *)textView{
    NSString * text = textView.text;
    if ([text containsString:@"\n"]) {
       text = [text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        textView.text = text;
        self.model.contentStr = text;
        [self endEditing:YES];
    }
    
}
@end
