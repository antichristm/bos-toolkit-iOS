////  RedPacketAccountHistoryTableViewCell.m
//  BOS
//
//  Created by BOS on 2019/1/4.
//  Copyright © 2019年 BOS. All rights reserved.
//



#import "RedPacketAccountHistoryTableViewCell.h"
@interface RedPacketAccountHistoryTableViewCell()

@property (nonatomic, strong) UIView *backView;


@end

@implementation RedPacketAccountHistoryTableViewCell

-(void)checkClick{
    if ([self.delegate respondsToSelector:@selector(RedPacketAccountHistoryCheck:)]) {
        [self.delegate RedPacketAccountHistoryCheck:self.index];
    }
    
}

-(void)deletClick{
    if ([self.delegate respondsToSelector:@selector(RedPacketAccountHistoryDelete:)]) {
        [self.delegate RedPacketAccountHistoryDelete:self.index];
    }
}

- (void)creatUI {
    self.selectionStyle = 0;
    self.backgroundColor = COLOR(@"#F5F5F5");
    [self.contentView addSubview:self.backView];
    [self.backView addSubview:self.titleLabel];
    [self.backView addSubview:self.timeLabel];
    [self.backView addSubview:self.chekButton];
    [self.backView addSubview:self.deleteButton];
    
    WeakSelf(weakSelf);
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(weakSelf).mas_offset(BOS_W(10));
        make.right.equalTo(weakSelf).mas_offset(-BOS_W(10));
        make.bottom.equalTo(weakSelf);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.backView.mas_centerY).mas_offset(2);
         make.left.equalTo(weakSelf.backView).mas_offset(BOS_W(15));
        make.right.lessThanOrEqualTo(weakSelf.chekButton.mas_left);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.titleLabel);
        make.right.lessThanOrEqualTo(weakSelf.chekButton.mas_left);
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).mas_offset(3);
    }];
    CGSize size = [self.deleteButton.titleLabel sizeThatFits:CGSizeMake(300, 60)];
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
         make.centerY.equalTo(weakSelf.backView);
        make.right.equalTo(weakSelf.backView).mas_offset(-BOS_W(15));
        make.height.mas_equalTo(BOS_H(30));
        make.width.mas_equalTo(size.width + BOS_W(30));
    }];
    size = [self.chekButton.titleLabel sizeThatFits:CGSizeMake(300, 60)];
    [self.chekButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.backView);
        make.right.equalTo(weakSelf.deleteButton.mas_left).mas_offset(-BOS_W(15));
        make.height.mas_equalTo(BOS_H(30));
        make.width.mas_equalTo(size.width + BOS_W(30));
    }];
}

-(void)setTitleString:(NSString *)titleString{
    _titleString = titleString;
    self.titleLabel.text = titleString;
}

- (void)setTimeString:(NSString *)timeString{
    _timeString = timeString;
    NSTimeInterval time = [timeString doubleValue];
    self.timeLabel.text = [BOSTools timeT:time stringFormatter:@"yyyy-MM-dd hh:mm:ss"];
}

- (UIView *)backView{
    if (!_backView) {
        _backView = [BOSTools viewWithFrame:CGRectZero color:COLOR(@"FFFFFF") cornerRadius:8 superView:nil];
    }
    return _backView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [BOSTools labelWithFrame:CGRectZero font:FONT(20) color:COLOR(@"333333") alpha:1 textAlignment:NSTextAlignmentLeft text:nil superView:nil];
    }
    return _titleLabel;
}
- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [BOSTools labelWithFrame:CGRectZero font:FONT(12) color:COLOR(@"999999") alpha:1 textAlignment:NSTextAlignmentLeft text:nil superView:nil];
    }
    return _timeLabel;
}

- (UIButton *)chekButton {
    if (!_chekButton) {
        _chekButton = [BOSTools buttonWithFrame:CGRectZero font:FONT(12) textColor:COLOR(@"#228BE9") backColor:nil target:self action:@selector(checkClick) text:NSLocalizedString(@"检测并导入", nil) image:nil cornerRadius:4 superView:nil];
        _chekButton.layer.borderWidth = 1;
        _chekButton.layer.borderColor = COLOR(@"#228BE9").CGColor;
    }
    return _chekButton;
}

- (UIButton *)deleteButton {
    if (!_deleteButton) {
        _deleteButton = [BOSTools buttonWithFrame:CGRectZero font:FONT(12) textColor:COLOR(@"#CE2344") backColor:nil target:self action:@selector(deletClick) text:NSLocalizedString(@"删除", nil) image:nil cornerRadius:4 superView:nil];
        _deleteButton.layer.borderWidth = 1;
        _deleteButton.layer.borderColor = COLOR(@"#CE2344").CGColor;
    }
    return _deleteButton;
}

@end


@implementation RedPacketHBHistoryTableViewCell

- (void)creatUI {
    [super creatUI];
    self.chekButton.hidden = YES;
    self.deleteButton.hidden = YES;
    WeakSelf(weakSelf);
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.backView.mas_centerY).mas_offset(2);
        make.left.equalTo(weakSelf.backView).mas_offset(BOS_W(15));
//        make.right.lessThanOrEqualTo(weakSelf.backView.mas_left);
    }];
    [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.titleLabel);
//        make.right.lessThanOrEqualTo(weakSelf.backView.mas_left);
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).mas_offset(3);
    }];
}

- (void)configModel:(id)model{
    if ([model isKindOfClass:[RedModel class]]) {
        RedModel * redModel = (RedModel *)model;
        NSAttributedString * account = [BOSTools attributString:[NSString stringWithFormat:@"%.4f",[[BOSTools doubleToDecimal:redModel.amount.doubleValue length:4 mode:NSRoundDown] doubleValue]] color:COLOR(@"333333") font:FONT(20) Spac:3 textAligment:NSTextAlignmentLeft attribute:nil];
         NSAttributedString * bos = [BOSTools attributString:@" BOS" color:COLOR(@"333333") font:FONT(12) Spac:3 textAligment:NSTextAlignmentLeft attribute:nil];
        NSMutableAttributedString * accountAtt = [[NSMutableAttributedString alloc] init];
        [accountAtt appendAttributedString:account];
        [accountAtt appendAttributedString:bos];
        self.titleLabel.attributedText = accountAtt;
        NSString * getString = [NSString stringWithFormat:NSLocalizedString(@"已领取%d/%@   ", nil),redModel.claims.count , redModel.count];
        NSString * time = [[BOSTools timeT:redModel.expire.doubleValue - 24*3600 stringFormatter:@"yyyy-MM-dd hh:mm:ss"] stringByAppendingString:NSLocalizedString(@" 创建", nil)];
        
         NSAttributedString * getAccount = [BOSTools attributString:getString color:COLOR(@"#666666") font:FONT(12) Spac:3 textAligment:NSTextAlignmentLeft attribute:nil];
         NSAttributedString * timeAtt = [BOSTools attributString:time color:COLOR(@"#999999") font:FONT(12) Spac:3 textAligment:NSTextAlignmentLeft attribute:nil];
        
        NSMutableAttributedString * detailAtt = [[NSMutableAttributedString alloc] init];
        [detailAtt appendAttributedString:getAccount];
        [detailAtt appendAttributedString:timeAtt];
        self.timeLabel.attributedText = detailAtt;
    }
}

@end

